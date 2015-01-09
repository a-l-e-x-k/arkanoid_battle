/**
 * Author: Alexey
 * Date: 8/27/12
 * Time: 1:51 AM
 */
package view.animations
{
import flash.display.MovieClip;

import starling.display.MovieClip;
import starling.events.Event;

import utils.animations.AnimationCreator;
import utils.snapshoter.Snapshoter;

public class SmokeCreator extends AnimationCreator
{
	private static const FRAME_FADE_OUT:int = 40;

	private var _smoke:flash.display.MovieClip;

	public function SmokeCreator(framesTotal:int, objectsNeeded:int, initDelay:int)
	{
		super (framesTotal, objectsNeeded, initDelay);
	}

	override protected function init():void
	{
		_smoke = new smokeeffect();
		_smoke.smokeeffectmcc.particle = SL_SmokeHQParticle;
		_smoke.x = 20;
		_smoke.y = 225;
		addChild(_smoke);
	}

	override protected function doSnapshot():void
	{
		addFrame(Snapshoter.snapshot(this, 65, 250, true, 0));
		_frameCount++;

		if (_frameCount == FRAME_FADE_OUT)
		{
			_smoke.smokeeffectmcc.stop(false, true);
		}

		if (_frameCount == _framesTotal) //stop snapshoting, dictionary is filled
		{
			_smoke.smokeeffectmcc.killParticles(); //This resets the emitter to the defaults and purges the pool
			removeChild(_smoke);
			finish();
		}
	}

	override protected function addLoops(mc:starling.display.MovieClip):void
	{
		mc.addEventListener(Event.ENTER_FRAME, checkFrame);
	}

	private function checkFrame(event:Event):void
	{
		var targ:starling.display.MovieClip = (event.currentTarget as starling.display.MovieClip);
		if (targ.currentFrame == _framesTotal)
			targ.stop();
	}
}
}
