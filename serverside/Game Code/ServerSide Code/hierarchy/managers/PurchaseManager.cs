using System;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    /**
     * Handling all purchases here. 
     * All purchases work in 2 phases:
     * 1. Check coins funct ion is triggered
     * 2. If enough coins then process****** func is called and player is given an item
     * */

    public class PurchaseManager
    {
        public static void buyArmor(Player pl, string itemKey)
        {
            if (pl.isGuest)
                return;

            checkCoins(pl, itemKey, processArmorPurchase);
        }

        private static void processArmorPurchase(Player pl, string itemKey)
        {
            int armorCount = 0;
            if (itemKey == ShopItemsInfo.ARMOR_3X)
                armorCount = 3;
            else if (itemKey == ShopItemsInfo.ARMOR_5X)
                armorCount = 5;
            else if (itemKey == ShopItemsInfo.ARMOR_10X)
                armorCount = 10;

            var item = new BuyItemInfo(itemKey);
            pl.PayVault.Buy(false, new BuyItemInfo[1] {item},
                delegate
                {
                    var items = new BuyItemInfo[armorCount];
                    for (int i = 0; i < armorCount; i++)
                    {
                        items[i] = new BuyItemInfo(ShopItemsInfo.ARMOR_ITEM);
                    }

                    pl.PayVault.Give(items, delegate { },
                        delegate(PlayerIOError err)
                        {
                            pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Service error at buying item (2nd step)");
                            pl.roomLink.handleError(err);
                        });
                },
                delegate(PlayerIOError err)
                {
                    pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Service error at buying item (1st step)");
                    pl.roomLink.handleError(err);
                });
        }

        public static void buyEnergy(Player pl, string itemKey)
        {
            if (pl.isGuest)
                return;

            checkCoins(pl, itemKey, processEnergyPurchase);
        }

        private static void processEnergyPurchase(Player pl, string itemKey)
        {
            if (itemKey == ShopItemsInfo.ENERGY_REFILL)
            {
                var item = new BuyItemInfo(itemKey);
                pl.PayVault.Buy(false, new BuyItemInfo[1] {item},
                    delegate
                    {
                        pl.PlayerObject.Set(DBProperties.ENERGY, GameConfig.ENERGY_MAX);
                        pl.roomLink.playerEnergyTimer.resetLastUpdateTime();
                        pl.PlayerObject.Save();
                    },
                    delegate(PlayerIOError err)
                    {
                        pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Service error at buying item (1st step)");
                        pl.roomLink.handleError(err);
                    });
            }
            else if (itemKey == ShopItemsInfo.ENERGY_TICKET_1_DAY
                     || itemKey == ShopItemsInfo.ENERGY_TICKET_3_DAYS
                     || itemKey == ShopItemsInfo.ENERGY_TICKET_7_DAYS)
            {
                purchaseEnergyTicket(itemKey, pl);
            }
        }

        private static void purchaseEnergyTicket(string itemKey, Player pl)
        {
            var item = new BuyItemInfo(itemKey);
            pl.PayVault.Buy(false, new BuyItemInfo[1] {item},
                delegate
                {
                    int days = 1;
                    if (itemKey == ShopItemsInfo.ENERGY_TICKET_3_DAYS)
                        days = 3;
                    else if (itemKey == ShopItemsInfo.ENERGY_TICKET_7_DAYS)
                        days = 7;

                    int ticketLengthInSeconds = days*24*60*1000;
                    pl.PlayerObject.Set(DBProperties.ENERGY, GameConfig.ENERGY_MAX);
                        //set current energy to max (so when ticket experies energy is full)
                    pl.PlayerObject.Set(DBProperties.ENERGY_EXPIRES, Utils.unixSecs() + ticketLengthInSeconds);
                    pl.PlayerObject.Save();
                },
                delegate(PlayerIOError err)
                {
                    pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Service error at buying item (1st step)");
                    pl.roomLink.handleError(err);
                });
        }

        public static void buyBouncer(Player pl, string itemKey)
        {
            if (pl.isGuest)
                return;

            checkCoins(pl, itemKey, processBouncerPurchase);
        }

        private static void processBouncerPurchase(Player pl, string itemKey)
        {
            var item = new BuyItemInfo(itemKey);
            pl.PayVault.Buy(true, new BuyItemInfo[1] {item},
                delegate
                {
                    Console.WriteLine("Successfully bought " + itemKey);
                    pl.PlayerObject.Set(DBProperties.BOUNCER_ID, itemKey);
                    pl.PlayerObject.Save();
                },
                delegate(PlayerIOError err)
                {
                    pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Service error at buying item");
                    pl.roomLink.handleError(err);
                });
        }

        public static void activateSpell(Player pl, string spellName)
        {
            if (pl.isGuest || spellName == Spells.ROCKET)
                return;

            checkCoins(pl, spellName, processSpellActivation);
        }

        private static void processSpellActivation(Player pl, string spellName)
        {
            var item = new BuyItemInfo(spellName);
            bool needActivationBuffer = pl.roomLink.game != null; //user might be activating not during the game
            if (needActivationBuffer) //user might be activating not during the game
                pl.roomLink.game.spellChecker.putSpellInActivationBuffer(spellName);
                    //so it is not blocked from usage while transaction is processed
            pl.PayVault.Buy(false, new BuyItemInfo[1] {item},
                //immediately consume items. Instead PlayerObject is updated (for storage convenience)
                delegate
                {
                    Console.WriteLine("PayVault ok...");
                    DatabaseObject spells = pl.getSpellsConfig();
                    double expiresDate = Utils.unixSecs() + GameConfig.SPELL_ACTIVATION_TIME*60*60;
                    var newSpell = new DatabaseObject();
                    int prevSlotID = spells.Contains(spellName)
                        ? spells.GetObject(spellName).GetInt(DBProperties.SPELL_SLOT)
                        : -1; //dont lose spell 
                    newSpell.Set(DBProperties.SPELL_SLOT, prevSlotID);
                    newSpell.Set(DBProperties.SPELL_EXPIRES, expiresDate);
                    spells.Set(spellName, newSpell);
                    pl.PlayerObject.Save();
                    pl.sendMessage(MessageTypes.ACTIVATE_SPELL_OK, spellName); //send "ok" back
                    pl.roomLink.statisticsManager.onSpellActivated(spellName);
                    if (needActivationBuffer) //user might be activating not during the game
                        pl.roomLink.game.spellChecker.removeSpellFromActivationBuffer(spellName);
                            //now checks are made as usual
                    foreach (Player play in pl.roomLink.playingUsers)
                    {
                        if (!(play is NPCPlayer))
                        {
                            play.sendMessage(MessageTypes.ACTIVATE_SPELL_OPPONENT, pl.realID, spellName);
                        }
                    }
                },
                delegate(PlayerIOError err)
                {
                    if (needActivationBuffer) //user might be activating not during the game
                        pl.roomLink.game.spellChecker.removeSpellFromActivationBuffer(spellName);
                            //now checks are made as usual
                    pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Service error at buying item");
                    pl.roomLink.handleError(err);
                });
        }

        private static void checkCoins(Player pl, string itemKey, Action<Player, string> callback)
        {
            pl.PayVault.Refresh(delegate
            {
                int itemPrice = ShopItemsInfo.getItemPrice(itemKey);
                if (pl.PayVault.Coins >= itemPrice)
                {
                    callback.Invoke(pl, itemKey);
                }
                else
                {
                    pl.sendMessage(MessageTypes.PURCHASE_FAILED, "Not enough coins");
                }
            }, pl.roomLink.handleError);
        }
    }
}