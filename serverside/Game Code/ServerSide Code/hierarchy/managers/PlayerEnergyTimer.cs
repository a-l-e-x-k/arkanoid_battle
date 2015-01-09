using System;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    /**
     * Responsible for refilling energy only
     * Aint consuming anything
     * */

    public class PlayerEnergyTimer
    {
        private Player _roomCreator;
        private BasicRoom _roomLink;
        private Timer _scheduledRefillTimer;

        public void onRoomCreated(Player roomCreator, BasicRoom roomLink)
        {
            _roomCreator = roomCreator;
            _roomLink = roomLink;

            Console.WriteLine("onRoomCreated");

            if (roomCreator.PlayerObject.GetInt(DBProperties.ENERGY) < GameConfig.ENERGY_MAX)
            {
                Console.WriteLine("onRoomCreated player needs energy");
                tryRefillEnergy();
            }
        }

        /**
        * Called when energy was used first time after was full (starting refill cycle)
        * It must be called before consuming energy
         * 
         * When player enered the game energy will likely will be refilled and last update time will be set.
         * After that he can hang out at lobby, and when he decides to play we don't want start refilling
         * energy from the time when he eneterd the room. Instead, we should use time when full energy was used.
        * */

        public void resetLastUpdateTime()
        {
            if (_roomCreator.PlayerObject.GetInt(DBProperties.ENERGY) >= GameConfig.ENERGY_MAX)
            {
                _roomCreator.PlayerObject.Set(DBProperties.ENERGY_LAST_UPDATE, Utils.unixSecs());
                _roomCreator.PlayerObject.Save();
            }
        }

        public double getTimeOfNextUpdate()
        {
            double result = -1;

            if (_roomCreator.PlayerObject.GetInt(DBProperties.ENERGY) < GameConfig.ENERGY_MAX)
                //if not then -1 will be sent (which means we are full)
            {
                double lastUpd = _roomCreator.PlayerObject.GetDouble(DBProperties.ENERGY_LAST_UPDATE);
                result = lastUpd + GameConfig.ENERGY_REFILL_INTERVAL;
            }

            return result;
        }

        public void tryRefillEnergy()
        {
            Console.WriteLine("tryRefillEnergy");
            if (_roomCreator.PlayerObject.GetInt(DBProperties.ENERGY) < GameConfig.ENERGY_MAX)
            {
                Console.WriteLine("need energy!");
                double now = Utils.unixSecs();
                double lastTime = _roomCreator.PlayerObject.GetDouble(DBProperties.ENERGY_LAST_UPDATE);
                double difference = now - lastTime; //difference in seconds
                int newEnergy = _roomCreator.PlayerObject.GetInt(DBProperties.ENERGY);
                Console.WriteLine("Need energy: diff: " + difference + " now: " + now);
                if (difference >= GameConfig.ENERGY_REFILL_INTERVAL)
                {
                    Console.WriteLine("adding erngy");
                    var refillCycles = (int) Math.Floor(difference/GameConfig.ENERGY_REFILL_INTERVAL);
                    newEnergy += refillCycles; //amount of energy added is equal to amount of cycles passed
                    newEnergy = newEnergy > GameConfig.ENERGY_MAX ? GameConfig.ENERGY_MAX : newEnergy;
                    _roomCreator.PlayerObject.Set(DBProperties.ENERGY, newEnergy);
                    _roomCreator.PlayerObject.Set(DBProperties.ENERGY_LAST_UPDATE, now);
                    _roomCreator.PlayerObject.Save();
                    _roomCreator.Send(MessageTypes.ENERGY_UPDATE, newEnergy, now + GameConfig.ENERGY_REFILL_INTERVAL,
                        now);
                }

                if (newEnergy < GameConfig.ENERGY_MAX) //if more energy needed
                {
                    _scheduledRefillTimer = _roomLink.ScheduleCallback(tryRefillEnergy, (int) difference*1000 + 2000);
                        //in "time left to refill" + 2 secs for buffer try refill again
                }
            }
        }
    }
}