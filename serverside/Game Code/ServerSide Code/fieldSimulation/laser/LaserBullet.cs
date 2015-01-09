namespace ServerSide
{
    public class LaserBullet
    {
        private double _x;
        private double _y;
        public bool dead;

        public double x
        {
            get { return _x; }
        }

        public double y
        {
            get { return _y; }
        }

        public void upateCoordinates(double xx, double yy)
        {
            _x = xx;
            _y = yy;
        }

        public void die()
        {
            dead = true;
        }
    }
}