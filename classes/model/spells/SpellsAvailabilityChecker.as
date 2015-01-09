/**
 * Author: Alexey
 * Date: 11/17/12
 * Time: 4:39 PM
 */
package model.spells
{
    import events.RequestEvent;

    import flash.utils.Dictionary;

    import model.ServerTalker;
    import model.constants.GameConfig;
    import model.requests.GameRequest;
    import model.userData.UserData;

    import utils.EventHub;

    /**
	 * Duplicates serverside check for:
	 * 1. reducing amount of obviously useless messages to server
	 * 2. showing immediate feedback (instant usage of powerup)
	 */
	public class SpellsAvailabilityChecker
	{
		private static var _lastUsageDictionary:Dictionary = new Dictionary();

		public static function tryUseSpell(spellName:String, msPassed:int, gameLength:int):void
		{
			if (canUse(spellName, msPassed, gameLength))
			{
				onUsageAllowed(UserData.spellsConfiguration.getSpellSlotNumber(spellName), spellName);
			}
		}

		/**
		 * Here existence of spell at slot is checked as well.
		 * User can try using empty slot
		 * @param slotID
         * @param msPassed
         * @param gameLength
		 */
		public static function tryUseSpellBySlot(slotID:int, msPassed:int, gameLength:int):void
		{
			var spellName:String = UserData.spellsConfiguration.getSpellNameAtSlot(slotID);
			if (spellName != "" && canUse(spellName, msPassed, gameLength))
				onUsageAllowed(slotID, spellName);
		}

		/**
		 * Simple cooldown completion check
		 */
		private static function canUse(spellName:String, msPassed:int, gameLength:int):Boolean
		{
			if ((gameLength * 1000 - msPassed) < 2500) //can't use spells near game finish
				return false;

            if (UserData.spellsConfiguration.spellIsExpired(spellName))
                return false;

			if (_lastUsageDictionary[spellName]) //if used before
			{
				var spellRequestID:int = GameRequest.getRequestBySpellName(spellName);
				var cooldownTime:int = GameConfig.getCooldownTimeByRequest(spellRequestID);
				if ((new Date().time - _lastUsageDictionary[spellName]) < cooldownTime) //not cooled down yet
                {
                    return false;
                }
				else
					_lastUsageDictionary[spellName] = new Date().time;
			}
			else
			{
				_lastUsageDictionary[spellName] = new Date().time;
			}

			return true;
		}

		private static function onUsageAllowed(slotID:int, spellName:String):void
		{
			var requestID:int = GameRequest.getRequestBySpellName(spellName);

			if (requestID == GameRequest.CHARM_BALLS) //CHARM_BALLS will be executed when server will send over opponent's executed request
				requestID = GameRequest.PRE_CHARM_BALLS;
			else if (requestID == GameRequest.FREEZE) //FREEZE will be executed when server will send over opponent's executed request
				requestID = GameRequest.PRE_FREEZE;
            else if (requestID == GameRequest.ROCKET) //ROCKET will be executed when server will send over opponent's executed request
                requestID = GameRequest.PRE_ROCKET;

			EventHub.dispatch(new RequestEvent(RequestEvent.CLIENT_ALLOWED_SPELL_USAGE, {requestID:requestID}));
			ServerTalker.wannaUse(slotID); //let server check now
		}
	}
}
