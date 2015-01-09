/**
 * Author: Alexey
 * Date: 11/11/12
 * Time: 3:17 AM
 */
package view.animations
{
	import flash.display.MovieClip;

	import starling.display.MovieClip;
	import starling.events.Event;

	import utils.animations.AnimationCreator;
	import utils.snapshoter.Snapshoter;

	public class BoomSmokeCreator extends AnimationCreator
	{
		private var _smoke:flash.display.MovieClip;

		public function BoomSmokeCreator(framesTotal:int, objectsNeeded:int, initDelay:int)
		{
			super(framesTotal, objectsNeeded, initDelay);
		}

		override protected function init():void
		{
			_smoke = new cloudanim();
			_smoke.x = 18;
			_smoke.y = 18;
			addChild(_smoke);
		}

		override protected function doSnapshot():void
		{
			_frameCount++;
			addFrame(Snapshoter.snapshot(this, 40, 40, true, 0));
			if (_frameCount == _framesTotal) //stop snapshoting, dictionary is filled
			{
				removeChild(_smoke);
				finish();
			}
		}
	}
}
