namespace ServerSide
{
    public class ShopItemsInfo
    {
        public const string ENERGY_REFILL = "energyRefill";
        public const string ENERGY_TICKET_1_DAY = "energy1Day";
        public const string ENERGY_TICKET_3_DAYS = "energy3Days";
        public const string ENERGY_TICKET_7_DAYS = "energy7Days";

        public const string BOUNCER_STANDART_RED = "bouncerStandartRed";
        public const string BOUNCER_STANDART_BLUE = "bouncerStandartBlue";
        public const string BOUNCER_STANDART_GREEN = "bouncerStandartGreen";
        public const string BOUNCER_STANDART_PURPLE = "bouncerStandartPurple";

        public const string BOUNCER_CHECKED_RED = "bouncerCheckedRed";
        public const string BOUNCER_CHECKED_BLUE = "bouncerCheckedBlue";
        public const string BOUNCER_CHECKED_PURPLE = "bouncerCheckedPurple";
        public const string BOUNCER_CHECKED_BLACK = "bouncerCheckedBlack";

        public const string BOUNCER_ZAPPER_RED = "bouncerZapperRed";
        public const string BOUNCER_ZAPPER_BLUE = "bouncerZappeBlue";
        public const string BOUNCER_ZAPPER_PURPLE = "bouncerZapperPurple";
        public const string BOUNCER_ZAPPER_BLACK = "bouncerZapperBlack";

        public const string BOUNCER_ELECTRO_RED = "bouncerElectroRed";
        public const string BOUNCER_ELECTRO_BLUE = "bouncerElectroBlue";
        public const string BOUNCER_ELECTRO_PURPLE = "bouncerElectroPurple";
        public const string BOUNCER_ELECTRO_BLACK = "bouncerElectroBlack";

        public const string BOUNCER_PERFETTO_RED = "bouncerPerfettoRed";
        public const string BOUNCER_PERFETTO_BLUE = "bouncerPerfettoBlue";
        public const string BOUNCER_PERFETTO_PURPLE = "bouncerPerfettoPurple";
        public const string BOUNCER_PERFETTO_BLACK = "bouncerPerfettoBlack";

        public const string ARMOR_ITEM = "armorItem"; //when we buy, say, armor_3x we add 3 armor items to pavault
        public const string ARMOR_3X = "armor3";
        public const string ARMOR_5X = "armor5";
        public const string ARMOR_10X = "armor10";

        public const string TAB_BOUNCERS = "Bouncers";
        public const string TAB_ENERGY = "Energy";
        public const string TAB_ARMOR = "Armor";

        //prices
        public const int PRICE_ENERGY_REFILL = 130;
        public const int PRICE_ENERGY_TICKET_1_DAY = 720;
        public const int PRICE_ENERGY_TICKET_3_DAYS = 1960;
        public const int PRICE_ENERGY_TICKET_7_DAYS = 4100;

        public const int PRICE_BOUNCER_STANDART_RED = 300;
        public const int PRICE_BOUNCER_STANDART_BLUE = 300;
        public const int PRICE_BOUNCER_STANDART_GREEN = 300;
        public const int PRICE_BOUNCER_STANDART_PURPLE = 300;

        public const int PRICE_BOUNCER_CHECKED_RED = 700;
        public const int PRICE_BOUNCER_CHECKED_BLUE = 700;
        public const int PRICE_BOUNCER_CHECKED_PURPLE = 700;
        public const int PRICE_BOUNCER_CHECKED_BLACK = 700;

        public const int PRICE_BOUNCER_ZAPPER_RED = 1500;
        public const int PRICE_BOUNCER_ZAPPER_BLUE = 1500;
        public const int PRICE_BOUNCER_ZAPPER_PURPLE = 1500;
        public const int PRICE_BOUNCER_ZAPPER_BLACK = 1500;

        public const int PRICE_BOUNCER_ELECTRO_RED = 3100;
        public const int PRICE_BOUNCER_ELECTRO_BLUE = 3100;
        public const int PRICE_BOUNCER_ELECTRO_PURPLE = 3100;
        public const int PRICE_BOUNCER_ELECTRO_BLACK = 3100;

        public const int PRICE_BOUNCER_PERFETTO_RED = 10000;
        public const int PRICE_BOUNCER_PERFETTO_BLUE = 10000;
        public const int PRICE_BOUNCER_PERFETTO_PURPLE = 10000;
        public const int PRICE_BOUNCER_PERFETTO_BLACK = 10000;

        public const int PRICE_ARMOR_3X = 150;
        public const int PRICE_ARMOR_5X = 220;
        public const int PRICE_ARMOR_10X = 400;

        public const int PRICE_ACTIVATION_SPLIT_TWO = 180;
        public const int PRICE_ACTIVATION_SPLIT_THREE = 250;
        public const int PRICE_ACTIVATION_LIGHTNING_ONE = 140;
        public const int PRICE_ACTIVATION_LIGHTNING_TWO = 180;
        public const int PRICE_ACTIVATION_LIGHTNING_THREE = 230;
        public const int PRICE_ACTIVATION_CHARM = 140;
        public const int PRICE_ACTIVATION_FREEZE = 300;
        public const int PRICE_ACTIVATION_BOUNCY_FIELD = 260;
        public const int PRICE_ACTIVATION_LASER_SHOTS = 200;
        public const int PRICE_ACTIVATION_ROCKET = 210;

        public static int getItemPrice(string itemKey)
        {
            int p = 0;
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