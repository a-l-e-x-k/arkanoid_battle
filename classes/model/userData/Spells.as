/**
 * Author: Alexey
 * Date: 8/18/12
 * Time: 2:01 AM
 */
package model.userData
{
    import flash.utils.Dictionary;

    import model.constants.GameConfig;

    import utils.Misc;

    /**
     * These are names of object properties as well, used in DB for storing skills configuration.
     * Not a name of GameRequest, those are separate things
     */
    public class Spells
    {
        public static const SPLIT_IN_TWO:String = "splitTwo";
        public static const SPLIT_IN_THREE:String = "splitThree";

        public static const LIGHTNING_ONE:String = "lightOne";
        public static const LIGHTNING_TWO:String = "lightTwo";
        public static const LIGHTNING_THREE:String = "lightThree";

        public static const CHARM_BALLS:String = "charmBalls";
        public static const FREEZE:String = "freeze";
        public static const BOUNCY_SHIELD:String = "bouncyShield";
        public static const LASER_SHOTS:String = "laserShots";
        public static const ROCKET:String = "rocket";

        public static function getAll():Array
        {
            return [SPLIT_IN_TWO, SPLIT_IN_THREE, LIGHTNING_ONE, LIGHTNING_TWO, LIGHTNING_THREE, CHARM_BALLS, FREEZE, BOUNCY_SHIELD, LASER_SHOTS, ROCKET];
        }

        /**
         * Returns default myspells for first game
         * @return
         */
        public static function getDefault():Dictionary
        {
            var exp:Number = Misc.currentUNIXSecs + GameConfig.SPELL_ACTIVATION_TIME * 60 * 60;
            var o:Dictionary = new Dictionary();
            o[FREEZE] = new SpellVO(FREEZE, exp, 1);
            o[SPLIT_IN_TWO] = new SpellVO(SPLIT_IN_TWO, exp, 2);
            o[LIGHTNING_ONE] = new SpellVO(LIGHTNING_ONE, exp, 3);
            o[LASER_SHOTS] = new SpellVO(LASER_SHOTS, exp, 4);
            o[BOUNCY_SHIELD] = new SpellVO(BOUNCY_SHIELD, exp, 5);
            return o;
        }

        public static function getFullSpellName(spellName:String):String
        {
            var res:String = "";
            switch (spellName)
            {
                case SPLIT_IN_TWO:
                    res = "Clone";
                    break;
                case SPLIT_IN_THREE:
                    res = "Triple Clone";
                    break;
                case LIGHTNING_ONE:
                    res = "Lightning";
                    break;
                case LIGHTNING_TWO:
                    res = "Double Lightning";
                    break;
                case LIGHTNING_THREE:
                    res = "Triple Lightning";
                    break;
                case CHARM_BALLS:
                    res = "Wiggle it!";
                    break;
                case FREEZE:
                    res = "Freeze";
                    break;
                case BOUNCY_SHIELD:
                    res = "Jelly Shield";
                    break;
                case LASER_SHOTS:
                    res = "Laser Shots";
                    break;
                case ROCKET:
                    res = "Rocket";
                    break;
            }
            return res;
        }

        public static function getSpellDescription(spellName:String):String
        {
            var res:String = "";
            switch (spellName)
            {
                case SPLIT_IN_TWO:
                    res = "Splits each of your balls in two new ones. More balls - more points.";
                    break;
                case SPLIT_IN_THREE:
                    res = "Splits each of your balls in three new ones. More balls - more points.";
                    break;
                case LIGHTNING_ONE:
                    res = "Use power of lightning to destroy any of the bricks at field.";
                    break;
                case LIGHTNING_TWO:
                    res = "Use it to destroy two randomly selected bricks at field.";
                    break;
                case LIGHTNING_THREE:
                    res = "Use it to destroy three randomly selected bricks at field.";
                    break;
                case CHARM_BALLS:
                    res = "Makes all balls of your opponent go nuts so that it is tough to catch them.";
                    break;
                case FREEZE:
                    res = "Freezes your opponent - balls and bouncer will stop moving for 7 sec.";
                    break;
                case BOUNCY_SHIELD:
                    res = "Creates shield which will bounce off all the balls you miss (for 7 sec).";
                    break;
                case LASER_SHOTS:
                    res = "Shoots 5 laser bullets (each of which destroys a brick).";
                    break;
                case ROCKET:
                    res = "Rocket will destroy from 5 to 7 balls of your opponent.";
                    break;
            }
            return res;
        }

        public static function isSpellDefensive(spellName:String):Boolean
        {
            return [CHARM_BALLS, FREEZE, ROCKET].indexOf(spellName) == -1;
        }
    }
}
