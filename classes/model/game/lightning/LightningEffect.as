/**
 * Author: Alexey
 * Date: 7/29/12
 * Time: 3:59 AM
 */
package model.game.lightning
{
	import events.RequestEvent;

	import flash.geom.Point;

	import model.constants.GameConfig;

	import utils.Misc;

	import view.game.field.BaseField;
	import view.game.field.cells.StarlingCell;
	import view.game.lightning.*;

	public class LightningEffect
	{
		public static function strike(field:BaseField, numberOfBricks:int, lightningData:String = ""):String
		{
			var targetBricks:Array;
			if (lightningData == "")
				targetBricks = getTargetBricks(field.allCells, numberOfBricks);
			else
				targetBricks = parseTargetBricksData(lightningData, field.cellsGrid);

			if (targetBricks.length == 0) //if between presets (one finished, 2nd havent started yet)
				return "";

			var highestBrickY:Number = 0;
			for each (var cella:StarlingCell in field.allCells)
			{
				if (cella.notEmpty && cella.y > highestBrickY)
					highestBrickY = cella.y;
			}

			var centerX:Number = GameConfig.FIELD_WIDTH_PX / 2;
			var centerY:Number = (GameConfig.FIELD_HEIGHT_PX - highestBrickY) / 2 + highestBrickY;

			/**
			 * Go through all target bricks and insta-kill them (server will do the same)
			 * though they should stay visible for ~200-300ms until lighting will strike them
			 * (maybe play some anim on brick)
			 *
			 * + Kill itself after say 400 ms and playing animation on bricks
			 */
			var ijcoordsOfBricks:Array = getIJCoordinates(targetBricks);
			var lg:LightningGroup = new LightningGroup(field.bouncer, centerX, centerY, getBrickPoints(targetBricks));
			lg.addEventListener(RequestEvent.IMREADY, function (e:RequestEvent):void
			{
				/***
				 * Play animation on bricks for like 700ms
				 * Remove bricks,
				 */
				Misc.delayCallback(function ():void
				{
					field.removeChild(lg);
					lg.die();
				}, 700);
			});
			field.addChild(lg);
			Misc.mask(lg, field.x, field.y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);

			clearBricksWithDelay(targetBricks);

			return ijcoordsOfBricks.join(";"); //return bricks which were hit for server
		}

		private static function parseTargetBricksData(lightningData:String, allFieldCells:Array):Array
		{
			var result:Array = [];
			var bricksDatas:Array = lightningData.split(";");
			var brickIJ:Array;
			var brickI:int;
			var brickJ:int;

			for each (var brickData:String in bricksDatas)
			{
				brickIJ = brickData.split("!");
				brickI = brickIJ[0];
				brickJ = brickIJ[1];
				result.push(allFieldCells[brickI][brickJ]);
			}

			return result;
		}

		private static function getTargetBricks(allCells:Array, numberOfBricks:int):Array
		{
			var result:Array = [];

			if (numberOfNotEmptyBricks(allCells) < numberOfBricks) //e.g. if 2-branch lighting in used on a field where just one brick is left
				numberOfBricks = numberOfNotEmptyBricks(allCells);

			if (numberOfBricks == 1) //just hitting any brick
			{
				result.push(getRandomBottomBrick(allCells));
			}
			else if (numberOfBricks == 2) //find leftmost & rightmost bricks so that effect will be cool-looking
			{
				result = result.concat(getSideBricks(allCells));
			}
			else if (numberOfBricks == 3)
			{
				var sideBricks:Array = getSideBricks(allCells);
				result = result.concat(sideBricks);
				result.push(getCentermostBrick(allCells, sideBricks));
			}

			return result;
		}

		private static function clearBricksWithDelay(targetBricks:Array):void
		{
			for each (var brick:StarlingCell in targetBricks)
			{
				brick.clearWithDelay(300); //in 800ms brick will become invisible. Right now it is set as empty already
				trace("Hit brick at: " + brick.i + " : " + brick.j);
			}
		}

		public static function numberOfNotEmptyBricks(cells:Array):int
		{
			var count:int = 0;
			for each (var cell:StarlingCell in cells)
			{
				if (cell.notEmpty)
					count++;
			}
			return count;
		}

		private static function getRandomBrick(cells:Array):StarlingCell
		{
			var result:StarlingCell;
			var randomBrick:StarlingCell;
			while (result == null)
			{
				randomBrick = cells[Misc.randomNumber(cells.length - 1)];
				if (randomBrick.notEmpty)
					result = randomBrick;
			}
			return result;
		}

		private static function getRandomBottomBrick(cells:Array):StarlingCell
		{
			var bottomBricks:Array = [];
			var bottommostCoord:int = 0;

			for each (var cell:StarlingCell in cells)
			{
				if (!cell.notEmpty)
					continue;

				if (cell.i > bottommostCoord) //new bottom found
				{
					bottomBricks = [cell];
					bottommostCoord = cell.i;
				}
				else if (cell.i == bottommostCoord) //found cell at current max bottomost level
					bottomBricks.push(cell);
			}
			return bottomBricks[Misc.randomNumber(bottomBricks.length - 1)];
		}

		private static function getCentermostBrick(cells:Array, sideBricks:Array):StarlingCell
		{
			var centerMostBrick:StarlingCell = getRandomBrick(cells);
			var idealX:Number = GameConfig.FIELD_WIDTH_PX / 2 - GameConfig.BRICK_WIDTH / 2;

			for each (var cell:StarlingCell in cells)
			{
				if (Math.abs(cell.x - idealX) < Math.abs(centerMostBrick.x - idealX) && cell.y >= centerMostBrick.y && cell.notEmpty) //get closest brick to center
					centerMostBrick = cell;
			}

			if (sideBricks.indexOf(centerMostBrick))
				centerMostBrick = getBrickDifferentFrom(cells, sideBricks);

			return centerMostBrick;
		}

		private static function getBrickPoints(targetBricks:Array):Array
		{
			var result:Array = [];
			for each (var cell:StarlingCell in targetBricks)
			{
				result.push(new Point(cell.x + GameConfig.BRICK_WIDTH / 2, cell.y + GameConfig.BRICK_HEIGHT / 2));
				cell.goGlow();
			}
			return result;
		}

		private static function getIJCoordinates(targetBricks:Array):Array
		{
			var result:Array = [];
			for each (var cell:StarlingCell in targetBricks)
			{
				result.push(cell.i + "!" + cell.j);
			}
			return result;
		}

		/**
		 * Sure thing it'll return different cells. Check for equality is made
		 * @param allCells
		 * @return
		 */
		private static function getSideBricks(allCells:Array):Array
		{
			var leftmostBrick:StarlingCell = getRandomBrick(allCells);
			var rightmostBrick:StarlingCell = getRandomBrick(allCells);

			for each (var cell:StarlingCell in allCells)
			{
				if (cell.x <= leftmostBrick.x && cell.y >= leftmostBrick.y && cell.notEmpty)
					leftmostBrick = cell;

				if (cell.x >= rightmostBrick.x && cell.y >= rightmostBrick.y && cell.notEmpty)
					rightmostBrick = cell;
			}

			if (leftmostBrick == rightmostBrick) //thats only possible when bricks are left in a column (with same X)
				leftmostBrick = getBrickDifferentFrom(allCells, [leftmostBrick]);

			return [leftmostBrick, rightmostBrick];
		}

		/**
		 * Returns brick from field which is not the any of those passed in the arguments
		 * @param allCells all possible cells
		 * @param arr cells from which output should be different
		 * @return
		 */
		private static function getBrickDifferentFrom(allCells:Array, arr:Array):StarlingCell
		{
			var differentBrick:StarlingCell;
			for each (var cell:StarlingCell in allCells)
			{
				if (cell.notEmpty && arr.indexOf(cell) == -1) //find any other brick
				{
					differentBrick = cell;
					break;
				}
			}
			return differentBrick;
		}
	}
}
