using System.Collections.Generic;

namespace ServerSide
{
    public class SpellUseCounter
    {
        private readonly Dictionary<int, int> _allowedCounter = new Dictionary<int, int>(); //request id - count
        private readonly Dictionary<int, int> _usedCounter = new Dictionary<int, int>(); //request id - count

        public void addAllowed(int spellID)
        {
            if (_allowedCounter.ContainsKey(spellID))
            {
                _allowedCounter[spellID]++;
            }
            else
            {
                _allowedCounter[spellID] = 1;
            }
        }

        public void addUsed(int spellID)
        {
            if (_usedCounter.ContainsKey(spellID))
            {
                _usedCounter[spellID]++;
            }
            else
            {
                _usedCounter[spellID] = 1;
            }
        }

        public static bool safeRequest(int requestID)
        {
            return (requestID != GameRequest.LIGHTNING_ONE && requestID != GameRequest.LIGHTNING_TWO &&
                    requestID != GameRequest.LIGHTNING_THREE
                //checking only self-targeted spells (which are launched insta on client side)
                    && requestID != GameRequest.SPLIT_BALL_IN_TWO && requestID != GameRequest.SPLIT_BALL_IN_THREE &&
                    requestID != GameRequest.BOUNCY_SHIELD && requestID != GameRequest.LASER_SHOTS);
        }

        public bool beforeUsage(int requestID)
        {
            bool usageAllowed = false;
            bool isSafeRequest = safeRequest(requestID);

            if (isSafeRequest)
            {
                usageAllowed = true;
            }
            else if (_allowedCounter.ContainsKey(requestID)) //was allowed
            {
                if (!_usedCounter.ContainsKey(requestID)) //allowed but was never used
                    usageAllowed = true;
                else if (_allowedCounter[requestID] > _usedCounter[requestID])
                    //allowed several times and was used before
                    usageAllowed = true;
            }

            if (GameRequest.getSpellNameByRequest(requestID) != "" && requestID != GameRequest.PRE_CHARM_BALLS &&
                requestID != GameRequest.PRE_FREEZE && requestID != GameRequest.PRE_ROCKET)
            {
                addUsed(requestID); //write down real spell usages, used for spells stats after game
            }

            return usageAllowed;
        }

        public Dictionary<int, int> getUsedSpellsData()
        {
            return _usedCounter;
        }
    }
}