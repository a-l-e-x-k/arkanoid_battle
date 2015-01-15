/**
 * Author: Alexey
 * Date: 7/17/12
 * Time: 1:23 AM
 */
package view.game.fire
{
	import caurina.transitions.Tweener;

	import model.animations.AnimationsManager;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.extensions.ClippedSprite;

	public class FireThings extends ClippedSprite
	{
		private var _torchOne:MovieClip;
		private var _torchTwo:MovieClip;

		private var _smokeOne:MovieClip;
		private var _smokeTwo:MovieClip;

		private var _awaitingFires:int = 0; //when fire is shown it is decremented. When smoke is requested it is incremented. Protects from showing smokes when fire was / is being shown already

		public function FireThings()
		{
			_torchOne = AnimationsManager.getAnimation(AnimationsManager.SPEED_UP_FIRE);
			_torchOne.addEventListener(Event.ENTER_FRAME, checkForAnimEnd);
			_torchOne.x = -5;
			_torchOne.y = 170;
			_torchOne.stop();
			addChild(_torchOne);

			_torchTwo = AnimationsManager.getAnimation(AnimationsManager.SPEED_UP_FIRE);
			_torchTwo.addEventListener(Event.ENTER_FRAME, checkForAnimEnd);
			_torchTwo.x = 300;
			_torchTwo.y = 170;
			_torchTwo.stop();
			addChild(_torchTwo);

			_smokeOne = AnimationsManager.getAnimation(AnimationsManager.SMOKE);
			_smokeOne.addEventListener(Event.ENTER_FRAME, checkForSmokeAnimEnd);
			_smokeOne.x = -5;
			_smokeOne.y = 170;
			_smokeOne.stop();
			addChild(_smokeOne);

			_smokeTwo = AnimationsManager.getAnimation(AnimationsManager.SMOKE);
			_smokeTwo.addEventListener(Event.ENTER_FRAME, checkForSmokeAnimEnd);
			_smokeTwo.x = 300;
			_smokeTwo.y = 170;
			_smokeTwo.stop();
			addChild(_smokeTwo);

			Starling.juggler.add(_torchOne);
			Starling.juggler.add(_torchTwo);
			Starling.juggler.add(_smokeOne);
			Starling.juggler.add(_smokeTwo);
		}

		private static function checkForSmokeAnimEnd(event:Event):void
		{
			if ((event.currentTarget as MovieClip).currentFrame == 145) //hard coding, yeah
				(event.currentTarget as MovieClip).stop();
		}

		private static function checkForAnimEnd(event:Event):void
		{
			if ((event.currentTarget as MovieClip).currentFrame == 82) //hard coding, yeah
				(event.currentTarget as MovieClip).stop();
		}

		public function showSmoke():void
		{
			_awaitingFires++;

			if (_awaitingFires > 0)
			{
				_smokeOne.alpha = 1;
				_smokeTwo.alpha = 1;
				_smokeOne.stop();
				_smokeTwo.stop();
				_smokeOne.play();
				_smokeTwo.play();
				Tweener.removeTweens(_smokeOne);
				Tweener.removeTweens(_smokeTwo);
			}
		}

		public function showFire():void
		{
			_awaitingFires--;
			_torchOne.play();
			_torchTwo.play();
			fadeSmokesOut();
		}

		private function fadeSmokesOut():void
		{
			Tweener.addTween(_smokeOne, {alpha:0, time:0.3, transition:"easeOutSine"});
			Tweener.addTween(_smokeTwo, {alpha:0, time:0.29, transition:"easeOutSine"});
		}

		public function cleanUp():void
		{
			AnimationsManager.putAnimation(AnimationsManager.SPEED_UP_FIRE, _torchOne);
			AnimationsManager.putAnimation(AnimationsManager.SPEED_UP_FIRE, _torchTwo);
			AnimationsManager.putAnimation(AnimationsManager.SMOKE, _smokeOne);
			AnimationsManager.putAnimation(AnimationsManager.SMOKE, _smokeTwo);

			Starling.juggler.remove(_torchOne);
			Starling.juggler.remove(_torchTwo);
			Starling.juggler.remove(_smokeOne);
			Starling.juggler.remove(_smokeTwo);
		}
	}
}
