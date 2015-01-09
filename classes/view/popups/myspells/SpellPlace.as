/**
 * Author: Alexey
 * Date: 8/7/12
 * Time: 11:44 PM
 */
package view.popups.myspells
{
    import model.userData.UserData;

    import utils.MovieClipContainer;

    public class SpellPlace extends MovieClipContainer
    {
        private var _id:int = -1;
        public var isBase:Boolean = false;
        private var _spellName:String;
        private var _timeLeft:ActivatedSpellLeftTime;

        public function SpellPlace(id:int)
        {
            super(new spellplace());
            _id = id;
            mouseChildren = false;
        }

        public function get id():int
        {
            return _id;
        }

        public function setBase(spellName:String):void
        {
            _spellName = spellName;
            isBase = true;
            var itemShadow:SpellItem = new SpellItem(spellName, false);
            itemShadow.mc.alpha = 0.35;
            addChild(itemShadow);
        }

        public function showTimeLeft():void
        {
            if (!isBase)
            {
                throw new Error("Can't show left time for not a base place");
            }

            if (UserData.isGuest) //guess use only 1 account which has spells for 500 years
                return;

            _timeLeft = new ActivatedSpellLeftTime(_spellName);
            _timeLeft.x = 5;
            _timeLeft.y = _mc.height + 4;
            addChild(_timeLeft);
        }

        public function tryRemoveTimeLeft():void
        {
            if (_timeLeft)
            {
                _timeLeft.clean();
                removeChild(_timeLeft);
                _timeLeft = null;
            }
        }
    }
}
