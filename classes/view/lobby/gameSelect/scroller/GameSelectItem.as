/**
 * Author: Alexey
 * Date: 12/12/12
 * Time: 5:14 PM
 */
package view.lobby.gameSelect.scroller
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	import model.constants.GameTypes;

	import utils.MovieClipContainer;

	public class GameSelectItem extends MovieClipContainer
	{
        public var isPrivateSprint:Boolean = false; //hack, so that items scroller can detect that private battle is requested
		private var _gameType:String;
		private var _index:int;
		private var _bmp:Bitmap;

		public function GameSelectItem(gameType:String, index:int)
		{
			super(new gsitem());
			_gameType = gameType;
			_index = index;
			var picClass:Class;
			if (_gameType == GameTypes.BIG_BATTLE)
				picClass = bigbat;
			else  if (_gameType == GameTypes.FAST_SPRINT)
				picClass = fastsprint;
            else  if (_gameType == GameTypes.FAST_SPRINT_PRIVATE)
            {
                picClass = friendlybat;
                isPrivateSprint = true;
            }
			else if (_gameType == GameTypes.FIRST_100)
				picClass = first100;
			else if (_gameType == GameTypes.UPSIDE_DOWN)
				picClass = upsdown;
			_bmp = new Bitmap(new picClass());
			_bmp.smoothing = true;
			_mc.mc.cont_mc.addChild(_bmp);
		}

		public function clean():void
		{
			_bmp.bitmapData.dispose();
		}

		public function get gameType():String
		{
			return _gameType;
		}

		public function get index():int
		{
			return _index;
		}
	}
}
