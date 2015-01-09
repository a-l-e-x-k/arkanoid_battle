using System;
using System.Collections;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    [RoomType("basic")]
    /**
	 * Does basic functions for user. Like changing powerups setting, selecting game type, etc 
	 */
    public class BasicRoom : Game<Player>
    {
        private const int awaitingTime = 4000;
            //amount of milliseconds to wait till players will join (otherwise NPC will be created)

        private Game _game;
        private SnapshotSaver _snapshotSaver;
        private UsersManager _usersManager;
        private Timer awaitingTimer; //waiting till other players will join up

        public bool gameOpened = true;
        public Maps maps;
        public PlayerEnergyTimer playerEnergyTimer;
        public Random rand = new Random();
        public StatisticsManager statisticsManager;
        public VersionManager versionManager;

        public ArrayList playingUsers
        {
            get { return _usersManager.users; }
        }

        public Game game
        {
            get { return _game; }
        }

        public override void GameStarted()
        {
            _usersManager = new UsersManager(this);
            maps = new Maps(this);
            playerEnergyTimer = new PlayerEnergyTimer();
            statisticsManager = new StatisticsManager(this);
            versionManager = new VersionManager(this);
            PreloadPlayerObjects = true;
            Visible = true;
        }

        public override void UserJoined(Player player)
        {
            _usersManager.onPlayerJoined(player);
        }

        public override void GotMessage(Player player, Message message)
        {
            switch (message.Type)
            {
                case MessageTypes.BATTLE_REQUEST_ACCEPTED:
                    _usersManager.onBattleRequestAccepted(player);
                    break;
                case MessageTypes.BATTLE_REQUEST_DENIED:
                    _usersManager.onBattleRequestDenied(player);
                    break;
                case MessageTypes.CHAT_MESSAGE:
                    saveChatMessage(message.GetString(0), player, player.PlayerObject.GetInt(DBProperties.RANK_NUMBER));
                    break;
                case MessageTypes.OPEN_DOORS:
                    openRoom(message.GetString(0), message.GetString(1), player);
                    break;
                case MessageTypes.IM_READY:
                    _usersManager.onGuestReady(player);
                    break;
                case MessageTypes.PLAY_AGAIN:
                    playAgain(player, message.GetString(0), message.GetString(1));
                    break;
                case MessageTypes.LEAVE_GAME:
                    _usersManager.onPlayerLeaving(player);
                    break;
                case MessageTypes.CHANGE_SPELL_SLOT:
                    changeSpellSlot(player, message.GetString(0), message.GetInt(1));
                    break;
                case MessageTypes.ACTIVATE_SPELL:
                    PurchaseManager.activateSpell(player, message.GetString(0));
                    break;
                case MessageTypes.BUY_ARMOR:
                    PurchaseManager.buyArmor(player, message.GetString(0));
                    break;
                case MessageTypes.BUY_ENERGY:
                    PurchaseManager.buyEnergy(player, message.GetString(0));
                    break;
                case MessageTypes.BUY_BOUNCER:
                    PurchaseManager.buyBouncer(player, message.GetString(0));
                    break;
                case MessageTypes.CANCEL_BATTLE_REQUEST:
                    _usersManager.roomCreator.Send(MessageTypes.CANCEL_BATTLE_REQUEST);
                    break;
                case MessageTypes.START_SNAPSHOT_RECORDING:
                    _snapshotSaver = new SnapshotSaver(this, message.GetString(0), message.GetInt(1), message.GetInt(2));
                    break;
                case MessageTypes.SAVE_SNAPSHOT:
                    _snapshotSaver.writeSnapshot(message.GetByteArray(0));
                    break;
                case MessageTypes.FINISH_SNAPSHOT_RECORDING:
                    _snapshotSaver.finishRecording();
                    break;
                case MessageTypes.TURN_MUSIC_ONOFF:
                    player.turnMusicOnoff(message.GetBoolean(0));
                    break;
                case MessageTypes.TURN_SOUNDS_ONOFF:
                    player.turnSoundsOnoff(message.GetBoolean(0));
                    break;
                default:
                    if (_game != null)
                        _game.handleGameMessage(player, message);
                    break;
            }
        }

        /**
		 * Room creator did not found other rooms which are awaiting opponents
		 * Making room visible for others
		 */

        private void openRoom(string type, string mapID, Player player)
        {
            Console.WriteLine("open room by: " + player.realID);

            if ((RoomData.ContainsKey("open") && RoomData["open"] == "1") || player.ready)
                throw new Exception("Trying to open already opened room!");

            Console.WriteLine("openRoom");
            //TODO: clean prev game
            RoomData["gameType"] = type;
            RoomData["open"] = "1";
            RoomData["mapID"] = mapID;
            RoomData.Save();

            _usersManager.addToPlayingUsers(player);

            initGame(type, mapID);

            awaitingTimer = ScheduleCallback(forceGameStart, awaitingTime);
        }

        public void initGame(string type, string mapID)
        {
            if (type == GameTypes.FAST_SPRINT)
                _game = new FastSprintGame(type, mapID, this);
            else if (type == GameTypes.BIG_BATTLE)
                _game = new BigBattleGame(type, mapID, this);
        }

        private void forceGameStart()
        {
            Console.WriteLine("forceGameStart");
            _game.forceStart();
            stopAwaitingTimer();
        }

        public void onGameStarted()
        {
            Console.WriteLine("onGameStarted");
            RoomData["open"] = "0"; //not opened anymore
            RoomData.Save();
            stopAwaitingTimer();
        }

        private void stopAwaitingTimer()
        {
            Console.WriteLine("stopAwaitingTimer");
            if (awaitingTimer != null)
            {
                awaitingTimer.Stop();
                awaitingTimer = null;
            }
        }

        private void playAgain(Player player, string gameType, string mapID)
        {
            //need to pass game type all the way from client because _game object is destroyed already and we don't know previous game type
            //cleanup should be called by now (at game finish)
            Console.WriteLine("playAgain");
            if (player.isRoomCreator)
                openRoom(gameType, mapID, player);
            else
                _usersManager.onGuestReady(player);
        }

        private void changeSpellSlot(Player sender, string spellName, int slotID)
        {
            sender.changeSpellSlot(spellName, slotID);
        }

        private void saveChatMessage(string message, Player pl, int rank)
        {
            if (message.Length > 0 && message.Length < 70 && !pl.isGuest) //double-check (client checks that as well)
            {
                double millisecondsPart = Math.Round((DateTime.UtcNow - new DateTime(2015, 1, 1)).TotalMilliseconds, 1);
                var msg = new DatabaseObject();
                msg.Set("m", message); //message
                msg.Set("u", pl.realID); //user id
                msg.Set("d", millisecondsPart); //date
                msg.Set("r", rank); //rank
                PlayerIO.BigDB.CreateObject("ChatMessages", millisecondsPart.ToString(), msg,
                    delegate { Console.WriteLine("Message saved successfully!"); });
            }
        }

        public void cleanUp()
        {
            _usersManager.cleanUp();
            _game = null;
        }

        public void handleError(PlayerIOError error)
        {
            PlayerIO.ErrorLog.WriteError(error.Message, error);
        }

        public override void UserLeft(Player player)
        {
            _usersManager.onPlayerLeftRoom(player);
        }

        public override void GameClosed()
        {
            gameOpened = false;
        }
    }
}