/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/21/12
 * Time: 1:08 AM
 * To change this template use File | Settings | File Templates.
 */
package model.constants
{
    public class MapStarsVO
    {
        private var _stars:Array = [];

        public function MapStarsVO(pointsForFirst:int, pointsForSecond:int, pointsForThird:int)
        {
            _stars = [pointsForFirst, pointsForSecond, pointsForThird]; //array in such way 0 => points needed for 1 star, 1 => points needed for 2 stars
        }

        public function getStarsByPoints(pts:int):int
        {
            var starsCount:int = 0;
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
