using System;
using System.Collections;
using System.Collections.Generic;

namespace ServerSide
{
    public class SpellChecker
    {
        private readonly ArrayList activationBuffer = new ArrayList();
            //spells are put here when activation transaction is initiated (so its usage aint blocked), and removed when transaction is finished

        private readonly Dictionary<string, DateTime> lastUses = new Dictionary<string, DateTime>();

        public bool playerIsElegible(int requestID, int slotID, Player player)
        {
            if (player.getRequestIDForSlotID(slotID) == -1) //player has no spell
            {
                Console.WriteLine("[SpellChecker] player has no spell");
                return false;
            }

            string spellName = GameRequest.getSpellNameByRequest(requestID);
            double expires =
                player.PlayerObject.GetObject(DBProperties.SPELL_OBJECT)
                    .GetObject(spellName)
                    .GetDouble(DBProperties.SPELL_EXPIRES);
            if (Utils.unixSecs() > expires + 20) //spell expired. 20 seconds buffer for possible time async 
            {
                if (!activationBuffer.Contains(spellName)) //if spell i snot being activated at the moment
                {
                    Console.WriteLine("[SpellChecker] spell expired");
                    return false;
                }
                Console.WriteLine(
                    "[SpellChecker] spell expired but activation transaction is being processed, allowing usage");
            }

            if (!lastUses.ContainsKey(player.realID + requestID))
                lastUses[player.realID + requestID] = new DateTime(1970, 1, 1); //just fill in, so that key exists 
            TimeSpan sp = DateTime.UtcNow - lastUses[player.realID + requestID];
            if (GameConfig.getCooldownTimeByRequest(requestID) >= sp.TotalMilliseconds + 1500)
                //add some buffer, allowing for whatever delays/differences might be. Client checks properly, so it matters only in case of cheating
            {
                Console.WriteLine("[SpellChecker] spell did not cool down");
                return false;
            }

            //we are good, may use
            lastUses[player.realID + requestID] = DateTime.UtcNow; //update last usage time				
            return true;
        }

        public void putSpellInActivationBuffer(string spellName)
        {
            activationBuffer.Add(spellName);
        }

        public void removeSpellFromActivationBuffer(string spellName)
        {
            if (activationBuffer.Contains(spellName))
            {
                activationBuffer.Remove(spellName);
            }
        }
    }
}