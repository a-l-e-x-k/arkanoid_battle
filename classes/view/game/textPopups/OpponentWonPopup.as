/**
 * Author: Alexey
 * Date: 8/11/12
 * Time: 2:09 AM
 */
package view.game.textPopups
{
	import caurina.transitions.Tweener;

	import model.StarlingTextures;

	import starling.display.Image;

	public class OpponentWonPopup extends TextPopup
	{
		public function OpponentWonPopup(xx:Number, yy:Number)
		{
			var img:Image = new Image(StarlingTextures.getTexture(StarlingTextures.OPPONENT_WON_POPUP));
			super(xx, yy, img);
		}

		override protected function showAnimation():void
		{
			Tweener.addTween(_mc, {scaleX:1, time:1, transition:"easeOutElastic"});
			Tweener.addTween(_mc, {scaleY:1, time:1, transition:"easeOutElastic"});
		}
	}
}
