/**
 * Author: Alexey
 * Date: 7/18/12
 * Time: 12:47 AM
 */
package model.game.ball
{
    import events.RequestEvent;

    import flash.display.Shape;
    import flash.events.EventDispatcher;
    import flash.ui.Keyboard;

    import model.constants.GameConfig;
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import starling.display.Sprite;

    import view.game.ball.*;
    import view.game.field.BaseField;
    import view.game.field.BouncyShield;
    import view.game.field.PlayerField;

    public class BallsManager extends EventDispatcher
	{
		private const FIRE_SPEED:int = 5; //at speed 19 balls' paths will become fire-like

		private var _allBallsLaunched:Boolean = false;
		private var _currentTick:int;
		private var _testBallsNumber:int;  //thats for testing only
		private var _currentSpeed:int;
		private var _wigglesLeft:int;
		private var _balls:Vector.<BallModel> = new Vector.<BallModel>();
		private var _fieldLink:BaseField;
        private var _bouncyShield:BouncyShield;
		private var _parentObj:Sprite;

		public function BallsManager(fieldLink:BaseField, currentSpeed:int, testBallNumber:int, parentObj:Sprite)
		{
			_fieldLink = fieldLink;
			_testBallsNumber = testBallNumber;
			_currentSpeed = currentSpeed;
			_parentObj = parentObj;

            var bShieldMask:Shape = new Shape();
            bShieldMask.graphics.beginFill(0xFF0000, 1);
            bShieldMask.graphics.drawRect(0, 0, GameConfig.FIELD_WIDTH_PX + 2, GameConfig.FIELD_HEIGHT_PX);
            bShieldMask.graphics.endFill();
            fieldLink.addChild(bShieldMask);

            _bouncyShield = new BouncyShield(_balls);
            _bouncyShield.y = 160//150;
            _bouncyShield.mask = bShieldMask;
            fieldLink.addChild(_bouncyShield);
		}

		private function createBall():void
		{
			var ball:BallModel = new BallModel(_fieldLink.bouncer.x + (GameConfig.BOUNCER_WIDTH - GameConfig.BALL_SIZE) * 0.7,
					_fieldLink.bouncer.y - GameConfig.BALL_SIZE - 1, _parentObj, _fieldLink);
			trace((_fieldLink is PlayerField ? "[Player] " : "[Opponent] ") + "Ball at: " + ball.x + " : " + ball.y, " current tick: " + currentTick);
			_balls.push(ball);

			if (_currentSpeed > FIRE_SPEED) //change BallPath to fire (from cold fire)
				ball.path.setType(BallPath.TYPE_FIRE);

			if (_fieldLink.gameFinished)
				ball.goStealth();
		}

		public function speedUpTo(speed:int):void
		{
            SoundAssetManager.playSound(SoundAsset.SPEED_UP);

			//When there will be multiple balls, vall here update() func for each of them
			_currentSpeed = speed;
			if (_currentTick > 0) //don't fire up first time
				dispatchEvent(new RequestEvent(RequestEvent.SPEED_UP));

			if (_currentSpeed > FIRE_SPEED) //change BallPath to fire (from cold fire)
			{
				for each(var ballc:BallModel in _balls)
				{
					ballc.path.setType(BallPath.TYPE_FIRE);
				}
			}

			trace("Speed up to: " + _currentSpeed + " at tick: " + _currentTick, _fieldLink is PlayerField ? " [Player] " : " [Opponent] ");
		}

		public function tick():void
		{
			if (Config.CAPSLOCK_MOVES && !Keyboard.capsLock && _fieldLink is PlayerField)
				return;

			tryCreateStartBall();

            _bouncyShield.update();

			/**
			 * Calls functions as many times as the speed is, providing >1px precision for each movement.
			 * E.g. when hittesting agains cells at super speeds we won't miss a cell.
			 */
			var ballsToRemove:Array;
			for (var i:int = 0; i < _currentSpeed; i++)
			{
				ballsToRemove = [];

				for each (var ball:BallModel in _balls)
				{
					ball.updatePosition();
					BallHittester.hitTest(ball, _fieldLink, _bouncyShield.on);

					if (ball.dead) //died during performing 1px moves
					{
						ballsToRemove.push(ball);
					}
				}

				for each (ball in ballsToRemove)
				{
					removeBall(ball);
				}
			}

			_currentTick++;

			if (_wigglesLeft > 0)
			{
				_wigglesLeft--;
				if (_wigglesLeft == 0)
					stopWiggle();
			}
		}

		public function cleanUp():void
		{
			for each (var ballModel:BallModel in _balls)
			{
				killBall(ballModel);
			}

			_fieldLink = null;
			_parentObj = null;
			_balls = null;
		}

		private function removeBall(ball:BallModel):void
		{
			killBall(ball);
			dispatchEvent(new RequestEvent(RequestEvent.BALL_DEAD, {x:ball.x + GameConfig.BALL_RADIUS, y:ball.y + GameConfig.BALL_RADIUS}));
			if (_balls.length == 0)
			{
				createBall();
			}
		}

		private function killBall(ball:BallModel):void
		{
			_balls.splice(_balls.indexOf(ball), 1);
			ball.destroyView();
			ball = null;
		}

		private function tryCreateStartBall():void
		{
			if (!_allBallsLaunched)
			{
				if (_currentTick % 10 == 0 && _balls.length < _testBallsNumber)
				{
					createBall();
					if (_balls.length == _testBallsNumber)
					{
						_allBallsLaunched = true;
					}
				}
			}
		}

		public function goStealth():void
		{
			for each (var ball:BallModel in _balls)
			{
				ball.goStealth(); //balls will go out of stealth when hitting bouncer (ensuring they won't conflict with new preset)
			}
		}

		public function goWiggle():void
		{
			if (_wigglesLeft == 0)
			{
				for each (var ball:BallModel in _balls)
				{
					ball.goWiggle();
				}
			}

			_wigglesLeft += GameConfig.WIGGLE_LENGTH;
		}

        public function goBouncyShield():void
        {
             _bouncyShield.start();
        }

		private function stopWiggle():void
		{
			for each (var ball:BallModel in _balls)
			{
				if (ball.wiggler.wiggling)
					ball.stopWiggle();
			}
		}

		public function stopPathAnimations():void
		{
			for each (var ball:BallModel in _balls)
			{
				ball.path.stopAnimation();
			}
		}

		public function get currentTick():int
		{
			return _currentTick;
		}

		public function get allBallsLaunched():Boolean
		{
			return _allBallsLaunched;
		}

		public function get balls():Vector.<BallModel>
		{
			return _balls;
		}

        public function get bouncyShield():BouncyShield
        {
            return _bouncyShield;
        }
    }
}
