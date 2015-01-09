package model.userData
{
    import events.RequestEvent;
    import events.ServerMessageEvent;

    import flash.utils.Dictionary;

    import model.PopupsManager;
    import model.ServerTalker;
    import model.constants.GameConfig;
    import model.shop.ShopItemsInfo;

    import playerio.PayVault;

    import utils.EventHub;
    import utils.Misc;

    /**
     * ...
     * @author Alexey Kuznetsov
     */
    public final class UserData
    {
        public static var friends:Array; //frieds objects with properties: id, name(for inApp only), photoURL, inApp:Boolean
        public static var name:String = "Player";
        public static var uid:String = "";
        public static var photoURL:String = "https://graph.facebook.external.com/alexej.kuznetsov/picture";
        public static var coins:int;
        public static var energy:int; //set on auth data message received from server (server updates this values)
        public static var energyNextUpdate:Number; //set on auth data message received from server (server updates this values)
        public static var energyExpires:Number;
        public static var spellsConfiguration:SpellsConfiguration;
        public static var mapsConfiguration:MapsConfiguration;
        public static var payVaultItems:PayVaultItems;
        public static var rankProgress:int;
        public static var rankNumber:int;
        public static var soundsOn:Boolean;
        public static var musicOn:Boolean;
        public static var rankProtectionCount:int;
        public static var bouncerID:String;

        public static function initListeners():void
        {
            EventHub.addEventListener(ServerMessageEvent.ENERGY_UPDATE, onEnergyUpdate);
            EventHub.addEventListener(RequestEvent.BUY_ITEM, buyItem);
            EventHub.addEventListener(RequestEvent.ACTIVATE_BOUNCER, activateBouncer);
        }

        private static function activateBouncer(event:RequestEvent):void
        {
            if (payVaultItems.hasItem(event.stuff.bouncerID))
            {
                bouncerID = event.stuff.bouncerID;
            }
            else
            {
                throw new Error("Trying to activate bouncer which was not bought: bouncerID: " + event.stuff.bouncerID + " uid: " + uid);
            }
        }

        /**
         * Handling all shop puchases + spells activations here
         * Buying item by client, without any response from server.
         * If error occured then server will send msg and player will be forced to refresh the page
         * @param event
         */
        private static function buyItem(event:RequestEvent):void
        {
            var itemKey:String = event.stuff.itemKey;
            var itemName:String = event.stuff.itemName;
            var itemPrice:int = event.stuff.itemPrice;
            var tab:String = event.stuff.tab;

            if (coins >= itemPrice)
            {
                if (tab == ShopItemsInfo.TAB_BOUNCERS) //buying and activating bouncer
                {
                    ServerTalker.buyBouncer(itemKey);
                    bouncerID = itemKey;
                    payVaultItems.addItem(itemKey);
                }
                else if (tab == "spells") //there is no such tab in shop, just passing it to filter spells
                {
                    spellsConfiguration.activateSpell(itemKey);
                    ServerTalker.activateSpell(itemKey);
                    EventHub.dispatch(new RequestEvent(RequestEvent.SPELL_ACTIVATED_BY_CLIENT, {spellName: itemKey}));
                }
                else if (tab == ShopItemsInfo.TAB_ARMOR)
                {
                    ServerTalker.buyArmor(itemKey);
                    var armorCount:int;
                    if (itemKey == ShopItemsInfo.ARMOR_3X)
                    {
                        armorCount = 3;
                    }
                    if (itemKey == ShopItemsInfo.ARMOR_5X)
                    {
                        armorCount = 5;
                    }
                    if (itemKey == ShopItemsInfo.ARMOR_10X)
                    {
                        armorCount = 10;
                    }
                    rankProtectionCount += armorCount;
                }
                else if (tab == ShopItemsInfo.TAB_ENERGY)
                {
                    ServerTalker.buyEnergy(itemKey);
                    if (itemKey == ShopItemsInfo.ENERGY_REFILL)
                    {
                        energy = GameConfig.ENERGY_MAX;
                    }
                    else if (itemKey == ShopItemsInfo.ENERGY_TICKET_1_DAY ||
                            itemKey == ShopItemsInfo.ENERGY_TICKET_3_DAYS ||
                            itemKey == ShopItemsInfo.ENERGY_TICKET_7_DAYS)
                    {
                        processTicketPurchase(itemKey);
                    }
                }

                coins -= itemPrice;
                if (tab != "spells")
                {
                    PopupsManager.showItemBought(itemKey, itemName);
                }
                EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED));
            }
            else
            {
                PopupsManager.showNotEnoughCoinsPopup();
            }
        }

        private static function processTicketPurchase(itemName:String):void
        {
            var daysCount:int = 1;
            if (itemName == ShopItemsInfo.ENERGY_TICKET_3_DAYS)
            {
                daysCount = 3;
            }
            else if (itemName == ShopItemsInfo.ENERGY_TICKET_7_DAYS)
            {
                daysCount = 7;
            }

            energyExpires = Misc.currentUNIXSecs + (daysCount * 24 * 60 * 60);
            energy = GameConfig.ENERGY_MAX;
        }

        public static function setDefaults():void
        {
            coins = GameConfig.COINS_START_AMOUNT;
            energy = GameConfig.ENERGY_MAX;
            energyExpires = 0;
            rankProgress = GameConfig.RANK_PROGRESS_START;
            rankNumber = 1;
            bouncerID = ShopItemsInfo.BOUNCER_STANDART_BLUE;
            soundsOn = true;
            musicOn = true;
            payVaultItems = new PayVaultItems([
                {itemKey: bouncerID}
            ]);
            spellsConfiguration = new SpellsConfiguration(Spells.getDefault());
            mapsConfiguration = new MapsConfiguration(new Dictionary()); //empty
        }

        public static function fromPlayerObject(obj:Object):void
        {
            var spells:Dictionary = new Dictionary();
            for (var spellName:String in obj.spells)
            {
                spells[spellName] = new SpellVO(spellName, obj.spells[spellName].expires, obj.spells[spellName].p, true);
            }
            spellsConfiguration = new SpellsConfiguration(spells);

            var maps:Dictionary = new Dictionary();
            var intt:int;
            for (var mapID:String in obj.maps)
            {
                intt = int(mapID);
                maps[intt] = obj.maps[intt];
            }
            mapsConfiguration = new MapsConfiguration(maps);

            rankProgress = obj.rankProgress;
            rankNumber = obj.rankNumber;
            bouncerID = obj.bouncerID;
            energyExpires = obj.energyExpires;
            soundsOn = obj.hasOwnProperty("soundsOn") ? obj.soundsOn : true;
            musicOn = obj.hasOwnProperty("musicOn") ? obj.musicOn : true;
        }

        public static function fromPayVault(payVault:PayVault):void
        {
            coins = payVault.coins;
            payVaultItems = new PayVaultItems(payVault.items);
            rankProtectionCount = payVaultItems.getRankProtectionCount();
        }

        private static function onEnergyUpdate(event:ServerMessageEvent):void
        {
            UserData.energy = event.message.getInt(0);
            UserData.energyNextUpdate = event.message.getNumber(1);
            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED));
        }

        public static function get isGuest():Boolean
        {
            return uid == "simpleguest";
        }

        /*
         * Assuming that all uids are registered through SimpleConnect by Playerio & have "simple" prefix
         */
        public static function nameFromUid($uid:String):String
        {
            return $uid.substring(6, $uid.length); //remove "simple" which is added to every nickname in the beginning
        }
    }
}