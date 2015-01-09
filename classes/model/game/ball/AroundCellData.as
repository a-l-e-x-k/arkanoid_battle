/**
 * Author: Alexey
 * Date: 5/19/12
 * Time: 5:22 PM
 */
package model.game.ball
{
    import model.constants.GameConfig;
    import model.game.bricks.FieldCells;

	import view.game.field.cells.StarlingCell;

	/**
	 * Testing all 8 surrounding cells
	 */
	public class AroundCellData
	{
		public var nearbyCells:Vector.<StarlingCell> = new Vector.<StarlingCell>;
		public var rightBorderNearby:Boolean;
		public var leftBorderNearby:Boolean;
		public var topBorderNearby:Boolean;
		public var bottomBorderNearby:Boolean;

		public function AroundCellData(cells:Array, currentCellI:int, currentCellJ:int)
		{
			if (currentCellI < 0 || currentCellJ < 0 || currentCellI >= FieldCells.columnsCount || currentCellJ >= FieldCells.rowsCount)
			{
				leftBorderNearby = rightBorderNearby = topBorderNearby = bottomBorderNearby = true;
				return;
			}

			topBorderNearby = (currentCellJ - 1) < 0;
			bottomBorderNearby = (currentCellJ + 1) >= FieldCells.rowsCount;
			rightBorderNearby = (currentCellI + 1) >= FieldCells.columnsCount;
			leftBorderNearby = (currentCellI - 1) < 0;

			//Testing 1 cell down
			if (!bottomBorderNearby && cells[currentCellJ + 1][currentCellI].notEmpty)
				nearbyCells.push(cells[currentCellJ + 1][currentCellI]);

//		    //Testing 1 cell right, 1 cell down
			if (!bottomBorderNearby && !rightBorderNearby && cells[currentCellJ + 1][currentCellI + 1].notEmpty)
				nearbyCells.push(cells[currentCellJ + 1][currentCellI + 1]);

			//Testing 1 cell right
			if (!rightBorderNearby && cells[currentCellJ][currentCellI + 1].notEmpty)
				nearbyCells.push(cells[currentCellJ][currentCellI + 1]);

//		    //Testing 1 cell up, 1 cell down
			if (!rightBorderNearby && !topBorderNearby && cells[currentCellJ - 1][currentCellI + 1].notEmpty)
				nearbyCells.push(cells[currentCellJ - 1][currentCellI + 1]);

			//Testing 1 cell up
			if (!topBorderNearby && cells[currentCellJ - 1][currentCellI].notEmpty)
				nearbyCells.push(cells[currentCellJ - 1][currentCellI]);

//	    	//Testing 1 cell left, 1 cell up
			if (!leftBorderNearby && !topBorderNearby && cells[currentCellJ - 1][currentCellI - 1].notEmpty)
				nearbyCells.push(cells[currentCellJ - 1][currentCellI - 1]);

			//Testing 1 cell left
			if (!leftBorderNearby && cells[currentCellJ][currentCellI - 1].notEmpty)
				nearbyCells.push(cells[currentCellJ][currentCellI - 1]);

//		    //Testing 1 cell down, 1 cell left
			if (!topBorderNearby && !leftBorderNearby && FieldCells.rowsCount > currentCellJ + 1 && cells[currentCellJ + 1][currentCellI - 1].notEmpty)
				nearbyCells.push(cells[currentCellJ + 1][currentCellI - 1]);

			if (cells[currentCellJ][currentCellI].notEmpty) //cell in which ball is (it could be skipped before)
				nearbyCells.push(cells[currentCellJ][currentCellI]);
		}
	}
}
