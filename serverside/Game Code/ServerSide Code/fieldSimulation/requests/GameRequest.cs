namespace ServerSide
{
    internal class GameRequest
    {
        public const int SPEED_UP = 0;
        public const int NEW_MAP = 1;
        public const int GAME_FINISH = 2;

        public const int SPLIT_BALL_IN_TWO = 10;
        public const int SPLIT_BALL_IN_THREE = 11;

        public const int LIGHTNING_ONE = 12;
        public const int LIGHTNING_TWO = 13;
        public const int LIGHTNING_THREE = 14;

        public const int PRE_CHARM_BALLS = 15; //aint executed at serverside
        public const int CHARM_BALLS = 16;
        public const int PRE_FREEZE = 17;
        public const int FREEZE = 18;
        public const int BOUNCY_SHIELD = 19;
        public const int LASER_SHOTS = 20;

        public const int PRE_ROCKET = 21;
        public const int ROCKET = 22;

        public static int getRequestIDBySpellName(string spellName)
        {
            int result = -1;
            switch (spellName)
            {
                case Spells.SPLIT_IN_TWO:
                    result = SPLIT_BALL_IN_TWO;
                    break;
                case Spells.SPLIT_IN_THREE:
                    result = SPLIT_BALL_IN_THREE;
                    break;
                case Spells.LIGHTNING_ONE:
                    result = LIGHTNING_ONE;
                    break;
                case Spells.LIGHTNING_TWO:
                    result = LIGHTNING_TWO;
                    break;
                case Spells.LIGHTNING_THREE:
                    result = LIGHTNING_THREE;
                    break;
                case Spells.CHARM_BALLS:
                    result = CHARM_BALLS;
                    break;
                case Spells.FREEZE:
                    result = FREEZE;
                    break;
                case Spells.BOUNCY_SHIELD:
                    result = BOUNCY_SHIELD;
                    break;
                case Spells.LASER_SHOTS:
                    result = LASER_SHOTS;
                    break;
                case Spells.ROCKET:
                    result = ROCKET;
                    break;
            }
            return result;
        }

        public static string getSpellNameByRequest(int reqID)
        {
            string spellName = "";
            switch (reqID)
            {
                case SPLIT_BALL_IN_TWO:
                    spellName = Spells.SPLIT_IN_TWO;
                    break;
                case SPLIT_BALL_IN_THREE:
                    spellName = Spells.SPLIT_IN_THREE;
                    break;
                case LIGHTNING_ONE:
                    spellName = Spells.LIGHTNING_ONE;
                    break;
                case LIGHTNING_TWO:
                    spellName = Spells.LIGHTNING_TWO;
                    break;
                case LIGHTNING_THREE:
                    spellName = Spells.LIGHTNING_THREE;
                    break;
                case CHARM_BALLS:
                case PRE_CHARM_BALLS: //for showing progress when charming powerup is allowed
                    spellName = Spells.CHARM_BALLS;
                    break;
                case FREEZE:
                case PRE_FREEZE: //for showing progress when freezing powerup is allowed
                    spellName = Spells.FREEZE;
                    break;
                case BOUNCY_SHIELD:
                    spellName = Spells.BOUNCY_SHIELD;
                    break;
                case LASER_SHOTS:
                    spellName = Spells.LASER_SHOTS;
                    break;
                case ROCKET:
                case PRE_ROCKET: //for showing progress when rocket powerup is allowed
                    spellName = Spells.ROCKET;
                    break;
            }

            return spellName;
        }
    }
}