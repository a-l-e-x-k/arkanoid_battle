using System;
using System.Collections;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public class TickArgs : EventArgs
    {
        public double bouncerX;
        public string criticalHits;
        public string executedRequests;

        public TickArgs(double bouncerXX, string hps, string exr)
        {
            bouncerX = bouncerXX;
            criticalHits = hps;
            executedRequests = exr;
        }
    }

    public class CellClearedArgs : EventArgs
    {
        public int cellType;

        public CellClearedArgs(int cellTypee)
        {
            cellType = cellTypee;
        }
    }

    public class Player : BasePlayer
    {
        protected string _gameType;
        public bool finishedGame; //set to true when last request got from player
        public bool isRoomCreator;
        public int points;
        public bool ready; //set to true / false when player sends message like "playagain", joins room, etc
        public string realID = "";

        public BasicRoom roomLink;
            //at NPCPlayer it is already set at instantiation. Thus on startGame() link is overritten (not very good)

        public FieldSimulation sim;

        public SpellUseCounter spellUseCounter;

        public bool isGuest
        {
            get { return realID == "simpleguest"; }
        }

        public event EventHandler ClearedFireballCell;
        public event EventHandler BallLost;
        public event EventHandler tick;
        public event EventHandler GameFinished;

        public void startGame(string gameType, int gameLength, string mapsProgram, string oppIDs,
            string oppPanelConfigurations, string oppBouncerIDs, int energyConsumed)
        {
            Console.WriteLine("start game: " + realID + " game length: " + gameLength);
            finishedGame = false;
            ready = false;
            points = 0;

            _gameType = gameType;

            initFieldSimulation(mapsProgram);
            initTimer();
            sim.FieldCleared += onUserFieldCleared;
            sim.BallLost += onLostBall;
            sim.CellCleared += onCellCleared;
            sim.GameFinished += onGameFinished;
            sim.ballsManager.currentSpeed = Speed.MEDIUM;

            spellUseCounter = new SpellUseCounter();

            sendMessage(getStartGameMessage(mapsProgram, oppIDs, gameType, gameLength, oppPanelConfigurations,
                oppBouncerIDs, energyConsumed));
        }

        protected virtual Message getStartGameMessage(string mapsProgram, string oppIDs, string gameType, int gameLength,
            string oppPanelConfigurations, string oppBouncerIDs, int energyConsumed)
        {
            Message m = Message.Create(MessageTypes.START_GAME);
            m.Add(mapsProgram);
            m.Add(oppIDs);
            m.Add(oppPanelConfigurations);
            m.Add(oppBouncerIDs);
            m.Add(gameType);
            m.Add(sim.ballsManager.currentSpeed);
            m.Add(BallsManager.TEST_BALLS_NUMBER);
            m.Add(gameLength);
            m.Add(energyConsumed);
            m.Add(Utils.unixSecs() + GameConfig.ENERGY_REFILL_INTERVAL); //so we can show "More in XX:XX" tooltip
            return m;
        }

        public void addAllowedSpell(int requestID)
        {
            spellUseCounter.addAllowed(requestID);
        }

        private void onGameFinished(object sender, EventArgs args)
        {
            EventHandler handler = GameFinished;
            handler(this, EventArgs.Empty);
        }

        public virtual void finishGame()
        {
            finishedGame = true;
        }

        protected virtual void initFieldSimulation(string mapsProgram)
        {
            sim = new FieldSimulation(mapsProgram, this);
        }

        public virtual void speedUp(string speeduperID, int speeduperTick)
        {
            Tracer.t("speedUp", Relations.PLAYER_FIELD);
            int nextSpeed = SpeedProgram.getNextSpeed(_gameType, sim.ballsManager.currentSpeed);
            addAwaitingRequest(GameRequest.SPEED_UP, nextSpeed.ToString());
            sendMessage(MessageTypes.SPEED_UP, nextSpeed, speeduperID, speeduperTick);
                //client will add & execute SpeedUp request at tick where his opp added it and send server back executed request			
        }

        public virtual void goWiggle()
        {
            Console.WriteLine("!!!! goWiggle: " + realID + " send message: " + MessageTypes.CHARM_BALLS);
            addAwaitingRequest(GameRequest.CHARM_BALLS);
            sendMessage(MessageTypes.CHARM_BALLS);
                //client will add & execute Charm request at some tick and send server back executed request			
        }

        public virtual void goFreeze()
        {
            Console.WriteLine("!!!! goFreeze: " + realID);
            addAwaitingRequest(GameRequest.FREEZE);
            sendMessage(MessageTypes.FREEZE);
                //client will add & execute Freeze request at some tick and send server back executed request			
        }

        public virtual void goLaunchRocket()
        {
            Console.WriteLine("!!!! goLaunchRocket: " + realID);
            addAwaitingRequest(GameRequest.ROCKET);
            sendMessage(MessageTypes.ROCKET);
                //client will add & execute Rocket request at some tick and send server back executed request			
        }

        public void onTick(double bouncerX, string criticalHits, string executedRequestsData)
        {
            sim.simulateEightTicks(criticalHits, executedRequestsData);
            var args = new TickArgs(bouncerX, criticalHits, string.Join("$", sim.requestsExecutedAt8Ticks.ToArray()));
            if (finishedGame)
                Console.WriteLine("Sending last piece of data to opp (with finish req): ex req: " +
                                  args.executedRequests + " crit hits: " + args.criticalHits);

            dispatchTickData(args);
        }

        protected void dispatchTickData(TickArgs args)
        {
            tick(this, args);
        }

        protected void onUserFieldCleared(object sender, EventArgs args)
        {
            switchToNewMap();
        }

        protected virtual void switchToNewMap()
        {
            addAwaitingRequest(GameRequest.NEW_MAP);
                //player will soon send tick data with this request executed (preset switch will happed at client as well)
        }

        private void addAwaitingRequest(int reqID, string data = "")
        {
            //add request which normally will be deleted when executing request sent from client. Though if client fakes and ain't sending request, we'll force it
            sim.awaitingRequests.add(sim.ballsManager.currentTick + 1000000, new GameRequestData(reqID, data));
                //+ 100000 turn "auto-execution on timeout" off for now. Less bugggy
        }

        public virtual void sendMessage(string type, params object[] parameters)
        {
            Send(type, parameters);
        }

        public virtual void sendMessage(Message msg)
        {
            Send(msg);
        }

        private void onLostBall(object sender, EventArgs args)
        {
            Tracer.t("Player lost ball", Relations.PLAYER_FIELD);
            EventHandler handler = BallLost; //other guy will receive some spoints
            if (handler != null)
                handler(this, EventArgs.Empty);
        }

        private void onCellCleared(object sender, EventArgs args)
        {
            addPoints(PointsPrizes.CELL_CLEARED);
            if (((CellClearedArgs) args).cellType == Maps.FIRE_BRICK)
            {
                EventHandler handler = ClearedFireballCell;
                handler(this, EventArgs.Empty);
            }
        }

        /**
		 * Returns JSON string with panel configuration ("skillName - slotID" pairs) 
         * Used for getting other opponent's panel config
		 **/

        public string getPanelConfigString()
        {
            string result = "{";
            var spells = new ArrayList();
            DatabaseObject spellsConfiguration = getSpellsConfig();
            DatabaseObject spellObject;
            int spellPlace;
            foreach (string property in spellsConfiguration.Properties)
            {
                spellObject = (DatabaseObject) spellsConfiguration[property];
                spellPlace = spellObject.GetInt(DBProperties.SPELL_SLOT);
                if (spellPlace != -1) //if spell is at panel
                {
                    spells.Add("\"" + property + "\":\"" + spellPlace + "\"");
                }
            }
            result += string.Join(",", spells.ToArray());
            result += "}";
            return result;
        }

        public virtual string getBouncerID()
        {
            return PlayerObject.GetString(DBProperties.BOUNCER_ID);
        }

        public int getRequestIDForSlotID(int slotID)
        {
            int requestID = -1;
            DatabaseObject spellsConfiguration = getSpellsConfig();
            DatabaseObject spell;
            foreach (string property in spellsConfiguration.Properties)
            {
                spell = (DatabaseObject) spellsConfiguration[property];
                if (spell.GetInt(DBProperties.SPELL_SLOT) == slotID)
                {
                    requestID = GameRequest.getRequestIDBySpellName(property);
                    break;
                }
            }
            return requestID;
        }

        public void changeSpellSlot(string spellName, int slotID)
        {
            if (isGuest)
                return;

            DatabaseObject spells = getSpellsConfig();
            DatabaseObject spell = spells.GetObject(spellName);
            if (spell == null)
            {
                //happens when spell was just activated - wait until fact of activation will be saved to PlayerObject
                roomLink.ScheduleCallback(delegate { changeSpellSlot(spellName, slotID); }, 1000);
            }
            else if (this != null) //oh, heavens!
            {
                spell.Set(DBProperties.SPELL_SLOT, slotID);
                PlayerObject.Save();
            }
        }

        public void addPoints(int amount)
        {
            points += amount;
            Console.WriteLine("Player points changed: " + points + " current tick: " + sim.ballsManager.currentTick +
                              " added: " + amount + (this is NPCPlayer ? " [NPC]" : " [Player]"));
        }

        public void turnMusicOnoff(bool state)
        {
            if (realID == "simpleguest")
                return;

            PlayerObject.Set(DBProperties.MUSIC_ON, state);
            PlayerObject.Save();
        }

        public void turnSoundsOnoff(bool state)
        {
            if (realID == "simpleguest")
                return;

            PlayerObject.Set(DBProperties.SOUNDS_ON, state);
            PlayerObject.Save();
        }

        public int getRankProtectionCount()
        {
            int count = 0;
            //Commented down so that game runs on the Free Playerio plan (not paying for services for now)
            //foreach (VaultItem item in PayVault.Items)
            //{
            //    if (item.ItemKey == ShopItemsInfo.ARMOR_ITEM)
            //        count++;
            //}
            return count;
        }

        public virtual DatabaseObject getSpellsConfig()
        {
            return PlayerObject.GetObject(DBProperties.SPELL_OBJECT);
        }

        protected virtual void initTimer()
        {
        }

        public void setRoomLink(BasicRoom room)
        {
            //called on player when he joined a room
            roomLink = room;
        }
    }
}