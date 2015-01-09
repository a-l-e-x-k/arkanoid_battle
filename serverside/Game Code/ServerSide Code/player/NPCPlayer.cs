using System;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public class NPCPlayer : Player
    {
        private readonly DatabaseObject _spells;
        private int _tickFrequency = 264; //will change over game so that player and NPC run on same piece
        private Timer _tickTimer;

        public NPCPlayer(BasicRoom ggameLink)
        {
            setRoomLink(ggameLink);
            realID = ggameLink.rand.Next(10000).ToString();
            _spells = new DatabaseObject();
            //TODO: random powerups here
            var splitPowerup = new DatabaseObject();
            splitPowerup.Set(DBProperties.SPELL_SLOT, 1);
            var lightning = new DatabaseObject();
            lightning.Set(DBProperties.SPELL_SLOT, 2);
            _spells.Set(Spells.SPLIT_IN_TWO, splitPowerup); //first panel slot
            _spells.Set(Spells.LIGHTNING_ONE, lightning); //second panel slot
        }

        protected override void initTimer()
        {
            if (roomLink.gameOpened)
                //game may be closed at the moment of creating NPC (e.g. player wanted to play but exit just before start)
            {
                _tickTimer = roomLink.AddTimer(onTick, _tickFrequency);
            }
        }

        protected override void initFieldSimulation(string mapsProgram)
        {
            sim = new NPCFieldSimulation(mapsProgram, this);
        }

        private void onTick()
        {
            (sim as NPCFieldSimulation).simulateEightTicks();
            var args = new TickArgs(sim.bouncer.x, string.Join(",", (sim as NPCFieldSimulation).criticalHits.ToArray()),
                string.Join("$", sim.requestsExecutedAt8Ticks.ToArray()));
            Console.WriteLine("SENDING NPCS HITS: " +
                              string.Join(",", (sim as NPCFieldSimulation).criticalHits.ToArray()));
            dispatchTickData(args);

            if (sim.ballsManager.currentTick%2 == 0 && !finishedGame)
                //every 0.5 sec frequency of _tickTimer's ticks is adjusted so that both player and NPC run on the same pace
                syncTimer();
        }

        private void syncTimer()
        {
            //get avg difference b/w player and npc
            int tickSum = 0;
            int playersCount = 0;
            foreach (Player pl in roomLink.playingUsers)
            {
                if (pl != this && pl.sim != null)
                    //don't care about meself + wait until simulation at player objects will be created (this happens when NPCPlayer gets game started before regular players do) + in some weird occasions player did not have a Sim property
                {
                    tickSum += pl.sim.ballsManager.currentTick;
                        //add 8 so that difference at game start does not matter much
                    playersCount++;
                }
            }

            int avgTickNumber = tickSum/playersCount;
            _tickFrequency += (sim.ballsManager.currentTick - avgTickNumber)/2;
                //slow timer down by the time it is ahead (on average)
            _tickFrequency = Math.Max(_tickFrequency, 50); //can't be less 50ms, otherwise timer goes nuts
            stopSimulation();
            initTimer(); //restart timer w new frequency
        }


        //Note that this func is called 1 sec before actual game finish. So that there is time for NPC to execute finish game request, send it over + client should play it.
        public void addFinishGameRequest()
        {
            Console.WriteLine("NPC added finish game request...");
            sim.outstandingRequests.add(sim.ballsManager.currentTick + 1,
                new GameRequestData(GameRequest.GAME_FINISH, ""));
        }

        public override void finishGame()
        {
            finishedGame = true;
            stopSimulation();
        }

        private void stopSimulation()
        {
            _tickTimer.Stop();
        }

        public override void speedUp(string speeduperID, int speeduperTick)
        {
            Console.WriteLine("Adding speedUp request for NPC", Relations.NPC_FIELD);
            sim.outstandingRequests.add(sim.ballsManager.currentTick + 1,
                new GameRequestData(GameRequest.SPEED_UP,
                    SpeedProgram.getNextSpeed(_gameType, sim.ballsManager.currentSpeed).ToString()));
        }

        public override void goWiggle()
        {
            Console.WriteLine("ADD goWiggle req (NPC): " + GameRequest.CHARM_BALLS);
            sim.outstandingRequests.add(sim.ballsManager.currentTick + 1, new GameRequestData(GameRequest.CHARM_BALLS));
        }

        public override void goFreeze()
        {
            Console.WriteLine("ADD goFreeze req (NPC): " + GameRequest.FREEZE);
            sim.outstandingRequests.add(sim.ballsManager.currentTick + 1, new GameRequestData(GameRequest.FREEZE));
        }

        public override void goLaunchRocket()
        {
            Console.WriteLine("ADD goLaunchRocket req (NPC): " + GameRequest.ROCKET);
            sim.outstandingRequests.add(sim.ballsManager.currentTick + 1, new GameRequestData(GameRequest.ROCKET));
        }

        protected override void switchToNewMap()
        {
            sim.outstandingRequests.add(sim.ballsManager.currentTick + 1, new GameRequestData(GameRequest.NEW_MAP));
        }

        public override string getBouncerID()
        {
            string[] allBouncers =
            {
                ShopItemsInfo.BOUNCER_STANDART_RED,
                ShopItemsInfo.BOUNCER_STANDART_BLUE,
                ShopItemsInfo.BOUNCER_STANDART_GREEN,
                ShopItemsInfo.BOUNCER_STANDART_PURPLE,
                ShopItemsInfo.BOUNCER_CHECKED_RED,
                ShopItemsInfo.BOUNCER_CHECKED_BLUE,
                ShopItemsInfo.BOUNCER_CHECKED_PURPLE,
                ShopItemsInfo.BOUNCER_CHECKED_BLACK,
                ShopItemsInfo.BOUNCER_ZAPPER_RED,
                ShopItemsInfo.BOUNCER_ZAPPER_BLUE,
                ShopItemsInfo.BOUNCER_ZAPPER_PURPLE,
                ShopItemsInfo.BOUNCER_ZAPPER_BLACK,
                ShopItemsInfo.BOUNCER_ELECTRO_RED,
                ShopItemsInfo.BOUNCER_ELECTRO_BLUE,
                ShopItemsInfo.BOUNCER_ELECTRO_PURPLE,
                ShopItemsInfo.BOUNCER_ELECTRO_BLACK,
                ShopItemsInfo.BOUNCER_PERFETTO_RED,
                ShopItemsInfo.BOUNCER_PERFETTO_BLUE,
                ShopItemsInfo.BOUNCER_PERFETTO_PURPLE,
                ShopItemsInfo.BOUNCER_PERFETTO_BLACK
            };
            return allBouncers[roomLink.rand.Next(allBouncers.Length - 1)]; //random bouncer
        }

        public override void sendMessage(string type, params object[] parameters)
        {
            //do nothing, it's NPC
        }

        public override void sendMessage(Message msg)
        {
            //do nothing, it's NPC
        }

        protected override Message getStartGameMessage(string mapsProgram, string oppIDs, string gameType,
            int gameLength, string oppPanelConfigurations, string oppBouncerIDs, int energyConsumed)
        {
            return Message.Create("");
        }

        public override DatabaseObject getSpellsConfig()
        {
            return _spells;
        }
    }
}