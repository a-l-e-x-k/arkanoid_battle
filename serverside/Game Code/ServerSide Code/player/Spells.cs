namespace ServerSide
{
    internal class Spells
    {
        public const string SPLIT_IN_TWO = "splitTwo";
        public const string SPLIT_IN_THREE = "splitThree";

        public const string LIGHTNING_ONE = "lightOne";
        public const string LIGHTNING_TWO = "lightTwo";
        public const string LIGHTNING_THREE = "lightThree";

        public const string CHARM_BALLS = "charmBalls";
        public const string FREEZE = "freeze";
        public const string BOUNCY_SHIELD = "bouncyShield";
        public const string LASER_SHOTS = "laserShots";
        public const string ROCKET = "rocket";

        public static string getFullSpellName(string spellName)
        {
            string res = "";
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
                    res = "Protective Fluid";
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
    }
}