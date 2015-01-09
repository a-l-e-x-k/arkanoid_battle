/**
 * Author: Alexey
 * Date: 7/9/12
 * Time: 2:09 AM
 */
package model.constants
{
	import model.requests.GameRequest;

    public class GameConfig
    {
        public static const GAME_VERSION:int = 1;
        public static const FREEZER_SLOWDOWN_TIME:int = 45; //game ticks, approx 1.5seconds

        public static const GAME_ID:String = "arkanoid-battle-7qhch2ua0ic0hc32z4o0g";
        public static const COINS_START_AMOUNT:uint = 1200;
        public static const RANK_PROGRESS_START:int = 2;

		public static const SPELL_ACTIVATION_TIME:uint = 3; //time for which spells are activated (3 hours)
        public static const ENERGY_MAX:int = 36; //time for which spells are activated (3 hours)
        public static const ENERGY_CONSUMPTION_BIG_BATTLE:int = 6;
        public static const ENERGY_CONSUMPTION_SPRINT:int = 3;
        public static const ENERGY_CONSUMPTION_FIRST_100:int = 4;

        public static const BOUNCER_WIDTH:int = 85;
        public static const BOUNCER_HEIGHT:int = 36;
        public static const ENERGY_CONSUMPTION_UPSIDE_DOWN:int = 5;
		public static const FIELD_WIDTH_PX:int = 351;
        public static const FIELD_HEIGHT_PX:int = 390;
        public static const BRICK_WIDTH:int = 39;
        public static const BRICK_HEIGHT:int = 15;
        public static const BALL_SIZE:int = 12;
        public static const BALL_RADIUS:int = 6;
        public static const LASER_BULLET_WIDTH:int = 16;

        public static const WIGGLER_WAVE_LENGTH_IN_TICKS:int = 30;
		public static const WIGGLER_WAVE_HEIGHT:int = 10;

		public static const WIGGLE_LENGTH:int = 150;
        public static const BOUNCY_SHIELD_LENGTH:int = 210; //game ticks, about 7 seconds

		public static const FREEZER_FREEZE_TIME:int = 120; //for 4 seconds player is completely frozen, no action
        public static const BOUNCER_WATER_DEPTH:int = 25; //distance between usual critical line and the water line when bouncy field is turned on

        //************Cooldown time in milliseconds*********
		public static const COOLDOWN_SPLIT_TWO:int = 5000;
        public static const COOLDOWN_SPLIT_THREE:int = 9000;
        public static const COOLDOWN_LIGHT_ONE:int = 4000;
        public static const COOLDOWN_LIGHT_TWO:int = 5000;
        public static const COOLDOWN_LIGHT_THREE:int = 5000;
        public static const COOLDOWN_CHARM_BALLS:int = 7000;
        public static const COOLDOWN_FREEZE:int = 20000;
        public static const COOLDOWN_BOUNCY_SHIELD:int = 22000;
        public static const COOLDOWN_LASER_SHOTS:int = 5000;
        public static const COOLDOWN_ROCKET:int = 25000;
        //once per minute max (effect is long - about 6 secs of complete stop)

		/**
		 * Pass in-game request which was executed (request associated with powerup)
		 * @param requestID
		 * @return
		 */
		public static function getCooldownTimeByRequest(requestID:int):int
		{
			var r:int = 0;
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
                case GameRequest.ROCKET:
                    r = COOLDOWN_ROCKET;
                    break;
			}
			return r;
		}
	}
}
