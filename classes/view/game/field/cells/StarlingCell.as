/**
 * Author: Alexey
 * Date: 5/9/12
 * Time: 12:51 PM
 */
package view.game.field.cells
{
	import events.RequestEventStarling;

	import external.caurina.transitions.Tweener;

	import model.StarlingTextures;
	import model.game.bricks.BrickPresets;
	import model.constants.GameConfig;
    import model.sound.SoundAsset;
    import model.sound.SoundAssetManager;

    import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;

	import utils.Misc;

	/**
	 * Used for is-game field, which is red\ndered via Starling
	 */
	public class StarlingCell extends Sprite
	{
		public var i:int;
		public var j:int;
		public var brickType:int = -1;
		public var _brick:Image;
		public var hitTestArea:Image;

		public function StarlingCell(i:int, j:int)
		{
			this.i = i;
			this.j = j;

			redrawHitTestArea();

			x = j * GameConfig.BRICK_WIDTH;
			y = i * GameConfig.BRICK_HEIGHT;
		}

		public function attachBrick(brickID:int):void
		{
			if (_brick && contains(_brick))
				removeChild(_brick);

			brickType = brickID;
			_brick = new Image(StarlingTextures.getTexture(brickID.toString()));
			_brick.pivotX = GameConfig.BRICK_WIDTH / 2;
			_brick.pivotY = GameConfig.BRICK_HEIGHT / 2;
			_brick.x = GameConfig.BRICK_WIDTH / 2;
			_brick.y = GameConfig.BRICK_HEIGHT / 2;
			addChildAt(_brick, Math.max(0, numChildren - 1));

			redrawHitTestArea(true);
		}

		public function clearBrick(currentTick:int = -1):void
		{
            if (currentTick != -1)
            {
                trace("[Cell shot by laser] tick: " + currentTick);
            }
			removeVisuals();
			setEmptyType();
		}

		public function goGlow():void
		{
			if (_brick && !_brick.filter)
			{
				_brick.filter = BlurFilter.createGlow(0xFFFFFF, 1, 2, 1);
			}
		}

		private function redrawHitTestArea(red:Boolean = false):void
		{
			if (!Config.UGLY_LOOK)
				return;

			if (hitTestArea && contains(hitTestArea))
				removeChild(hitTestArea);

			if (red)
				hitTestArea = new Image(StarlingTextures.getTexture(StarlingTextures.BRICK_HITTEST_AREA_RED));
			else
				hitTestArea = new Image(StarlingTextures.getTexture(StarlingTextures.BRICK_HITTEST_AREA_GREY));

			addChild(hitTestArea);
		}

		public function get notEmpty():Boolean
		{
			return brickType != BrickPresets.EMPTY_CELL;
		}

		/**
		 * @param delay in milliseconds
		 */
		public function clearWithDelay(delay:int):void
		{
			setEmptyType();
			Misc.delayCallback(removeVisuals, delay);
		}

		private function removeVisuals():void
		{
			Tweener.addTween(_brick, {scaleX:0, time:0.35, transition:"easeInQuint"});
			Tweener.addTween(_brick, {scaleY:0, time:0.35, transition:"easeInQuint", onComplete:removeFromStage});
			redrawHitTestArea();
		}

		private function removeFromStage():void
		{
			removeFromParent(true);
		}

		private function setEmptyType():void
		{
            SoundAssetManager.playSound(SoundAsset.BRICK_HIT);
			trace("Cleared brick at : " + i + " : " + j + " with type: " + brickType);
			if (brickType != BrickPresets.EMPTY_CELL)
			{
				var typeBefore:int = brickType;
				brickType = BrickPresets.EMPTY_CELL;
				dispatchEvent(new RequestEventStarling(RequestEventStarling.CELL_CLEARED, {x:x, y:y, brickType:typeBefore}));
			}
			else
                trace("[Warning!] Cleared already empty brick at: " + i + " : " + j + " with type: " + brickType);
				//throw new Error("Trying to clear already cleared brick!");
		}
	}
}
