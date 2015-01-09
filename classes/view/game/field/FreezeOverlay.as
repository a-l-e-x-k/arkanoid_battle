/**
 * Author: Alexey
 * Date: 11/25/12
 * Time: 2:24 AM
 */
package view.game.field
{
	import model.StarlingTextures;

	import starling.display.BlendMode;

	import starling.display.Image;
	import starling.extensions.ClippedSprite;

	public class FreezeOverlay extends ClippedSprite
	{
		public function FreezeOverlay()
		{
			var img:Image  = new Image(StarlingTextures.getTexture(StarlingTextures.FREEEZE_OVERLAY));
			img.blendMode = BlendMode.SCREEN;
			addChild(img);
		}
	}
}
