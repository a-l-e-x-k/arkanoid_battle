using System;
using System.Collections;
using System.Collections.Generic;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public class StatisticsManager
    {
        private readonly BasicRoom _roomLink;
        private readonly double initTime; //this manager is inited when room is created. This is used for session length

        public StatisticsManager(BasicRoom roomLink)
        {
            _roomLink = roomLink;
            initTime = Utils.unixSecs();
        }

        public void onCreatorLeftRoom()
        {
            double sessionLengthInSecs = Utils.unixSecs() - initTime;
            double sessionLengthInMins = sessionLengthInSecs/60;
            _roomLink.PlayerIO.BigDB.LoadOrCreate("Stats", "sessions", delegate(DatabaseObject dbo)
            {
                if (!dbo.Contains("count"))
                {
                    dbo.Set("count", 1);
                    dbo.Set("avgLength", 1.25);
                }

                double totalLengthInMins = dbo.GetDouble("avgLength")*dbo.GetInt("count");
                    //how much time players played in total
                totalLengthInMins += sessionLengthInMins;
                double newAvgLength = totalLengthInMins/dbo.GetInt("count");

                dbo.Set("count", dbo.GetInt("count") + 1);
                dbo.Set("avgLength", newAvgLength);
                dbo.Save();
            }, _roomLink.handleError);
        }

        public void onGameFinish()
        {
            if (_roomLink.game.gameType == GameTypes.FAST_SPRINT)
            {
                updateMapsStats();
            }

            updateSpellsStatsAfterGame();
            updateGamesCounters();
            updatePlayerGameCounters();
        }

        private void updatePlayerGameCounters()
        {
            foreach (Player pl in _roomLink.playingUsers)
            {
                if (!(pl is NPCPlayer))
                {
                    DatabaseObject counter = pl.PlayerObject.GetObject("gamesCounter");
                    if (counter == null)
                    {
                        counter = new DatabaseObject();
                        checkGamesCounterObject(counter);
                    }

                    counter.Set(_roomLink.game.gameType, counter.GetInt(_roomLink.game.gameType) + 1);
                    if (pl.PlayerObject.GetObject("gamesCounter") != counter)
                    {
                        pl.PlayerObject.Set("gamesCounter", counter);
                    }
                    pl.PlayerObject.Save();
                }
            }
        }

        private void updateGamesCounters()
        {
            string gameType = _roomLink.game.gameType; //game will become null when DBO will be loaded
            _roomLink.PlayerIO.BigDB.LoadOrCreate("Stats", "gamesCounter", delegate(DatabaseObject dbo)
            {
                checkGamesCounterObject(dbo);
                dbo.Set(gameType, dbo.GetInt(gameType) + 1);
                dbo.Save();
            }, _roomLink.handleError);
        }

        private void checkGamesCounterObject(DatabaseObject dbo)
        {
            if (!dbo.Contains(GameTypes.BIG_BATTLE))
            {
                dbo.Set(GameTypes.BIG_BATTLE, 0);
                dbo.Set(GameTypes.FAST_SPRINT, 0);
                dbo.Set(GameTypes.FIRST_100, 0);
                dbo.Set(GameTypes.UPSIDE_DOWN, 0);
            }
        }

        private void updateMapsStats()
        {
            int realPlayersCount = 0;
            int realPlayersPointsSum = 0;

            foreach (Player pl in _roomLink.playingUsers)
            {
                if (!(pl is NPCPlayer))
                {
                    realPlayersCount++;
                    realPlayersPointsSum += pl.points;
                }
            }

            int avgPointsAmount = realPlayersPointsSum/realPlayersCount;

            _roomLink.PlayerIO.BigDB.LoadOrCreate("StatsMaps", _roomLink.game.mapID, delegate(DatabaseObject dbo)
            {
                if (!dbo.Contains("playCount"))
                {
                    dbo.Set("playCount", 0);
                    dbo.Set("avgScore", 1);
                }

                double lifetimeScore = dbo.GetInt("playCount")*dbo.GetInt("avgScore");
                lifetimeScore += avgPointsAmount;
                int newAvgScore = avgPointsAmount/(dbo.GetInt("playCount") + 1);

                dbo.Set("playCount", dbo.GetInt("playCount") + 1);
                dbo.Set("avgScore", newAvgScore);
                dbo.Save();
            }, _roomLink.handleError);
        }

        /**
         * Measure how people like spells, which ones do they find useful
         **/

        public void onSpellActivated(string spellName)
        {
            _roomLink.PlayerIO.BigDB.LoadOrCreate("StatsSpells", spellName, delegate(DatabaseObject dbo)
            {
                checkSpellDBO(dbo);
                dbo.Set("activationCount", dbo.GetInt("activationCount") + 1);
                dbo.Save();
            }, _roomLink.handleError);
        }

        /**
         * UsedCount & GamesCount help to understand "How much are spells not used". E.g. usedCount / activation ratio might be very low
         **/

        public void updateSpellsStatsAfterGame()
        {
            var allUsages = new Dictionary<string, int>(); //spellname - usage count
            var usedSpellsNames = new ArrayList();
                //for requesting range of keys below (can't insta convert Dictionary.Keys to array)
            Dictionary<int, int> userSpellUsages;
            string spellName;

            foreach (Player pl in _roomLink.playingUsers)
            {
                userSpellUsages = pl.spellUseCounter.getUsedSpellsData();
                foreach (int requestID in userSpellUsages.Keys)
                {
                    //some "self-oriented" requests will be counted from 1 used, some (opponent-oriented, lige Charm) will be counter from another one
                    spellName = GameRequest.getSpellNameByRequest(requestID);
                    if (spellName != "") //it might be not a spell but just game request
                    {
                        Console.WriteLine("Going through all requests=: req: " + requestID + " spellName: " + spellName);
                        allUsages[spellName] = allUsages.ContainsKey(spellName)
                            ? allUsages[spellName] + userSpellUsages[requestID]
                            : userSpellUsages[requestID];
                        if (!usedSpellsNames.Contains(spellName)) //other player might've used it
                            usedSpellsNames.Add(spellName);
                    }
                }
            }

            Console.WriteLine("Writing spells stats: all spells used: " + string.Concat(usedSpellsNames.ToArray()));
            if (usedSpellsNames.Count == 0) //no spells were used
                return;

            _roomLink.PlayerIO.BigDB.LoadKeysOrCreate("StatsSpells", (string[]) usedSpellsNames.ToArray(typeof (string)),
                delegate(DatabaseObject[] dbos)
                {
                    foreach (DatabaseObject dbo in dbos)
                    {
                        checkSpellDBO(dbo);
                        dbo.Set("usedCount", dbo.GetInt("usedCount") + allUsages[dbo.Key]);
                        dbo.Set("gamesCount", dbo.GetInt("gamesCount") + 1);
                        dbo.Save();
                    }
                }, _roomLink.handleError);
        }

        private void checkSpellDBO(DatabaseObject dbo)
        {
            if (!dbo.Contains("activationCount"))
            {
                dbo.Set("activationCount", 0); //how many times spell was activated (3-hour cycle)
                dbo.Set("usedCount", 0); //how many times spell was used in game
                dbo.Set("gamesCount", 0); //how many games were played with this spell on spellPanel
            }
        }
    }
}