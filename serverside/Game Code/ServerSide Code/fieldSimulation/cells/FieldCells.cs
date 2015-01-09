using System;

namespace ServerSide
{
    public class FieldCells
    {
        private const int FIELD_WIDTH_PX = 351; //in pixels
        private const int FIELD_HEIGHT_PX = 390; //in pixels
        private const int BRICK_WIDTH = 39;
        private const int BRICK_HEIGHT = 15;

        public Cell[,] cells;
        public int columnsCount = FIELD_WIDTH_PX/BRICK_WIDTH;
        public MapsProgram mapsProgram;
        public int presetID = 0;
        public BasicRoom roomLink;
        public int rowsCount = FIELD_HEIGHT_PX/BRICK_HEIGHT;

        public FieldCells(string mapsProgramData, BasicRoom rroomLink)
        {
            roomLink = rroomLink;
            mapsProgram = new MapsProgram(mapsProgramData);
            createGrid(mapsProgram.getNextMapID());
        }

        public event EventHandler cellCleared;
        public event EventHandler fieldCleared;

        public void hitLightning(int numberOfLightinigs, string bricksData)
        {
            if (bricksData == "") //happens when p-up is used when preset was not yet created
                return;

            string[] hitBricks = bricksData.Split(new[] {';'});
            if (numberOfLightinigs < hitBricks.Length)
                //it may be less (e.g. powerup is upgraded and allows hitting 2 bricks, though only 1 brick left) or equal (normal situation)
                throw new Exception("Async while using lightning powerup! Number of lighting in request: " +
                                    numberOfLightinigs + " bricksHit: " + hitBricks.Length + " bricksData: " +
                                    bricksData); //player somehow hit more ligthnings that there are in request	

            foreach (string brickIJ in hitBricks)
            {
                string[] brickIJArr = brickIJ.Split(new[] {'!'});
                int brickI = Convert.ToInt16(brickIJArr[0]);
                int brickJ = Convert.ToInt16(brickIJArr[1]);
                cells[brickI, brickJ].clearBrick();

                Console.WriteLine("lightning hit brick at: " + brickI + " : " + brickJ);
            }
        }

        public void newMap()
        {
            createGrid(mapsProgram.getNextMapID());
        }

        private void createGrid(int mapID)
        {
            presetID = mapID;
            //creating empty field

            cells = new Cell[rowsCount, columnsCount];
            for (int i = 0; i < rowsCount; i++)
            {
                for (int j = 0; j < columnsCount; j++)
                {
                    var cell = new Cell(i, j, BRICK_WIDTH, BRICK_HEIGHT);
                    cell.cleared += onCellCleared;
                    cells[i, j] = cell;
                }
            }

            //fill it with cells
            string[] presetData = roomLink.maps.getMapCode(mapID).Split(new[] {'|'});
            int cellI = 0;
            int cellJ = 0;
            int brickID = 0;
            for (int i = 0; i < presetData.Length; i++)
            {
                string[] cellData = presetData[i].Split(new[] {','});
                cellJ = Convert.ToInt16(cellData[0]);
                cellI = Convert.ToInt16(cellData[1]);
                brickID = Convert.ToInt16(cellData[2]);
                cells[cellI, cellJ].attachBrick(brickID);
            }
        }

        private void onCellCleared(object sender, EventArgs args)
        {
            EventHandler handler = cellCleared;
            handler(this, args);

            foreach (Cell cell in cells)
            {
                if (cell.notEmpty)
                    return;
            }

            EventHandler handler2 = fieldCleared;
            handler2(this, EventArgs.Empty);
                //there must be an event so that we can turn on stealth mode for balls and switch to new preset at that time
        }
    }
}