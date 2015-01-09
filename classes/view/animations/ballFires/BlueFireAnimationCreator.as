/**
 * Author: Alexey
 * Date: 7/31/12
 * Time: 2:36 AM
 */
package view.animations.ballFires
{
import flash.display.MovieClip;

import starling.display.MovieClip;
import starling.events.Event;

import utils.animations.AnimationCreator;
import utils.snapshoter.Snapshoter;

/**
 * Used on loading, to create StarlingAnimMc
 */
public class BlueFireAnimationCreator extends AnimationCreator
{
	private static const HIT_FINISHED_FRAME:int = 70; //after frame 30 animation of "resurrection" of a path is finished and animation is stable

	protected var _rendererWidth:int = 100;
	protected var _rendererHeight:int = 33;
	protected var _prefetchTime:Number = 0.1;
	protected var _pathmc:flash.display.MovieClip;

	private var _ballamc:flash.display.MovieClip;

	public function BlueFireAnimationCreator(framesTotal:int, objectsNeeded:int, initDelay:int)
	{
		super(framesTotal, objectsNeeded, initDelay);
	}

	override protected function init():void
	{
		createBallMc();
		createPathMc();
	}

	private function createBallMc():void
	{
		_ballamc = new ballmc();
		addChild(_ballamc);
		_ballamc.gotoAndStop(2);
		_ballamc.x += 10;
		_ballamc.y += 10;
	}

	protected function createPathMc():void
	{
		_pathmc = new simplepath();
		_pathmc.x += 10;
		_pathmc.y += 10;
		_pathmc.x += 6;
		_pathmc.y += 6.45;
		addChildAt(_pathmc, 0);
		resetPath();
	}

	protected function resetPath():void
	{
		_pathmc.mc.emitter_mc.killParticles(); //This resets the emitter to the defaults and purges the pool
		_pathmc.mc.emitter_mc.stop(false, true);
		_pathmc.mc.emitter_mc.start(_prefetchTime);
		_pathmc.mc.emitter_mc.renderer.resize(_rendererWidth, _rendererHeight);
	}

	override protected function doSnapshot():void
	{
		addFrame(Snapshoter.snapshot(this, _rendererWidth, _rendererHeight, true, 0xFFF000));
		_frameCount++;

		if (_frameCount == _framesTotal) //stop snapshoting, dictionary is filled
		{
			_pathmc.mc.emitter_mc.killParticles(); //This resets the emitter to the defaults and purges the pool
			_pathmc.mc.emitter_mc.stop(false, true);
			removeChild(_pathmc);
			removeChild(_ballamc);
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
		if (targ.currentFrame == _framesTotal - 30)
			targ.currentFrame = HIT_FINISHED_FRAME;
	}
}
}
