using System;
using System.Collections.Generic;

namespace ServerSide
{
    public class OutstandingRequests
    {
        private readonly Dictionary<int, GameRequestData> _requests = new Dictionary<int, GameRequestData>();

        public Dictionary<int, GameRequestData> requests
        {
            get { return _requests; }
        }

        public void add(int nextTickNumber, GameRequestData data)
        {
            bool inserted = false;
            int i = 0;

            while (!inserted)
            {
                if (_requests.ContainsKey(nextTickNumber + i))
                {
                    i++;
                }
                else //found empty slot (tick, at which there is no request planned at the moment)
                {
                    _requests[nextTickNumber + i] = data;
                    inserted = true;
                }
            }
        }

        public void addFromString(string dataString)
        {
            string[] inStrings = dataString.Split(new[] {'$'}); //sometines adding several items at once
            string[] powerupData;

            foreach (string str in inStrings)
            {
                powerupData = str.Split(new[] {':'});
                _requests[Convert.ToInt16(powerupData[1])] = new GameRequestData(Convert.ToInt16(powerupData[0]),
                    powerupData[2]);
            }
        }
    }
}