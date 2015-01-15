/**
 * Author: Alexey
 * Date: 10/13/12
 * Time: 2:47 PM
 */
package view.game.ball
{
	import caurina.transitions.Equations;

	import flash.utils.Dictionary;

	import model.StarlingTextures;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	import utils.ColorUtils;
	import utils.TweenableImage;

	public class ColoredBallsManager
	{
		private static var _colorsDictionary:Dictionary = new Dictionary();
		private static var _items:Array = [];
		private static var _ballTexture:Texture;

		public static function init():void
		{
			_ballTexture = StarlingTextures.getTexture(StarlingTextures.BALL);
			fillFilters();
			Equations.init(); //register functions (tweenType - function association)
		}

		/**
		 * Creates new static colored ball
		 * @param colorIndex from -100 to 100 (hue)
		 */
		public static function createItem(colorIndex:int):TweenableImage
		{
			var ballImg:TweenableImage = new TweenableImage(_ballTexture);
			ballImg.color = _colorsDictionary[colorIndex];
			ballImg.touchable = false;
			_items.push(ballImg);
			return ballImg;
		}

		public static function removeImage(me:*):void
		{
			_items.splice(_items.indexOf(me), 1);
			me.dispose();
			me.removeFromParent(true);  //self-destroying
		}

		public static function update():void
		{
			for each (var image:TweenableImage in _items)
			{
				image.update();
			}
		}

		private static function fillFilters():void
		{
			var saturation:Number = 0.8;
			var brightness:Number = 0.5;

			var rgbArr:Array;
			var hexColorString:String;
			var hexColorNumber:uint;

			for (var i:Number = 0; i < 1.005; i += 0.005)
			{
				rgbArr = ColorUtils.hslToRgb(i, saturation, brightness);
				hexColorString = "0x" + ColorUtils.decToHex(rgbArr[0], rgbArr[1], rgbArr[2]).toLowerCase();
				hexColorNumber = uint(hexColorString);
				_colorsDictionary[Math.floor(i * 200 - 100)] = hexColorNumber;
			}
		}
	}
}
