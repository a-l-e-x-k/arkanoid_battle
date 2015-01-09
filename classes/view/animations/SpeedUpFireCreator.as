/**
 * Author: Alexey
 * Date: 8/1/12
 * Time: 12:56 AM
 */
package view.animations
{
import flash.display.MovieClip;

import starling.display.MovieClip;
import starling.events.Event;

import utils.animations.AnimationCreator;
import utils.snapshoter.Snapshoter;

public class SpeedUpFireCreator extends AnimationCreator
{
	private static const FRAME_FADE_OUT:int = 45;

	private var _flame:flash.display.MovieClip;

	public function SpeedUpFireCreator(framesTotal:int, objectsNeeded:int, initDelay:int)
	{
		super (framesTotal, objectsNeeded, initDelay);
	}

	override protected function init():void
	{
		_flame = new fireem();
		_flame.fire_mc.particle = SL_FlamesParticle;
		_flame.x = 20;
		_flame.y = 225;
		addChild(_flame);
	}

	override protected function doSnapshot():void
	{
		addFrame(Snapshoter.snapshot(this, 65, 250, true, 0));
		_frameCount++;

		if (_frameCount == FRAME_FADE_OUT)
		{
			_flame.fire_mc.stop(false, true);
		}

		if (_frameCount == _framesTotal) //stop snapshoting, dictionary is filled
		{
			_flame.fire_mc.killParticles(); //This resets the emitter to the defaults and purges the pool
			removeChild(_flame);
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
