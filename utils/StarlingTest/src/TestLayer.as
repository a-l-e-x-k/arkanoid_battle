/**
 * Author: Alexey
 * Date: 10/13/12
 * Time: 2:47 PM
 */
package {
	import external.caurina.transitions.Equations;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	import utils.ColorUtils;
	import utils.snapshoter.Snapshoter;

	public class TestLayer extends Sprite
	{
		private var _colorsDictionary:Dictionary = new Dictionary();
		private var _items:Array = [];

		public function TestLayer()
		{

		}

		public function createItems():void
		{
			var itemsAmount:int = 10000;
			var itemsInRow:int = Math.pow(itemsAmount, 0.5);
			var hheight:int = 700;
			var wwidth:int = 700;
			var rowsCount:int = Math.ceil(itemsAmount / itemsInRow);
			var xStep:Number = wwidth / rowsCount;
			var yStep:Number = hheight / rowsCount;

			var step:int = 0;
			var stepToPass:int = 0;

			var ballMC:MovieClip = new ballmc();
			ballMC.gotoAndStop(2);
			var ballBitmap:Bitmap = Snapshoter.snapshot(ballMC, ballMC.width, ballMC.height, true, 0xFFF000);
			var ballTexture:Texture = Texture.fromBitmap(ballBitmap);

			fillFilters();
			Equations.init(); //register functions (tweenType - function association)

			for (var i:int = 0; i < rowsCount; i++)
			{
				for (var j:int = 0; j < rowsCount; j++)
				{
					step++;

					stepToPass = step % 200;
					stepToPass -= 100;

					var ballImg:TweenableImage = new TweenableImage(ballTexture);
					ballImg.color = _colorsDictionary[stepToPass];
					ballImg.touchable = false;
					ballImg.x = j * xStep;
					ballImg.y = i * yStep;
					ballImg.startTween(12, "easeOutExpo", "alpha", 0, removeImage);
					addChild(ballImg);
					_items.push(ballImg);
				}
			}

			addEventListener(Event.ENTER_FRAME, move);
		}

		private function removeImage(me:*):void
		{
			_items.splice(_items.indexOf(me), 1);
			me.dispose();
			me.removeFromParent(true);  //self-destroying
		}

		private function move(event:Event):void
		{
			for each (var image:TweenableImage in _items)
			{
				image.update();
			}
		}

		private function fillFilters():void
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
