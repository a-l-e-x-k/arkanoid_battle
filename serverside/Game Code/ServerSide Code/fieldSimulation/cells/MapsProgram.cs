using System;

namespace ServerSide
{
    /**
     * Simply contains list of map ids. 
     * Game pulls actual data from static Maps class
     */

    public class MapsProgram
    {
        private readonly int[] mapIDs;
        private int currentMapIndex;

        public MapsProgram(string programCode)
        {
            string[] mapsStrings = programCode.Split(',');
            mapIDs = new int[mapsStrings.Length];
            for (int i = 0; i < mapsStrings.Length; i++)
            {
                mapIDs[i] = Convert.ToInt16(mapsStrings[i]);
            }
        }

        public int getNextMapID()
        {
            int mapID = mapIDs[currentMapIndex];
            currentMapIndex++;
            if (currentMapIndex == mapIDs.Length)
                currentMapIndex = 0;
            return mapID;
        }
    }
}