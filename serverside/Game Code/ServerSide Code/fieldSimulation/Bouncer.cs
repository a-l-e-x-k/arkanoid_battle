namespace ServerSide
{
    public class Bouncer
    {
        private double _x;
        private double _y;
        public int currentWidth = GameConfig.BOUNCER_WIDTH;

        public Bouncer()
        {
            x = (double) (GameConfig.FIELD_WIDTH_PX - GameConfig.BOUNCER_WIDTH)/2;
            y = GameConfig.FIELD_HEIGHT_PX - GameConfig.BOUNCER_HEIGHT;
        }

        public double x
        {
            set { _x = Utils.floorWithPrecision(value, 3); }
            get { return _x; }
        }

        public double y
        {
            set { _y = Utils.floorWithPrecision(value, 3); }
            get { return _y; }
        }
    }
}