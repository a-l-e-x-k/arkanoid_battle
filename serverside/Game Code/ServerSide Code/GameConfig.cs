namespace ServerSide
{
    /**
	 * The only place for game constants.
	 * They are sent to client on each game start.
	 */

    internal class GameConfig
    {
        public const int GAME_VERSION = 1;

        public const uint COINS_START_AMOUNT = 1200;
        public const int RANK_PROGRESS_START = 2;
        public const uint SPELL_ACTIVATION_TIME = 3; //hours

        public const uint COINS_FOR_WIN_SPRINT = 35;
        public const uint COINS_FOR_LOSE_SPRINT = 10;

        public const uint COINS_FOR_WIN_BIG_BATTLE = 70;
            //big battle should consume more energy to compensate higher rewards

        public const uint COINS_FOR_LOSE_BIG_BATTLE = 30;
            //big battle should consume more energy to compensate higher rewards

        public const uint COINS_FOR_WIN_FIRST_100 = 35;
        public const uint COINS_FOR_LOSE_FIRST_100 = 10;
        public const uint COINS_FOR_WIN_UPSIDE_DOWN = 35;
        public const uint COINS_FOR_LOSE_UPSIDE_DOWN = 10;

        public const int ENERGY_MAX = 36;
        public const int ENERGY_REFILL_INTERVAL = 180; //In seconds. 3 minutes
        public const int ENERGY_CONSUMPTION_BIG_BATTLE = 6;
        public const int ENERGY_CONSUMPTION_SPRINT = 3;
        public const int ENERGY_CONSUMPTION_FIRST_100 = 4;
        public const int ENERGY_CONSUMPTION_UPSIDE_DOWN = 5;

        public const int BOUNCER_WIDTH = 85;
        public const int BOUNCER_HEIGHT = 36;
        public const int FIELD_WIDTH_PX = 351; //in pixels
        public const int FIELD_HEIGHT_PX = 390; //in pixels
        public const int BRICK_WIDTH = 39;
        public const int BRICK_HEIGHT = 15;
        public const int BALL_SIZE = 12; //12px diameter
        public const int BALL_RADIUS = 6; //6px 
        public const int LASER_BULLET_WIDTH = 16;

        public const int WIGGLER_WAVE_LENGTH_IN_TICKS = 30; //in this amount of steps whole sine thing will be drawn
        public const int WIGGLER_WAVE_HEIGHT = 10; //deviation from regular path (in one side)
        public const int WIGGLE_LENGTH = 150; //5sec (5 seconds * 30 ticks).

        public const int FREEZER_SLOWDOWN_TIME = 45; //30 game ticks, approx 1.5seconds
        public const int FREEZER_FREEZE_TIME = 120; //for 4 seconds player is completele frozen, no action

        public const int BOUNCY_SHIELD_LENGTH = 210; //game ticks, about 5 seconds

        public const int BOUNCER_WATER_DEPTH = 25;
            //distance between usual critical line and the water line when bouncy field is turned on

        //************Cooldown time in milliseconds*********
        public const int COOLDOWN_SPLIT_TWO = 5000;
        public const int COOLDOWN_SPLIT_THREE = 9000;
        public const int COOLDOWN_LIGHT_ONE = 4000;
        public const int COOLDOWN_LIGHT_TWO = 5000;
        public const int COOLDOWN_LIGHT_THREE = 5000;
        public const int COOLDOWN_CHARM_BALLS = 7000;
        public const int COOLDOWN_FREEZE = 20000; //once per minute max (effect is long - about 6 secs of complete stop)
        public const int COOLDOWN_BOUNCY_SHIELD = 22000;
        public const int COOLDOWN_LASER_SHOTS = 5000;

        /**
		 * Pass in-game request which was executed (request associated with powerup).
		 * @param requestID
		 * @return
		 */

        public static int getCooldownTimeByRequest(int requestID)
        {
            int r = 0;
            switch (requestID)
            {
                case GameRequest.SPLIT_BALL_IN_TWO:
                    r = COOLDOWN_SPLIT_TWO;
                    break;
                case GameRequest.SPLIT_BALL_IN_THREE:
                    r = COOLDOWN_SPLIT_THREE;
                    break;
                case GameRequest.LIGHTNING_ONE:
                    r = COOLDOWN_LIGHT_ONE;
                    break;
                case GameRequest.LIGHTNING_TWO:
                    r = COOLDOWN_LIGHT_TWO;
                    break;
                case GameRequest.LIGHTNING_THREE:
                    r = COOLDOWN_LIGHT_THREE;
                    break;
                case GameRequest.CHARM_BALLS:
                    r = COOLDOWN_CHARM_BALLS;
                    break;
                case GameRequest.FREEZE:
                    r = COOLDOWN_FREEZE;
                    break;
                case GameRequest.BOUNCY_SHIELD:
                    r = COOLDOWN_BOUNCY_SHIELD;
                    break;
                case GameRequest.LASER_SHOTS:
                    r = COOLDOWN_LASER_SHOTS;
                    break;
            }
            return r;
        }
    }
}