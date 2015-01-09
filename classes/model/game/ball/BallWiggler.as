/**
 * Author: Alexey
 * Date: 9/23/12
 * Time: 1:36 AM
 */
package model.game.ball
{
	import model.constants.GameConfig;
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import utils.Misc;
	import utils.TweenableImage;

	import view.game.ball.ColoredBallsManager;

	public class BallWiggler
	{
		private var _currentStepNumber:Number = 0;
		private var _totalStepsCount:Number = 0;
		private var _currentShiftX:Number = 0;
		private var _currentShiftY:Number = 0;
		private var _currentPerpendicularAngle:Number = 0;
		private var _wiggling:Boolean = false;
		private var _ballLink:BallModel;
		private var _wiggleImages:Array = [];

		public function BallWiggler(ballModel:BallModel)
		{
			_ballLink = ballModel;
		}

		public function tryUpdateShift():void
		{
			if (_wiggling)
			{
				var img:TweenableImage = ColoredBallsManager.createItem(_totalStepsCount % 200 - 100);
				img.x = _ballLink.x + _ballLink.view.path.x + 10;
				img.y = _ballLink.y + _ballLink.view.path.y + 10;
				img.pivotX = _ballLink.path.mc.pivotX;
				img.pivotY = _ballLink.path.mc.pivotY;
				img.startTween(2, "easeOutExpo", "alpha", 0, ColoredBallsManager.removeImage);
				_ballLink.fieldLink.view.wiggleImagesContainer.addChild(img);
				_wiggleImages.push(img);

				var angleBefore:Number = _currentPerpendicularAngle;
				_currentPerpendicularAngle = (180 - _ballLink.getCurrentAngle()) + 90; //(get perpendicular)

				if (_currentPerpendicularAngle != angleBefore) //update
					reset();

				var currentShiftPercent:Number = Math.sin(Math.PI * 2 * (_currentStepNumber / GameConfig.WIGGLER_WAVE_LENGTH_IN_TICKS)); //from 0 to 1
				var currentShiftSize:Number = GameConfig.WIGGLER_WAVE_HEIGHT * currentShiftPercent;

				_currentShiftX = currentShiftSize * Math.cos(Misc.radians(_currentPerpendicularAngle));
				_currentShiftY = currentShiftSize * Math.sin(Misc.radians(_currentPerpendicularAngle));
				_currentStepNumber++;
				_totalStepsCount++;
			}
		}

		private function reset():void
		{
			_currentShiftX = 0;
			_currentShiftY = 0;
			_currentStepNumber = 0;
		}

		public function startWiggling():void
		{
			_wiggling = true;
            SoundAssetManager.playSound(SoundAsset.WIGGLE);
		}

		public function stopWiggling():void
		{
			reset();
			_wiggling = false;
		}

		public function get currentShiftX():Number
		{
			return _currentShiftX;
		}

		public function get currentShiftY():Number
		{
			return _currentShiftY;
		}

		public function get wiggling():Boolean
		{
			return _wiggling;
		}

		public function set currentShiftX(value:Number):void
		{
			_currentShiftX = value;
		}

		public function set currentShiftY(value:Number):void
		{
			_currentShiftY = value;
		}

		public function get currentPerpendicularAngle():Number
		{
			return _currentPerpendicularAngle;
		}

		public function set currentPerpendicularAngle(value:Number):void
		{
			_currentPerpendicularAngle = value;
		}

		public function get currentStepNumber():Number
		{
			return _currentStepNumber;
		}

		public function set currentStepNumber(value:Number):void
		{
			_currentStepNumber = value;
		}
	}
}
