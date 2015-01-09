/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/19/12
 * Time: 4:23 PM
 * To change this template use File | Settings | File Templates.
 */
package model.userData
{
    public class SpellVO
    {
        private var _name:String;
        private var _expires:Number;
        private var _slotID:int;
        private var _expirationDispatched:Boolean;
        
        public function SpellVO(name:String = "", expires:Number = 0, slotID:int = -1, expirationDispatched:Boolean = false)
        {
            _name = name;
            _expires = expires;
            _slotID = slotID;
            _expirationDispatched = expirationDispatched;
        }

        public function get name():String
        {
            return _name;
        }

        public function get expires():Number
        {
            return _expires;
        }

        public function set expires(value:Number):void
        {
            _expires = value;
        }

        public function get slotID():int
        {
            return _slotID;
        }

        public function set slotID(value:int):void
        {
            _slotID = value;
        }

        public function get expirationDispatched():Boolean
        {
            return _expirationDispatched;
        }

        public function set expirationDispatched(value:Boolean):void
        {
            _expirationDispatched = value;
        }
    }
}
