using System;
using System.Collections;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public class PlayerUpdater
    {
        public static PlayerUpdateResult updatePlayerPostGame(Player pl, bool playerWon, string gameType, string mapID,
            ArrayList otherPlayers)
        {
            if (gameType == GameTypes.FAST_SPRINT)
                updateMaps(pl, mapID);

            var result = new PlayerUpdateResult();

            result.newRankProtectionCount = updateRank(pl, playerWon, otherPlayers);
            result.coinsAdded = updateCoins(pl, playerWon, gameType);
            result.newRank = pl.PlayerObject.GetInt(DBProperties.RANK_NUMBER);
            result.newRankProgress = pl.PlayerObject.GetInt(DBProperties.RANK_PROGRESS);

            pl.PlayerObject.Save();

            Console.WriteLine("Rank updated: new rank: " + result.newRank);
            Console.WriteLine("Rank updated: new rank progress: " + result.newRankProgress);

            return result;
        }

        private static void updateMaps(Player pl, string mapID)
        {
            if (pl.isGuest)
                return;

            int map = Convert.ToInt32(mapID);
            int starsEarned = pl.roomLink.maps.getMapStarsByPoints(map, pl.points);
            Console.WriteLine("starsEarned: " + starsEarned);
            DatabaseObject maps = pl.PlayerObject.Contains(DBProperties.MAPS)
                ? pl.PlayerObject.GetObject(DBProperties.MAPS)
                : new DatabaseObject();
            if (!maps.Contains(mapID) || maps.GetInt(mapID) < starsEarned)
            {
                maps.Set(mapID, starsEarned); //update stars config if player did better than before
                if (!pl.PlayerObject.Contains(DBProperties.MAPS))
                {
                    pl.PlayerObject.Set(DBProperties.MAPS, maps);
                }
            }
        }

        private static uint updateCoins(Player pl, bool playerWon, string gameType)
        {
            uint coinsToGive = 0;

            if (pl.isGuest)
                return 0;

            if (gameType == GameTypes.FAST_SPRINT)
            {
                coinsToGive = playerWon ? GameConfig.COINS_FOR_WIN_SPRINT : GameConfig.COINS_FOR_LOSE_SPRINT;
            }
            else if (gameType == GameTypes.BIG_BATTLE)
            {
                coinsToGive = playerWon ? GameConfig.COINS_FOR_WIN_BIG_BATTLE : GameConfig.COINS_FOR_LOSE_BIG_BATTLE;
            }
            else if (gameType == GameTypes.FIRST_100)
            {
                coinsToGive = playerWon ? GameConfig.COINS_FOR_WIN_FIRST_100 : GameConfig.COINS_FOR_LOSE_FIRST_100;
            }
            else if (gameType == GameTypes.UPSIDE_DOWN)
            {
                coinsToGive = playerWon ? GameConfig.COINS_FOR_WIN_UPSIDE_DOWN : GameConfig.COINS_FOR_LOSE_UPSIDE_DOWN;
            }
            pl.PayVault.Refresh(delegate
            {
                string reason = (playerWon ? "Won " : "Lost ") + Spells.getFullSpellName(gameType);
                pl.PayVault.Credit(coinsToGive, reason, delegate { }, pl.roomLink.handleError);
            });
            return coinsToGive;
        }

        public static int consumeEnergy(Player pl, string gameType)
        {
            int toConsume = 0;

            if (pl is NPCPlayer)
                return 0;

            if (pl.isGuest)
                return 0;

            if (pl.PlayerObject.GetDouble(DBProperties.ENERGY_EXPIRES) > Utils.unixSecs())
                //player has bought an energy ticket
                return 0;

            if (gameType == GameTypes.BIG_BATTLE)
                toConsume = GameConfig.ENERGY_CONSUMPTION_BIG_BATTLE;
            else if (gameType == GameTypes.FAST_SPRINT)
                toConsume = GameConfig.ENERGY_CONSUMPTION_SPRINT;
            else if (gameType == GameTypes.FIRST_100)
                toConsume = GameConfig.ENERGY_CONSUMPTION_FIRST_100;
            else if (gameType == GameTypes.UPSIDE_DOWN)
                toConsume = GameConfig.ENERGY_CONSUMPTION_UPSIDE_DOWN;

            //in some weird scenarios player object did not contain energy property
            int current = pl.PlayerObject.Contains(DBProperties.ENERGY)
                ? pl.PlayerObject.GetInt(DBProperties.ENERGY)
                : 0;
            if (current < toConsume)
            {
                pl.roomLink.PlayerIO.ErrorLog.WriteError("Unexpected low energy amount: " + pl.realID);
                toConsume = current;
            }
            if (current == GameConfig.ENERGY_MAX)
                pl.roomLink.playerEnergyTimer.resetLastUpdateTime();
                    //so when we consume energy and ask for more last update time will be fresh

            pl.PlayerObject.Set(DBProperties.ENERGY, current - toConsume);
            pl.PlayerObject.Save();

            pl.roomLink.playerEnergyTimer.tryRefillEnergy();

            return toConsume;
        }

        private static int updateRank(Player pl, bool playerWon, ArrayList otherPlayers)
        {
            int currentProgress = pl.PlayerObject.GetInt(DBProperties.RANK_PROGRESS);
            int currentRank = pl.PlayerObject.GetInt(DBProperties.RANK_NUMBER);
            int newRankProtectionCount = pl.getRankProtectionCount();

            if (pl.isGuest)
                return newRankProtectionCount;

            if (playerWon)
            {
                int amountToAdd = 1;
                int rankSum = 0;
                int plCount = 0;
                foreach (Player pla in otherPlayers)
                {
                    if (pla != pl && !(pla is NPCPlayer))
                    {
                        rankSum += pla.PlayerObject.GetInt(DBProperties.RANK_NUMBER);
                        plCount++;
                    }
                }
                int avgRank = rankSum/(plCount > 0 ? plCount : 1);
                // if (avgRank > currentRank + 5) //player defeated dude who is 5 rank points higher
                // {
                if (pl.roomLink.rand.Next(10) > 7) //30% chance to receive double progress
                {
                    amountToAdd = 2;
                }
                // }

                currentProgress += amountToAdd;
                if (currentProgress > 5)
                {
                    currentRank++;
                    currentProgress = GameConfig.RANK_PROGRESS_START;
                }
            }
            else
            {
                if (!(currentRank == 1 && currentProgress == 0)) //do nothing for 1st rank (that is absolute bottom)
                {
                    if (newRankProtectionCount > 0)
                    {
                        newRankProtectionCount--; //variable for the sake of returning result
                        var toConsume = new VaultItem[1];
                        foreach (VaultItem it in pl.PayVault.Items)
                        {
                            if (it.ItemKey == ShopItemsInfo.ARMOR_ITEM)
                            {
                                toConsume[0] = it;
                                break;
                            }
                        }
                        pl.PayVault.Consume(toConsume, delegate { Console.WriteLine("Protection item consumed!"); },
                            pl.roomLink.handleError);
                    }
                    else
                    {
                        if (currentProgress == 0)
                        {
                            currentProgress = GameConfig.RANK_PROGRESS_START;
                            currentRank--;
                        }
                        else
                        {
                            currentProgress--;
                        }
                    }
                }
            }

            pl.PlayerObject.Set(DBProperties.RANK_NUMBER, currentRank);
            pl.PlayerObject.Set(DBProperties.RANK_PROGRESS, currentProgress);

            return newRankProtectionCount;
        }
    }
}