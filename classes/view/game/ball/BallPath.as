/**
 * Author: Alexey
 * Date: 7/7/12
 * Time: 6:34 PM
 */
package view.game.ball
{

	import model.animations.AnimationsManager;
	import model.constants.GameConfig;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	import utils.Misc;

	public class BallPath extends Sprite
{
	public static const TYPE_SIMPLE:int = 0;
	public static const TYPE_FIRE:int = 1;

	private var _type:int;
	private var _mc:MovieClip;
	private var _currentFrame:Number = 0; //trick for slowing down speed of path playback (for Freeze powerup)

	public function BallPath(ballType:int)
	{
		setType(ballType);
	}

	public function setType(ballType:int):void
	{
		var currentAngle:Number = _mc ? (Misc.degrees(_mc.rotation) - 180) * -1 : 0;

		cleanUp();

		_type = ballType;

		if (ballType == TYPE_SIMPLE)
			_mc = AnimationsManager.getAnimation(AnimationsManager.BLUE_FIRE);
		else if (ballType == TYPE_FIRE)
			_mc = AnimationsManager.getAnimation(AnimationsManager.RED_FIRE);

		_mc.pivotX = 10 + GameConfig.BALL_RADIUS; //shift + radius
		_mc.pivotY = 10 + GameConfig.BALL_RADIUS;
		_mc.stop();

		Starling.juggler.add(_mc);
		addChild(_mc);

		updateAngle(currentAngle);
	}

	public function update(frameStep:Number):void
	{
		_currentFrame += frameStep;

		if (_currentFrame >= _mc.numFrames)
			_currentFrame = 1;

		_mc.currentFrame = int(_currentFrame);
	}

	public function updateAngle(currentAngle:Number):void
	{
		_mc.rotation = Misc.radians(-currentAngle + 180);
		_mc.currentFrame = 1;
		_currentFrame = 1;
	}

	public function stopAnimation():void
	{
		_mc.stop();
	}

	public function cleanUp():void
	{
		if (_mc && contains(_mc))
		{
			_mc.stop();

			if (type == TYPE_SIMPLE)
				AnimationsManager.putAnimation(AnimationsManager.BLUE_FIRE, _mc);
			else if (type == TYPE_FIRE)
				AnimationsManager.putAnimation(AnimationsManager.RED_FIRE, _mc);

			Starling.juggler.remove(_mc);
			_mc.removeFromParent(true);
			_mc = null;
		}
	}

	public function get type():int
	{
		return _type;
	}

	public function get mc():MovieClip
	{
		return _mc;
	}
}
}
