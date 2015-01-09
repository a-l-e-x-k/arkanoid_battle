/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:37 AM
 */
package
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class SmartLightningGroup extends Sprite
	{
		private var _glow:GlowFilter = new GlowFilter();
		private var _ballsDictionary:Dictionary = new Dictionary(); //ball - lightning dictionary

		public function SmartLightningGroup()
		{
			_glow.color = 0x9900CC;
			_glow.strength = 3;
			_glow.quality = 1;
			_glow.blurX = _glow.blurY = 1.5;
		}

		public function update(balls:Vector.<BallModel>, panelCoords:Point):void
		{
			var ballsLightning:Lightning;

			for each (var l:Lightning in _ballsDictionary)
			{
				l.gotUpdated = false;
			}

			for each (var ball:BallModel in balls)
			{
				if (_ballsDictionary[ball.name])
				{
					ballsLightning = _ballsDictionary[ball.name];
					setLightningCoordsUpdateAndAdd(ballsLightning, panelCoords.x, panelCoords.y, ball.x, ball.y);
					ballsLightning.update();
				}
				else
				{
					ballsLightning = new Lightning(0xffffff, 0.1);
					ballsLightning.blendMode = BlendMode.ADD;
					ballsLightning.childrenDetachedEnd = true;
					ballsLightning.childrenLifeSpanMin = .1;
					ballsLightning.childrenLifeSpanMax = 5;
					ballsLightning.childrenMaxCount = 1;
					ballsLightning.alpha = 0.7;
					ballsLightning.childrenMaxCountDecay = .5;
					ballsLightning.childrenProbability = .3;
					ballsLightning.steps = 50;
					ballsLightning.childrenDetachedEnd = false;
					ballsLightning.alphaFadeType = LightningFadeType.GENERATION;
					ballsLightning.filters = [_glow];
					addChild(ballsLightning);

					//TODO: test performance of that craziness (bunch of Images will be created.....)
					setLightningCoordsUpdateAndAdd(ballsLightning, panelCoords.x, panelCoords.y, ball.x, ball.y);
					_ballsDictionary[ball.name] = ballsLightning;

				}

				ballsLightning.gotUpdated = true;
			}

			for (var bName:String in _ballsDictionary)
			{
				if (!_ballsDictionary[bName].gotUpdated) //no ball for this lighting, delete it
				{
					trace("Removing died out lighting for ball name: " + bName);
					killLightning(bName);
				}
			}
		}

		private function killLightning(bName:String):void
		{
			_ballsDictionary[bName].kill(); //no need to remove child, lightning does it in kill()
			_ballsDictionary[bName] = null;
		}

		/**
		 * Updates coordinates
		 * Updates lightning
		 * Adds new lightning's image to starling's stage
		 * @param lightning
		 * @param startX
		 * @param startY
		 * @param endX
		 * @param endY
		 */
		private static function setLightningCoordsUpdateAndAdd(lightning:Lightning, startX:int, startY:int, endX:int, endY:int):void
		{
			lightning.startX = startX;
			lightning.startY = startY;
			lightning.endX = endX;
			lightning.endY = endY;
			lightning.update();
		}

		public function cleanUp():void
		{
			for (var bName:String in _ballsDictionary)
			{
				killLightning(bName);
			}
		}
	}
}
