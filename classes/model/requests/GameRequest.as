/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 2:05 AM
 */
package model.requests
{
    import model.userData.Spells;

    public class GameRequest
    {
        public static const SPEED_UP:int = 0;
        public static const NEW_MAP:int = 1;
        public static const GAME_FINISH:int = 2;

        public static const SPLIT_BALL_IN_TWO:int = 10;
        public static const SPLIT_BALL_IN_THREE:int = 11;

        public static const LIGHTNING_ONE:int = 12;
        public static const LIGHTNING_TWO:int = 13;
        public static const LIGHTNING_THREE:int = 14;

        public static const PRE_CHARM_BALLS:int = 15; //shows powerup usage at bouncer, some progress
        public static const CHARM_BALLS:int = 16;
        public static const PRE_FREEZE:int = 17;
        public static const FREEZE:int = 18;
        public static const BOUNCY_SHIELD:int = 19;
        public static const LASER_SHOTS:int = 20;

        /**
         * 1. Player uses ROCKET spell
         * 2. PRE_ROCKET request is executed by PlayerField -> PlayerField dispatches event -> Opponent's field shows "launching"
         * 3. Server receives PRE_ROCKET request -> tells opponent to execute ROCKET request
         * 4. Opponent is instantly launching rocket
         * 5. When Player's clientside recieves executed ROCKET request Opponent's field is executing ROCKET request, launching rocket
         */
        public static const PRE_ROCKET:int = 21;
        public static const ROCKET:int = 22;

        public static function getSpellNameByRequest(reqID:int):String
        {
            var spellName:String = "";
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
                case PRE_CHARM_BALLS: //for showing progress when charming powerup is allowed
                    spellName = Spells.CHARM_BALLS;
                    break;
                case PRE_FREEZE:     //for showing progress when freezing powerup is allowed
                    spellName = Spells.FREEZE;
                    break;
                case BOUNCY_SHIELD:
                    spellName = Spells.BOUNCY_SHIELD;
                    break;
                case LASER_SHOTS:
                    spellName = Spells.LASER_SHOTS;
                    break;
                case ROCKET:
                    spellName = Spells.ROCKET;
                    break;
            }

            return spellName;
        }

        public static function getRequestBySpellName(spellName:String):int
        {
            var reqID:int;
            switch (spellName)
            {
                case Spells.SPLIT_IN_TWO:
                    reqID = SPLIT_BALL_IN_TWO;
                    break;
                case Spells.SPLIT_IN_THREE:
                    reqID = SPLIT_BALL_IN_THREE;
                    break;
                case Spells.LIGHTNING_ONE:
                    reqID = LIGHTNING_ONE;
                    break;
                case Spells.LIGHTNING_TWO:
                    reqID = LIGHTNING_TWO;
                    break;
                case Spells.LIGHTNING_THREE:
                    reqID = LIGHTNING_THREE;
                    break;
                case Spells.CHARM_BALLS:
                    reqID = CHARM_BALLS;
                    break;
                case Spells.FREEZE:
                    reqID = FREEZE;
                    break;
                case Spells.BOUNCY_SHIELD:
                    reqID = BOUNCY_SHIELD;
                    break;
                case Spells.LASER_SHOTS:
                    reqID = LASER_SHOTS;
                    break;
                case Spells.ROCKET:
                    reqID = ROCKET;
                    break;
            }

            return reqID;
        }
    }
}
