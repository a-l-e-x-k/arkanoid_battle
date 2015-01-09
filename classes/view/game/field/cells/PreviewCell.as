/**
 * Author: Alexey
 * Date: 12/7/12
 * Time: 6:45 PM
 */
package view.game.field.cells
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import model.game.bricks.BrickPresets;

	import model.constants.GameConfig;

	/**
	 * Used for maps preview which are rendered via usual Flash
	 */
	public class PreviewCell extends Sprite
	{
		public var i:int;
		public var j:int;
		public var brickType:int = -1;
		public var _brick:MovieClip;

		public function PreviewCell(i:int, j:int)
		{
			this.i = i;
			this.j = j;

			x = j * GameConfig.BRICK_WIDTH;
			y = i * GameConfig.BRICK_HEIGHT;
		}

		public function attachBrick(brickID:int):void
		{
			if (_brick && contains(_brick))
				removeChild(_brick);

			brickType = brickID;
			_brick = BrickPresets.getToolMCByID(brickType);
			addChildAt(_brick, Math.max(0, numChildren - 1));
		}
	}
}
