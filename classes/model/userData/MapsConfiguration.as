/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/22/12
 * Time: 5:08 PM
 * To change this template use File | Settings | File Templates.
 */
package model.userData
{
    import events.RequestEvent;

    import flash.utils.Dictionary;

    import utils.EventHub;

    public class MapsConfiguration
    {
        private var _config:Dictionary;

        public function MapsConfiguration(s:Dictionary)
        {
            _config = s;
            EventHub.addEventListener(RequestEvent.MAP_COMPLETED, updateMapConfig);
        }

        private function updateMapConfig(event:RequestEvent):void
        {
            var starsCount:int = event.stuff.starsAmount;
            _config[event.stuff.mapID] = Math.max(_config[event.stuff.mapID], starsCount);
        }

        public function getStars(id:int):int
        {
            return _config[id];
        }

        public function updateStars(mapID:int, starsEarned:int):void
        {
            _config[mapID] = Math.max(_config[mapID], starsEarned);
        }

        public function getUserStarsCount():int
        {
            var ta:int;
            for each (var starCount:int in _config)
            {
                ta += starCount;
            }
            return ta;
        }
    }
}
