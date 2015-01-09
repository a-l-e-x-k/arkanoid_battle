/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/7/13
 * Time: 12:37 AM
 * To change this template use File | Settings | File Templates.
 */
package view.game.field.cells
{
    /**
     * Simply contains list of map ids.
     * Game pulls actual data from static Maps class
     */
    public class MapsProgram
    {
        private var _maps:Array;
        private var _currentMapIndex:int = 0;

        public function MapsProgram(programCode:String)
        {
            var mapsString:Array = programCode.split(",");
            _maps = new Array(mapsString.length);
            for (var i:int = 0; i < _maps.length; i++)
            {
                _maps[i] = int(mapsString[i]);
            }
        }

        public function getNextMapID():int
        {
            var mapID:int = _maps[_currentMapIndex];
            _currentMapIndex++;
            if (_currentMapIndex == _maps.length)
                _currentMapIndex = 0;
            return mapID;
        }
    }
}
