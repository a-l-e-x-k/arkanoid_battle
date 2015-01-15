/**
 * Author: Alexey
 * Date: 7/6/12
 * Time: 10:36 PM
 */
package view.game.textPopups
{
	import caurina.transitions.Tweener;

	import model.StarlingTextures;

	import starling.display.Image;

	public class OpponentLostPopup extends TextPopup
	{
		public function OpponentLostPopup(xx:Number, yy:Number)
		{
			var img:Image = new Image(StarlingTextures.getTexture(StarlingTextures.OPPONENT_LOST_POPUP));
			super(xx, yy, img);
		}

		override protected function showAnimation():void
		{
			Tweener.addTween(_mc, {scaleX:1, time:1, transition:"easeOutElastic"});
			Tweener.addTween(_mc, {scaleY:1, time:1, transition:"easeOutElastic"});
		}
	}
}
