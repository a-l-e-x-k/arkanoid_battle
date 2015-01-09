namespace ServerSide
{
    public class MapStarsVO
    {
        private readonly int[] _stars;

        public MapStarsVO(int pointsForFirst, int pointsForSecond, int pointsForThird)
        {
            _stars = new int[3] {pointsForFirst, pointsForSecond, pointsForThird};
        }

        public int getStarsByPoints(int pts)
        {
            int starsCount = 0;
            if (pts >= _stars[2])
                starsCount = 3;
            else if (pts >= _stars[1])
                starsCount = 2;
            else if (pts >= _stars[0])
                starsCount = 1;
            return starsCount;
        }
    }
}