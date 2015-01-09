/**
 * Author: Alexey
 * Date: 8/18/12
 * Time: 1:47 AM
 */
package model.userData
{
    import events.RequestEvent;

    import flash.events.TimerEvent;
    import flash.utils.Dictionary;

    import model.constants.GameConfig;

    import model.timer.GlobalTimer;

    import utils.EventHub;
    import utils.Misc;

    public class SpellsConfiguration
    {
        private var _config:Dictionary;

        public function SpellsConfiguration(s:Dictionary):void
        {
            _config = s;
            GlobalTimer.addEventListener(TimerEvent.TIMER, checkForSpells);
        }

        private function checkForSpells(event:TimerEvent):void
        {
            for each (var svo:SpellVO in _config)
            {
                if (!svo.expirationDispatched && svo.expires < Misc.currentUNIXSecs)
                {
                    svo.expirationDispatched = true;
                    EventHub.dispatch(new RequestEvent(RequestEvent.SPELL_EXPIRED, {spellName:svo.name}));
                }
            }
        }

        public function spellResearched(spellName:String):Boolean
        {
            return _config.hasOwnProperty(spellName);
        }

        public function getSpellSlotNumber(spellName:String):int
        {
            if (_config.hasOwnProperty(spellName))
            {
                return _config[spellName].slotID;
            }
            return -1;
        }

        public function getSpellNameAtSlot(slotID:int):String
        {
            var name:String = "";
            for each (var spell:SpellVO in _config)
            {
                if (spell.slotID == slotID)
                {
                    name = spell.name;
                    break;
                }
            }
            return name;
        }

        /**
         * Returns data about how player organized his bouncer
         * @return
         */
        public function getPanelData():Object
        {
            var data:Object = {};
            for each (var spell:SpellVO in _config)
            {
                if (spell.slotID != -1) //if powerup is at bouncer
                {
                    data[spell.name] = spell.slotID; //write down slot number
                }
            }
            return data;
        }

        public function setPowerupSlot(powerupName:String, slotNumber:int):void
        {
            _config[powerupName].slotID = slotNumber;
            EventHub.dispatch(new RequestEvent(RequestEvent.SPELLS_PANEL_UPDATE));
        }

        public function get busySlotsCount():int
        {
            var c:int = 0;
            for each (var spell:SpellVO in _config)
            {
                if (spell.slotID != -1) //if powerup is at bouncer
                {
                    c++;
                }
            }
            return c;
        }

        public function activateSpell(spellName:String):void
        {//Misc.currentUNIXSecs + 15;//
            var exp:Number = Misc.currentUNIXSecs + GameConfig.SPELL_ACTIVATION_TIME * 60 * 60;
            var prevSlot:int = _config[spellName] ? (_config[spellName] as SpellVO).slotID : -1; //don't lose slot id
            _config[spellName] = new SpellVO(spellName, exp, prevSlot);
        }

        public function get config():Object
        {
            return _config;
        }

        public function getActivatedSpellLeftTime(spellName:String):Number
        {
            return _config[spellName].expires;
        }

        public function spellIsExpired(spellName:String):Boolean
        { //spell is not expired in the case when it exists and is not expired
            return !(_config[spellName] && (_config[spellName] as SpellVO).expires >= Misc.currentUNIXSecs);
        }
    }
}
