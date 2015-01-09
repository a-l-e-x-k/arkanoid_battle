/**
 * Author: Alexey
 * Date: 7/3/12
 * Time: 12:39 AM
 */
package view.game.textPopups
{
import external.caurina.transitions.Tweener;

import starling.display.Image;

import starling.display.Sprite;

public class TextPopup extends Sprite
{
	protected var _mc:Image;

	public function TextPopup(xx:Number, yy:Number, mc:Image)
	{
		_mc = mc;
		addChild(mc);

		x = xx;
		y = yy;
		pivotX = width / 2;
		pivotY = height / 2;
		scaleX = 0;
		scaleY = 0;

		showAnimation();
	}

	/**
	 * Tweens scale of a text popup (
	 * This method is ok to override for specific animations at other view.popups
	 */
	protected function showAnimation():void
	{
	   Tweener.addTween(this, {scaleX:1, time:1, transition:"easeOutElastic"});
	   Tweener.addTween(this, {scaleY:1, time:1, transition:"easeOutElastic", onComplete:function():void
	   {
		   Tweener.addTween(this, {alpha:0, time:0.5, transition:"easeOutSine"});
		   Tweener.addTween(this, {alpha:0, time:0.5, transition:"easeOutSine", onComplete:function():void
		   {
			   this.removeFromParent(true);
		   }});
	   }});
	}
}
}
