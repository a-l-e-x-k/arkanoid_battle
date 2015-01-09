/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:07 PM
 */
package model.shop
{
	import model.userData.Spells;

	/**
	 * Whatever is sold in the game is here
	 * IOW, here are all the prices
	 */
	public class ShopItemsInfo
	{
		public static const ENERGY_REFILL:String = "energyRefill";
		public static const ENERGY_TICKET_1_DAY:String = "energy1Day";
		public static const ENERGY_TICKET_3_DAYS:String = "energy3Days";
		public static const ENERGY_TICKET_7_DAYS:String = "energy7Days";

		public static const BOUNCER_STANDART_RED:String = "bouncerStandartRed";
		public static const BOUNCER_STANDART_BLUE:String = "bouncerStandartBlue";
		public static const BOUNCER_STANDART_GREEN:String = "bouncerStandartGreen";
		public static const BOUNCER_STANDART_PURPLE:String = "bouncerStandartPurple";

        public static const BOUNCER_CHECKED_RED:String = "bouncerCheckedRed";
        public static const BOUNCER_CHECKED_BLUE:String = "bouncerCheckedBlue";
        public static const BOUNCER_CHECKED_PURPLE:String = "bouncerCheckedPurple";
		public static const BOUNCER_CHECKED_BLACK:String = "bouncerCheckedBlack";

		public static const BOUNCER_ZAPPER_RED:String = "bouncerZapperRed";
		public static const BOUNCER_ZAPPER_BLUE:String = "bouncerZappeBlue";
		public static const BOUNCER_ZAPPER_PURPLE:String = "bouncerZapperPurple";
		public static const BOUNCER_ZAPPER_BLACK:String = "bouncerZapperBlack";

        public static const BOUNCER_ELECTRO_RED:String = "bouncerElectroRed";
        public static const BOUNCER_ELECTRO_BLUE:String = "bouncerElectroBlue";
        public static const BOUNCER_ELECTRO_PURPLE:String = "bouncerElectroPurple";
		public static const BOUNCER_ELECTRO_BLACK:String = "bouncerElectroBlack";

		public static const BOUNCER_PERFETTO_RED:String = "bouncerPerfettoRed";
		public static const BOUNCER_PERFETTO_BLUE:String = "bouncerPerfettoBlue";
		public static const BOUNCER_PERFETTO_PURPLE:String = "bouncerPerfettoPurple";
		public static const BOUNCER_PERFETTO_BLACK:String = "bouncerPerfettoBlack";

        public static const ARMOR_ITEM:String = "armorItem"; //when we buy, say, armor_3x we add 3 armor items to pavault
        public static const ARMOR_3X:String = "armor3";
        public static const ARMOR_5X:String = "armor5";
		public static const ARMOR_10X:String = "armor10";

        public static const TAB_BOUNCERS:String = "Bouncers";
        public static const TAB_ENERGY:String = "Energy";
		public static const TAB_ARMOR:String = "Armor";

        //prices
        public static const PRICE_ENERGY_REFILL:int = 130;
        public static const PRICE_ENERGY_TICKET_1_DAY:int = 720;
        public static const PRICE_ENERGY_TICKET_3_DAYS:int = 1960;
        public static const PRICE_ENERGY_TICKET_7_DAYS:int = 4100;

        public static const PRICE_BOUNCER_STANDART_RED:int = 300;
        public static const PRICE_BOUNCER_STANDART_BLUE:int = 300;
        public static const PRICE_BOUNCER_STANDART_GREEN:int = 300;
        public static const PRICE_BOUNCER_STANDART_PURPLE:int = 300;

        public static const PRICE_BOUNCER_CHECKED_RED:int = 700;
        public static const PRICE_BOUNCER_CHECKED_BLUE:int = 700;
        public static const PRICE_BOUNCER_CHECKED_PURPLE:int = 700;
        public static const PRICE_BOUNCER_CHECKED_BLACK:int = 700;

        public static const PRICE_BOUNCER_ZAPPER_RED:int = 1500;
        public static const PRICE_BOUNCER_ZAPPER_BLUE:int = 1500;
        public static const PRICE_BOUNCER_ZAPPER_PURPLE:int = 1500;
        public static const PRICE_BOUNCER_ZAPPER_BLACK:int = 1500;

        public static const PRICE_BOUNCER_ELECTRO_RED:int = 3100;
        public static const PRICE_BOUNCER_ELECTRO_BLUE:int = 3100;
        public static const PRICE_BOUNCER_ELECTRO_PURPLE:int = 3100;
        public static const PRICE_BOUNCER_ELECTRO_BLACK:int = 3100;

        public static const PRICE_BOUNCER_PERFETTO_RED:int = 10000;
        public static const PRICE_BOUNCER_PERFETTO_BLUE:int = 10000;
        public static const PRICE_BOUNCER_PERFETTO_PURPLE:int = 10000;
        public static const PRICE_BOUNCER_PERFETTO_BLACK:int = 10000;

        public static const PRICE_ARMOR_3X:int = 150; //you pay 50 per loss, though gain from that is 50 - 20 = 30. 20 more coins are out profit and price for not losing a rank :)
        public static const PRICE_ARMOR_5X:int = 220;
        public static const PRICE_ARMOR_10X:int = 400; //here you pay 40, and our profit is 10 coins / loss.

        //*****On average it takes 5 sprint games to compensate spell activation (about 10 minutes)*****/
        //*****Full energy bar gives user 12 sprint games.
        //One energy is given every 3 minutes
        //So in 3 hours of spell activation you can play: 12 + (60 / 3) = 32 games.
        //Cost of 3-4 spell activation will be about 210 * 4 = 640-840
        //Potential revenue: 32 * 25 (win is 35 lose is 10) = 800
        //This way if you are really playing hard (32 games / 3 hours) with 3 spells you make profit of 160 coins which gives you 1/5 of a day ticket with which you can make loads of money
        //But idea is that players will not be able (without paying) to play 5 slots of spells. But more spells make avg profit / game bigger.
        //But if you play with energy ticket then you can play fuckloads of games and make a lot of money
        public static const PRICE_ACTIVATION_SPLIT_TWO:int = 180;
        public static const PRICE_ACTIVATION_SPLIT_THREE:int = 250;
        public static const PRICE_ACTIVATION_LIGHTNING_ONE:int = 140;
        public static const PRICE_ACTIVATION_LIGHTNING_TWO:int = 180;
        public static const PRICE_ACTIVATION_LIGHTNING_THREE:int = 230;
        public static const PRICE_ACTIVATION_CHARM:int = 140;
		public static const PRICE_ACTIVATION_FREEZE:int = 300;
		public static const PRICE_ACTIVATION_BOUNCY_FIELD:int = 260;
		public static const PRICE_ACTIVATION_LASER_SHOTS:int = 200;
		public static const PRICE_ACTIVATION_ROCKET:int = 210;

        public static const REFILL_COINS_AMOUNTS:Array = [700, 2000, 4500, 10000];
        public static const REFILL_COINS_PRICES:Array = [200, 500, 1000, 2000]; //USD cents (divide by 100 to get USD)

        private static var _items:Vector.<ShopItemVO> = new Vector.<ShopItemVO>();

		/**
		 * Registering items shown in the shop
		 */
		public static function init():void
		{
			pushItem(ENERGY_REFILL, "Energy Refill", PRICE_ENERGY_REFILL, TAB_ENERGY);
			pushItem(ENERGY_TICKET_1_DAY, "Energy for 1 day", PRICE_ENERGY_TICKET_1_DAY, TAB_ENERGY);
			pushItem(ENERGY_TICKET_3_DAYS, "Energy for 3 days", PRICE_ENERGY_TICKET_3_DAYS, TAB_ENERGY);
			pushItem(ENERGY_TICKET_7_DAYS, "Energy for 7 days", PRICE_ENERGY_TICKET_7_DAYS, TAB_ENERGY);

			pushItem(BOUNCER_STANDART_BLUE, "Blue Standart", PRICE_BOUNCER_STANDART_BLUE, TAB_BOUNCERS);
			pushItem(BOUNCER_STANDART_RED, "Red Standart", PRICE_BOUNCER_STANDART_RED, TAB_BOUNCERS);
			pushItem(BOUNCER_STANDART_GREEN, "Green Standart", PRICE_BOUNCER_STANDART_GREEN, TAB_BOUNCERS);
			pushItem(BOUNCER_STANDART_PURPLE, "Purple Standart", PRICE_BOUNCER_STANDART_PURPLE, TAB_BOUNCERS);

            pushItem(BOUNCER_CHECKED_RED, "Red Check", PRICE_BOUNCER_CHECKED_RED, TAB_BOUNCERS);
            pushItem(BOUNCER_CHECKED_BLUE, "Blue Check", PRICE_BOUNCER_CHECKED_BLUE, TAB_BOUNCERS);
            pushItem(BOUNCER_CHECKED_PURPLE, "Purple Check", PRICE_BOUNCER_CHECKED_PURPLE, TAB_BOUNCERS);
			pushItem(BOUNCER_CHECKED_BLACK, "Black Check", PRICE_BOUNCER_CHECKED_BLACK, TAB_BOUNCERS);

			pushItem(BOUNCER_ZAPPER_RED, "Red Zapper", PRICE_BOUNCER_ZAPPER_RED, TAB_BOUNCERS);
			pushItem(BOUNCER_ZAPPER_BLUE, "Blue Zapper", PRICE_BOUNCER_ZAPPER_BLUE, TAB_BOUNCERS);
			pushItem(BOUNCER_ZAPPER_PURPLE, "Purple Zapper", PRICE_BOUNCER_ZAPPER_PURPLE, TAB_BOUNCERS);
			pushItem(BOUNCER_ZAPPER_BLACK, "Black Zapper", PRICE_BOUNCER_ZAPPER_BLACK, TAB_BOUNCERS);

            pushItem(BOUNCER_ELECTRO_RED, "Red Electro", PRICE_BOUNCER_ELECTRO_RED, TAB_BOUNCERS);
            pushItem(BOUNCER_ELECTRO_BLUE, "Blue Electro", PRICE_BOUNCER_ELECTRO_BLUE, TAB_BOUNCERS);
            pushItem(BOUNCER_ELECTRO_PURPLE, "Purple Electro", PRICE_BOUNCER_ELECTRO_PURPLE, TAB_BOUNCERS);
			pushItem(BOUNCER_ELECTRO_BLACK, "Black Electro", PRICE_BOUNCER_ELECTRO_BLACK, TAB_BOUNCERS);

			pushItem(BOUNCER_PERFETTO_RED, "Red Perfetto", PRICE_BOUNCER_PERFETTO_RED, TAB_BOUNCERS);
			pushItem(BOUNCER_PERFETTO_BLUE, "Blue Perfetto", PRICE_BOUNCER_PERFETTO_BLUE, TAB_BOUNCERS);
			pushItem(BOUNCER_PERFETTO_PURPLE, "Purple Perfetto", PRICE_BOUNCER_PERFETTO_PURPLE, TAB_BOUNCERS);
			pushItem(BOUNCER_PERFETTO_BLACK, "Black Perfetto", PRICE_BOUNCER_PERFETTO_BLACK, TAB_BOUNCERS);

			pushItem(ARMOR_3X, "3x Armor", PRICE_ARMOR_3X, TAB_ARMOR);
			pushItem(ARMOR_5X, "5x Armor", PRICE_ARMOR_5X, TAB_ARMOR);
			pushItem(ARMOR_10X, "10x Armor", PRICE_ARMOR_10X, TAB_ARMOR);
		}

		public static function getAllTabs():Array
		{
			return [TAB_ENERGY, TAB_ARMOR, TAB_BOUNCERS];
		}

		/**
		 * Returns ids of items in specified tab
		 * @return
		 */
		public static function getTabContaints(tabName:String):Vector.<ShopItemVO>
		{
			var r:Vector.<ShopItemVO> = new <ShopItemVO>[];
			for each (var shopItemInfo:ShopItemVO in _items)
			{
				if (shopItemInfo.tab == tabName)
					r.push(shopItemInfo);
			}
			return r;
		}

		private static function pushItem(itemKey:String, name:String, price:int, tab:String, tooltipText:String = ""):void
		{
			var it:ShopItemVO = new ShopItemVO();
			it.key = itemKey;
			it.name = name;
			it.price = price;
			it.tab = tab;
			it.tooltipText = tooltipText;
			_items.push(it);
		}

        /**
         * Fuck yeah! Very nice implementation :)
         * @param itemKey
         * @return
         */
		public static function getItemPrice(itemKey:String):int
		{
			var p:int = 0;
            //spells
			if (itemKey == Spells.CHARM_BALLS)
				p = PRICE_ACTIVATION_CHARM;
			else if (itemKey == Spells.FREEZE)
				p = PRICE_ACTIVATION_FREEZE;
			else if (itemKey == Spells.LIGHTNING_ONE)
				p = PRICE_ACTIVATION_LIGHTNING_ONE;
			else if (itemKey == Spells.LIGHTNING_TWO)
				p = PRICE_ACTIVATION_LIGHTNING_TWO;
			else if (itemKey == Spells.LIGHTNING_THREE)
				p = PRICE_ACTIVATION_LIGHTNING_THREE;
			else if (itemKey == Spells.SPLIT_IN_TWO)
				p = PRICE_ACTIVATION_SPLIT_TWO;
			else if (itemKey == Spells.SPLIT_IN_THREE)
				p = PRICE_ACTIVATION_SPLIT_THREE;
            else if (itemKey == Spells.BOUNCY_SHIELD)
				p = PRICE_ACTIVATION_BOUNCY_FIELD;
            else if (itemKey == Spells.LASER_SHOTS)
                p = PRICE_ACTIVATION_LASER_SHOTS;
            else if (itemKey == Spells.ROCKET)
                p = PRICE_ACTIVATION_ROCKET;

            //energy
            else if (itemKey == ENERGY_REFILL)
                p = PRICE_ENERGY_REFILL;
            else if (itemKey == ENERGY_TICKET_1_DAY)
                p = PRICE_ENERGY_TICKET_1_DAY;
            else if (itemKey == ENERGY_TICKET_3_DAYS)
                p = PRICE_ENERGY_TICKET_3_DAYS;
            else if (itemKey == ENERGY_TICKET_7_DAYS)
                p = PRICE_ENERGY_TICKET_7_DAYS;

            //standart bouncers
            else if (itemKey == BOUNCER_STANDART_RED)
                p = PRICE_BOUNCER_STANDART_RED;
            else if (itemKey == BOUNCER_STANDART_BLUE)
                p = PRICE_BOUNCER_STANDART_BLUE;
            else if (itemKey == BOUNCER_STANDART_GREEN)
                p = PRICE_BOUNCER_STANDART_GREEN;
            else if (itemKey == BOUNCER_STANDART_PURPLE)
                p = PRICE_BOUNCER_STANDART_PURPLE;
            
            //checked bouncers
            else if (itemKey == BOUNCER_CHECKED_BLACK)
                p = PRICE_BOUNCER_CHECKED_BLACK;
            else if (itemKey == BOUNCER_CHECKED_BLUE)
                p = PRICE_BOUNCER_CHECKED_BLUE;
            else if (itemKey == BOUNCER_CHECKED_RED)
                p = PRICE_BOUNCER_CHECKED_RED;
            else if (itemKey == BOUNCER_CHECKED_PURPLE)
                p = PRICE_BOUNCER_CHECKED_PURPLE;
            
            //zapper bouncers
            else if (itemKey == BOUNCER_ZAPPER_BLACK)
                p = PRICE_BOUNCER_ZAPPER_BLACK;
            else if (itemKey == BOUNCER_ZAPPER_BLUE)
                p = PRICE_BOUNCER_ZAPPER_BLUE;
            else if (itemKey == BOUNCER_ZAPPER_RED)
                p = PRICE_BOUNCER_ZAPPER_RED;
            else if (itemKey == BOUNCER_ZAPPER_PURPLE)
                p = PRICE_BOUNCER_ZAPPER_PURPLE;
            
            //electro bouncers
            else if (itemKey == BOUNCER_ELECTRO_BLACK)
                p = PRICE_BOUNCER_ELECTRO_BLACK;
            else if (itemKey == BOUNCER_ELECTRO_BLUE)
                p = PRICE_BOUNCER_ELECTRO_BLUE;
            else if (itemKey == BOUNCER_ELECTRO_RED)
                p = PRICE_BOUNCER_ELECTRO_RED;
            else if (itemKey == BOUNCER_ELECTRO_PURPLE)
                p = PRICE_BOUNCER_ELECTRO_PURPLE;

            //perfetto bouncers
            else if (itemKey == BOUNCER_PERFETTO_BLACK)
                p = PRICE_BOUNCER_PERFETTO_BLACK;
            else if (itemKey == BOUNCER_PERFETTO_BLUE)
                p = PRICE_BOUNCER_PERFETTO_BLUE;
            else if (itemKey == BOUNCER_PERFETTO_RED)
                p = PRICE_BOUNCER_PERFETTO_RED;
            else if (itemKey == BOUNCER_PERFETTO_PURPLE)
                p = PRICE_BOUNCER_PERFETTO_PURPLE;

            //armor
            else if (itemKey == ARMOR_3X)
                p = PRICE_ARMOR_3X;
            else if (itemKey == ARMOR_5X)
                p = PRICE_ARMOR_5X;
            else if (itemKey == ARMOR_10X)
                p = PRICE_ARMOR_10X;

			return p;
		}
	}
}
