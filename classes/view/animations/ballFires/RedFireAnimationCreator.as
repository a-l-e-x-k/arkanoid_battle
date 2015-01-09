/**
 * Author: Alexey
 * Date: 7/31/12
 * Time: 4:19 AM
 */
package view.animations.ballFires
{
	import model.constants.GameConfig;

	/**
 * Used on loading, to create StarlingAnimMc
 */
public class RedFireAnimationCreator extends BlueFireAnimationCreator
{
	public function RedFireAnimationCreator(framesTotal:int, objectsNeeded:int, initDelay:int)
	{
		super (framesTotal, objectsNeeded, initDelay);
	}

	override protected function createPathMc():void
	{
		_pathmc = new firepath();
		_rendererWidth = 60;
		_rendererHeight = 38;
		_prefetchTime = 0;

		_pathmc.x += GameConfig.BALL_RADIUS;
		_pathmc.y += GameConfig.BALL_RADIUS;
		_pathmc.x += 10;
		_pathmc.y += 10;

//		_pathmc.x -= 16;
//		_pathmc.x -= 16.45;

		addChildAt(_pathmc, 0);
		resetPath();
	}
}
}
