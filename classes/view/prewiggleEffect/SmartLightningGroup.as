/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:37 AM
 */
package view.prewiggleEffect
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;

	import model.game.ball.BallModel;
	import model.constants.GameConfig;
	import model.game.lightning.LightningFadeType;

	import view.game.field.BaseField;
	import view.game.lightning.Lightning;

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

		public function update(toField:BaseField, fromField:BaseField):void
		{
			var ballsLightning:Lightning;
			var updatedLightnings:Array = [];
			var balls:Vector.<BallModel> = toField.balls;
			var ballX:int;
			var ballY:int;
			var panelX:int = fromField.x + fromField.bouncer.x + GameConfig.BOUNCER_WIDTH / 2;
			var panelY:int = fromField.y + fromField.bouncer.y;

			for each (var ball:BallModel in balls)
			{
				ballX = ball.x + toField.x + GameConfig.BALL_RADIUS;
				ballY = ball.y + toField.y + GameConfig.BALL_RADIUS;

				if (_ballsDictionary[ball.view.name])
				{
					ballsLightning = _ballsDictionary[ball.view.name];
					setLightningCoordsUpdateAndAdd(ballsLightning, panelX, panelY, ballX, ballY);
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
					ballsLightning.wavelength = 0.2;
					ballsLightning.amplitude = 0.2;
					ballsLightning.alpha = 0.7;
					ballsLightning.childrenMaxCountDecay = .5;
					ballsLightning.childrenProbability = .3;
					ballsLightning.steps = 50;
					ballsLightning.childrenDetachedEnd = false;
					ballsLightning.alphaFadeType = LightningFadeType.GENERATION;
					ballsLightning.filters = [_glow];
					addChild(ballsLightning);

					setLightningCoordsUpdateAndAdd(ballsLightning, panelX, panelY, ballX, ballY);
					_ballsDictionary[ball.view.name] = ballsLightning;

				}

				updatedLightnings.push(ballsLightning);
			}

			for (var bName:String in _ballsDictionary)
			{
				if (updatedLightnings.indexOf(_ballsDictionary[bName]) == -1) //no ball for this lighting, delete it
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
			delete _ballsDictionary[bName];
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
