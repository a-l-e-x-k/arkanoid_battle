/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/24/12
 * Time: 1:12 AM
 * To change this template use File | Settings | File Templates.
 */
package model.constants
{
    public class Ranks
    {
        //70-79 & 100 are special cases. Separate movieclips are used
        public static const COLOR_0:uint = 0xFF4199;
        public static const COLOR_10:uint = 0xFF00FF;
        public static const COLOR_20:uint = 0x985CFF;
        public static const COLOR_30:uint = 0x00F1FF;
        public static const COLOR_40:uint = 0x00DA83;
        public static const COLOR_50:uint = 0x00B200;
        public static const COLOR_60:uint = 0x7CD300;
        public static const COLOR_70:uint = 0xFFFF00;
        public static const COLOR_80:uint = 0xF38900;
        public static const COLOR_90:uint = 0xFF7744;
        public static const COLOR_100:uint = 0xFF3028;
        public static const COLOR_MAX:uint = 0x797979;

        public static function getColorByRank(rank:int):uint
        {
            var COLOR:int;

            if (rank < 10)
                COLOR = COLOR_0;
            else if (rank >= 10 && rank < 20)
                COLOR = COLOR_10;
            else if (rank >= 20 && rank < 30)
                COLOR = COLOR_20;
            else if (rank >= 30 && rank < 40)
                COLOR = COLOR_30;
            else if (rank >= 40 && rank < 50)
                COLOR = COLOR_40;
            else if (rank >= 50 && rank < 60)
                COLOR = COLOR_50;
            else if (rank >= 60 && rank < 70)
                COLOR = COLOR_60;
            else if (rank >= 70 && rank < 80)
                COLOR = COLOR_70;
            else if (rank >= 80 && rank < 90)
                COLOR = COLOR_80;
            else if (rank >= 90 && rank < 100)
                COLOR = COLOR_90;
            else if (rank == 100)
                COLOR = COLOR_100;
            else if (rank == 101)
                COLOR = COLOR_MAX;

            return COLOR;
        }
    }
}
