using System.Collections;

namespace ServerSide
{
    internal class AroundCellData
    {
        public ArrayList _cells = new ArrayList();
        public bool bottomBorderNearby;
        public bool leftBorderNearby;
        public bool rightBorderNearby;
        public bool topBorderNearby;

        public AroundCellData(Cell[,] cells, int currentCellI, int currentCellJ, FieldSimulation field)
        {
            if (currentCellI < 0 || currentCellJ < 0 || currentCellI >= field.fieldCells.columnsCount ||
                currentCellJ >= field.fieldCells.rowsCount) //out of the "box"
            {
                leftBorderNearby = rightBorderNearby = topBorderNearby = bottomBorderNearby = true;
                return;
            }

            topBorderNearby = (currentCellJ - 1) < 0;
            bottomBorderNearby = (currentCellJ + 1) >= field.fieldCells.rowsCount;
            rightBorderNearby = (currentCellI + 1) >= field.fieldCells.columnsCount;
            leftBorderNearby = (currentCellI - 1) < 0;

            //Testing 1 cell down
            if (!bottomBorderNearby && cells[currentCellJ + 1, currentCellI].notEmpty)
                _cells.Add(cells[currentCellJ + 1, currentCellI]);

            //		//Testing 1 cell right, 1 cell down
            if (!bottomBorderNearby && !rightBorderNearby && cells[currentCellJ + 1, currentCellI + 1].notEmpty)
                _cells.Add(cells[currentCellJ + 1, currentCellI + 1]);

            //Testing 1 cell right
            if (!rightBorderNearby && cells[currentCellJ, currentCellI + 1].notEmpty)
                _cells.Add(cells[currentCellJ, currentCellI + 1]);

            //		//Testing 1 cell up, 1 cell down
            if (!rightBorderNearby && !topBorderNearby && cells[currentCellJ - 1, currentCellI + 1].notEmpty)
                _cells.Add(cells[currentCellJ - 1, currentCellI + 1]);

            //Testing 1 cell up
            if (!topBorderNearby && cells[currentCellJ - 1, currentCellI].notEmpty)
                _cells.Add(cells[currentCellJ - 1, currentCellI]);

            //		//Testing 1 cell left, 1 cell up
            if (!leftBorderNearby && !topBorderNearby && cells[currentCellJ - 1, currentCellI - 1].notEmpty)
                _cells.Add(cells[currentCellJ - 1, currentCellI - 1]);

            //Testing 1 cell left
            if (!leftBorderNearby && cells[currentCellJ, currentCellI - 1].notEmpty)
                _cells.Add(cells[currentCellJ, currentCellI - 1]);

            //		//Testing 1 cell down, 1 cell left
            if (!topBorderNearby && !leftBorderNearby && field.fieldCells.rowsCount > currentCellJ + 1 &&
                cells[currentCellJ + 1, currentCellI - 1].notEmpty)
                _cells.Add(cells[currentCellJ + 1, currentCellI - 1]);

            if (cells[currentCellJ, currentCellI].notEmpty) //cell in which ball is (it could be skipped before)
                _cells.Add(cells[currentCellJ, currentCellI]);
        }
    }
}