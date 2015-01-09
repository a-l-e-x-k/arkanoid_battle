using System;
using System.Collections;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public abstract class Game
    {
        private readonly SpellChecker _spellChecker = new SpellChecker();
        public int capacity = 2;
        public int gameLength = -1; //-1 if not a time limited game, otherwise - game length in seconds
        public string gameType;
        public string mapID; //-1 if no map needed, otherwise game starts with specified map

        protected BasicRoom roomLink;

        public Game(string type, string mapId, BasicRoom roomLink, int ggameLength = -1)
        {
            this.roomLink = roomLink;
            gameType = type;
            mapID = mapId;
            gameLength = ggameLength;
            tryStartGame();
        }

        public SpellChecker spellChecker
        {
            get { return _spellChecker; }
        }

        /**
		 * Starts game if everyone is ready
		 */

        public void tryStartGame()
        {
            if (getReadyCount() == capacity)
            {
                string mapsProgram = mapID == "-1" ? roomLink.maps.getMapProgram(gameType) : mapID;
                mapID = mapsProgram; //will be used if game is FAST_SPRINT for updating stars (mapsProgam is of 1 map)
                string oppIDs = "";
                string oppPanelConfigurations = "";
                foreach (Player pl in roomLink.playingUsers)
                {
                    int energyConsumed = PlayerUpdater.consumeEnergy(pl, gameType);
                    oppIDs = string.Join(",", getOtherPlayersIDs(pl).ToArray());
                    oppPanelConfigurations = string.Join(",", getOtherPlayersPanelConfiguraions(pl).ToArray());
                    pl.startGame(gameType, gameLength, mapsProgram, oppIDs, oppPanelConfigurations,
                        getOtherPlayersBouncerIDs(pl), energyConsumed);
                    pl.BallLost += playerLostBall;
                    pl.tick += onPlayerTick;
                    pl.ClearedFireballCell += playerClearedFireballCell;
                    pl.GameFinished += onPlayerFinishedGame;
                    //if (!(pl is NPCPlayer))
                    //    pl.PayVault.Refresh(delegate() { /**Do nothing, just for the sake of refreshing. So that we can use it on game finish quickly**/ });
                }

                roomLink.onGameStarted();
                specificGameStart();
            }
            else
                Console.WriteLine("Tried starting game with " + getReadyCount() + " players. Needed: " + capacity);
        }

        public void forceStart()
        {
            Console.WriteLine("forceStart");
            if (roomLink.playingUsers.Count < capacity)
                //TODO: add && condition which will be true if user waits for too long
            {
                int guysNeeded = capacity - getReadyCount();
                for (int i = 0; i < guysNeeded; i++)
                {
                    var npc = new NPCPlayer(roomLink);
                    npc.ready = true;
                    roomLink.playingUsers.Add(npc);
                }
            }
            tryStartGame();
        }

        /**
		 * Handles game-specific messages (messages which are sent only during the game)
		 */

        public void handleGameMessage(Player player, Message msg)
        {
            switch (msg.Type)
            {
                case MessageTypes.TRY_USE:
                    tryUseSpell(msg.GetInt(0), player);
                    break;
                case MessageTypes.TICK:
                    player.onTick(msg.GetDouble(0), msg.GetString(1), msg.GetString(2));
                        //update sever duplication model
                    break;
                default:
                    handleSpecialGameMessage(msg);
                    break;
            }
        }

        private void tryUseSpell(int slotID, Player requester)
        {
            int requestID = requester.getRequestIDForSlotID(slotID);
            Console.WriteLine("Game: try use spell: reqID: " + requestID + " slotID: " + slotID);
            //Commented down so that game runs on the Free Playerio plan (not paying for services for now)
            //if (_spellChecker.playerIsElegible(requestID, slotID, requester) && specificPowerupCheck())
            //{
            if (requestID == GameRequest.CHARM_BALLS)
            {
                var opponent = getOtherPlayers(requester, true)[0] as Player;
                opponent.goWiggle();
            }
            else if (requestID == GameRequest.FREEZE)
            {
                var opponent = getOtherPlayers(requester, true)[0] as Player;
                opponent.goFreeze();
            }
            else if (requestID == GameRequest.ROCKET)
            {
                var opponent = getOtherPlayers(requester, true)[0] as Player;
                opponent.goLaunchRocket();
            }
            else
                //used for checking non-attacking spells. Because client insta-launches suvh spells we check them at server on execution
                requester.addAllowedSpell(requestID);
            //}
            //else //should not happen. Clicnt does all the checks. If we get here it means player is cheating 
            //{
            //    Console.WriteLine("Unexpected spell usage attempt", "PlayerID: " + requester.realID + " RequestID: " + requestID + " SlotID: " + slotID, "");
            //	roomLink.PlayerIO.ErrorLog.WriteError("Unexpected spell usage attempt", "PlayerID: " + requester.realID + " RequestID: " + requestID + " SlotID: " + slotID, "", null);
            //}	
        }

        private void onPlayerTick(object sender, EventArgs args)
        {
            var convertedArgs = (TickArgs) args;
            ArrayList oppsList = getOtherPlayers(sender as Player);
            foreach (Player pl in oppsList)
            {
                pl.Send(MessageTypes.TICK, convertedArgs.bouncerX, convertedArgs.criticalHits,
                    convertedArgs.executedRequests);
            }
        }

        private void playerClearedFireballCell(object sender, EventArgs args)
        {
            ArrayList otherPlayers = getOtherPlayers(sender as Player, true);
            foreach (Player player in otherPlayers) //speed up other guys
            {
                player.speedUp((sender as Player).realID, (sender as Player).sim.ballsManager.currentTick);
                Tracer.t(
                    "Player cleared fireball cell, speeding up " +
                    (player.sim is NPCFieldSimulation ? " [NPC]" : " [Player]"),
                    player.sim is NPCFieldSimulation ? Relations.NPC_FIELD : Relations.PLAYER_FIELD);
            }
        }

        private void playerLostBall(object sender, EventArgs args)
        {
            //TODO: instead of randomly selecting guys at the moment when points need to be added (powerup executed) use pre-calculated queue of randomly selected ids (thus client and server both know to which guy to apply it)
            ArrayList othersIDs = getOtherPlayersIDs(sender as Player);
            var luckyGuy = othersIDs[0] as string; //just picking 1st guy until random queue will be introduced
            foreach (Player pl in roomLink.playingUsers)
            {
                if (pl.realID == luckyGuy)
                    pl.addPoints(PointsPrizes.LOST_BALL);
            }
        }

        private ArrayList getOtherPlayers(Player firstDude, bool withNPC = false)
        {
            var result = new ArrayList();
            foreach (Player pla in roomLink.playingUsers)
            {
                if ((pla != firstDude && !(pla is NPCPlayer)) || (pla != firstDude && withNPC && pla is NPCPlayer))
                {
                    result.Add(pla);
                }
            }
            return result;
        }

        private ArrayList getOtherPlayersIDs(Player firstDude)
        {
            var result = new ArrayList();
            foreach (Player pla in roomLink.playingUsers)
            {
                if (pla != firstDude)
                {
                    result.Add(pla.realID);
                }
            }
            return result;
        }

        private ArrayList getOtherPlayersPanelConfiguraions(Player firstDude)
        {
            var result = new ArrayList();
            foreach (Player pla in roomLink.playingUsers)
            {
                if (pla != firstDude)
                {
                    result.Add(pla.getPanelConfigString());
                }
            }
            return result;
        }

        private string getOtherPlayersBouncerIDs(Player firstDude)
        {
            var result = new ArrayList();
            foreach (Player pla in roomLink.playingUsers)
            {
                if (pla != firstDude)
                {
                    result.Add(pla.getBouncerID());
                }
            }
            return string.Join(",", result.ToArray());
        }

        private int getReadyCount()
        {
            int result = 0;
            foreach (Player pla in roomLink.playingUsers)
            {
                if (pla.ready)
                {
                    result++;
                }
            }
            return result;
        }

        //called when player executed finishGame request
        private void onPlayerFinishedGame(object sender, EventArgs args)
        {
            (sender as Player).finishGame();

            foreach (Player pl in roomLink.playingUsers)
            {
                if (!pl.finishedGame)
                    return;
            }

            roomLink.ScheduleCallback(normalGameFinish, 30); //let NPCs send executed data over
        }

        private void normalGameFinish()
        {
            specialGameFinish();
            onGameFinished();
        }

        protected void makeNPCsFinish()
        {
            foreach (Player pl in roomLink.playingUsers)
            {
                if (pl is NPCPlayer)
                    (pl as NPCPlayer).addFinishGameRequest();
            }
        }

        //Called when game timer finishes. It is force finish because it is performed not based on GameFinish requests from players but on timer.
        protected void forceFinishGame()
        {
            onGameFinished(true);
        }

        protected void onGameFinished(bool force = false)
        {
            Console.WriteLine("onGameFinished: force: " + force);

            var playersData = new ArrayList();
            var winner = roomLink.playingUsers[0] as Player;
            bool draw = false;

            roomLink.statisticsManager.onGameFinish();

            foreach (Player pl in roomLink.playingUsers)
            {
                playersData.Add(pl.realID + ":" + pl.points);
                if (pl.points > winner.points)
                    winner = pl;
                else if (pl.points == winner.points && pl != winner)
                    //draw will be handled in same way as victory (everybody will receive prizes equal to winning prize)
                    draw = true;
            }

            Console.WriteLine("On game finish: draw: " + draw);

            string message = string.Join(",", playersData.ToArray());

            foreach (Player pl in roomLink.playingUsers)
            {
                pl.BallLost -= playerLostBall;
                pl.tick -= onPlayerTick;
                pl.ClearedFireballCell -= playerClearedFireballCell;
                pl.GameFinished -= onPlayerFinishedGame;

                if (!(pl is NPCPlayer))
                {
                    PlayerUpdateResult r = PlayerUpdater.updatePlayerPostGame(pl, pl == winner || draw, gameType, mapID,
                        roomLink.playingUsers);
                    pl.Send(MessageTypes.FINISH_GAME, message, force, r.coinsAdded, r.newRank, r.newRankProgress,
                        r.newRankProtectionCount);
                }
            }
            roomLink.cleanUp();
        }

        /**
		 * Handles messages which are specific to some game type 
		 * (this method is overriden in other classes)
		 */

        protected virtual void handleSpecialGameMessage(Message msg)
        {
        }

        protected virtual void specificGameStart()
        {
        }

        //returns true if powerup may be used; Overriden in TimeLimitedGame
        protected virtual bool specificPowerupCheck()
        {
            return true;
        }

        protected virtual void specialGameFinish()
        {
            //time limited game will stop timer
        }
    }
}