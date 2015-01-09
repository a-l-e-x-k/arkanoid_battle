/**
 * Author: Alexey
 * Date: 7/3/12
 * Time: 12:38 AM
 */
package view.game.textPopups
{
	import model.StarlingTextures;
	import model.constants.GameConfig;

	import starling.display.Image;

	public class MissPopup extends TextPopup
	{
		private const POPUP_FULL_SIZE_WIDTH:int = 49 + 20; //20px for "buffer"

		public function MissPopup(xx:Number, yy:Number)
		{
			var realX:Number = Math.max(POPUP_FULL_SIZE_WIDTH / 2, xx);   //so it won't go over left field border
			realX = Math.min((GameConfig.FIELD_WIDTH_PX - POPUP_FULL_SIZE_WIDTH / 2), realX);  //so it won't go over right field border

			var img:Image = new Image(StarlingTextures.getTexture(StarlingTextures.MISS_POPUP));
			super(realX, yy, img);
		}
	}
}
