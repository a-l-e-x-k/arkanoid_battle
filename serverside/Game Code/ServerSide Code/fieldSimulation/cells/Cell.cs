using System;

namespace ServerSide
{
    public class Cell
    {
        public int brickType = -1;
        public int i;
        public int j;
        public int x;
        public int y;

        public Cell(int i, int j, int brickWidth, int brickHeight)
        {
            this.i = i;
            this.j = j;

            x = j*brickWidth;
            y = i*brickHeight;
        }

        public bool notEmpty
        {
            get { return brickType != Maps.EMPTY_CELL; }
        }

        public event EventHandler cleared;

        public void attachBrick(int brickID)
        {
            brickType = brickID;
        }

        public void clearBrick(int currentTick = -1)
        {
            if (currentTick != -1)
            {
                Console.WriteLine("[Cell shot by laser] tick: " + currentTick);
            }

            if (brickType != -1) //it is -1 already when using delayed callback (e.g. Lightning)
            {
                Console.WriteLine("Cleared brick at: " + i + " : " + j + " with type: " + brickType);
                int typeBefore = brickType;
                brickType = -1;
                EventHandler handler = cleared;
                handler(this, new CellClearedArgs(typeBefore));
            }
            else
                Console.WriteLine("[Warning!] Cleared already empty brick at: " + i + " : " + j + " with type: " +
                                  brickType);
            //throw new Exception("Trying to clear already cleared brick!");
        }
    }
}