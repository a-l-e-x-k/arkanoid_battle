using System;
using System.Collections;

namespace ServerSide
{
    public class UsersManager
    {
        private readonly ArrayList _playingUsers = new ArrayList();
        private readonly RegistrationManager _registrationManager;
        private readonly BasicRoom _roomLink;

        private Player _battleRequestWaiter;
            //dude who want to have a battle with room creator. Link saved here for checks and convenience

        private Player _roomCreator;


        public UsersManager(BasicRoom roomLink)
        {
            _registrationManager = new RegistrationManager(roomLink);
            _roomLink = roomLink;
        }

        public ArrayList users
        {
            get { return _playingUsers; }
        }

        public Player roomCreator
        {
            get { return _roomCreator; }
        }

        public void onPlayerJoined(Player player)
        {
            if (player.JoinData["gameVersion"] != GameConfig.GAME_VERSION.ToString())
                //make sure client & server are of the same version always
            {
                //either client or server version is too old (if client - update fixes that, if server - user probably will catch new version next time)
                player.sendMessage(MessageTypes.GAME_UPDATED);
                player.Disconnect();
                return;
            }
            _roomLink.versionManager.checkVersion();
                //client & server may be the same, but old version. Check for new one.

            //Just set values here. Don't care much about what is player's intentions are ATM. 
            player.realID = player.ConnectUserId;
            player.setRoomLink(_roomLink);
            _registrationManager.checkIfNewbie(player);
            if (player.realID == _roomLink.RoomId || (player.isGuest && player.JoinData.ContainsKey("theboss")))
            {
                player.isRoomCreator = true;
                _roomCreator = player; //save link for convenience
                _roomLink.playerEnergyTimer.onRoomCreated(_roomCreator, _roomLink);
                    //do energy checks for creator, maybe start timer
                player.Send(MessageTypes.AUTH_DATA, player.PlayerObject.GetInt(DBProperties.ENERGY),
                    _roomLink.playerEnergyTimer.getTimeOfNextUpdate(), Utils.unixSecs());
            }

            if (player.JoinData.ContainsKey("safeBattle")) //wants to play safe battle
            {
                Console.WriteLine("Player join data contains safeBattle! : " + player.realID);
                if (_roomLink.game == null && _battleRequestWaiter == null)
                    //if not currently playing or awaiting game & nobody is not waiting for response anymore
                {
                    _battleRequestWaiter = player;
                    _roomCreator.Send(MessageTypes.BATTLE_REQUESTED, player.realID);
                }
                else
                {
                    player.Send(MessageTypes.PLAYER_PLAYING_ALREADY);
                    player.Disconnect();
                }
            }
            else
                Console.WriteLine("Player join data does not contain safeBattle! : " + player.realID);
        }

        public void onGuestReady(Player player)
        {
            Console.WriteLine("onGuestReady: " + player.realID);

            if (player.ready || _playingUsers.Contains(player))
                throw new Exception("Trying to set ready = true to guest which is ready already: " + player.realID);

            if (_playingUsers.Count < _roomLink.game.capacity)
            {
                addToPlayingUsers(player);
                _roomLink.game.tryStartGame();
            }
        }

        public void addToPlayingUsers(Player player)
        {
            player.ready = true;
            _playingUsers.Add(player);
        }

        /**
		 * Player decided not to "play again".
		 * If it is room owner - kick all other guys out
		 * If it was a guest - just disconnect him
		 */

        public void onPlayerLeaving(Player leaver)
        {
            if (leaver.isRoomCreator)
            {
                foreach (Player pl in _roomLink.Players)
                {
                    if (!pl.isRoomCreator)
                        pl.Disconnect();
                }
                cleanUp();
            }
            else
                leaver.Disconnect();
        }

        public void onPlayerLeftRoom(Player player)
        {
            if (player.isRoomCreator)
                _roomLink.statisticsManager.onCreatorLeftRoom(); //write down session length stats

            if (player == _battleRequestWaiter)
                _battleRequestWaiter = null;

            foreach (Player pl in _roomLink.Players)
            {
                pl.Send(MessageTypes.USER_LEFT, player.realID);
            }
        }

        public void onBattleRequestAccepted(Player player)
        {
            if (player == _roomCreator)
            {
                addToPlayingUsers(_battleRequestWaiter);
                addToPlayingUsers(player);
                _roomLink.initGame(GameTypes.FAST_SPRINT, "-1"); //and it should start right-away
                _battleRequestWaiter = null; //nullify the link (so that creator may be requested again)
            }
            else
                throw new Exception("Unexpected Battle Request Accepted message");
        }

        public void onBattleRequestDenied(Player player)
        {
            if (player == _roomCreator)
            {
                _battleRequestWaiter.Send(MessageTypes.BATTLE_REQUEST_DENIED);
                _battleRequestWaiter.Disconnect();
                _battleRequestWaiter = null;
            }
            else
                throw new Exception("Unexpected Battle Request Denied message");
        }

        public void cleanUp()
        {
            _playingUsers.Clear();
        }
    }
}