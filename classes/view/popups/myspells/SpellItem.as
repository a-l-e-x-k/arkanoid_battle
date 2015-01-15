/**
 * Author: Alexey
 * Date: 8/7/12
 * Time: 11:21 PM
 */
package view.popups.myspells
{
    import caurina.transitions.Tweener;

    import events.RequestEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import model.userData.Spells;

    import utils.MovieClipContainer;

    import view.tooltips.SpellTooltip;

    /**
     * Item in shop
     */
    public class SpellItem extends MovieClipContainer
    {
        private var _spellPlace:SpellPlace;
        private var _spellName:String;
        private var _activateButton:MovieClip;

        public function SpellItem(spellName:String, playerHasIt:Boolean)
        {
            _spellName = spellName;

            buttonMode = true;
            mouseChildren = false;

            if (playerHasIt)
            {
                trace("Player has spell: " + spellName);
            }

            super(new spellitem());
            _mc.mc.gotoAndStop(getFrameNumberForSpell(spellName));
            _mc.exp.visible = false;
            _mc.mouseChildren = false;

            addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
            addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
        }

        private static function onMouseOut(event:MouseEvent):void
        {
            SpellTooltip.getInstance().hide();
        }

        private function onMouseOver(event:MouseEvent):void
        {
            SpellTooltip.getInstance().setSpell(_spellName);
            SpellTooltip.getInstance().wannaShow();
        }

        /**
         * If silently - no animation will be done (useful when just dragging around)
         * @param spellPlace
         * @param silently
         */
        public function attachToSkillPlace(spellPlace:SpellPlace, silently:Boolean = false):void
        {
            if (_spellPlace != spellPlace)
            {
                _spellPlace = spellPlace;
                if (!silently)
                {
                    resetCoordinates();
                }
                dispatchEvent(new RequestEvent(RequestEvent.SPELL_SLOT_CHANGED, {slotID: _spellPlace.id}));
            }
        }

        public function resetCoordinates():void
        {
            Tweener.addTween(this, {x: _spellPlace.x, time: 0.15, transition: "easeOutSine"});
            Tweener.addTween(this, {y: _spellPlace.y, time: 0.15, transition: "easeOutSine"});
        }

        public function hardSetCoordinates():void
        {
            x = _spellPlace.x;
            y = _spellPlace.y;
        }

        public function get spellName():String
        {
            return _spellName;
        }

        public function showActivateBtn():void
        {
            mouseChildren = true; //for button to work
            _activateButton = new unlbtn();
            _activateButton.mouseChildren = false;
            _activateButton.x = -3;
            _activateButton.y = 70;
            _activateButton.width = 70;
            _activateButton.height = 20;
            addChild(_activateButton);
        }

        public function removeActivateButton():void
        {
            if (_activateButton)
            {
                removeChild(_activateButton);
                _activateButton = null;
            }

            _mc.exp.visible = false;
            mouseChildren = false;
        }

        public function get spellPlace():SpellPlace
        {
            return _spellPlace;
        }

        public static function getFrameNumberForSpell(spellName:String):int
        {
            var frameNumber:int = -1;
            switch (spellName)
            {
                case Spells.LIGHTNING_ONE:
                    frameNumber = 1;
                    break;
                case Spells.LIGHTNING_TWO:
                    frameNumber = 2;
                    break;
                case Spells.LIGHTNING_THREE:
                    frameNumber = 3;
                    break;
                case Spells.SPLIT_IN_TWO:
                    frameNumber = 4;
                    break;
                case Spells.SPLIT_IN_THREE:
                    frameNumber = 5;
                    break;
                case Spells.CHARM_BALLS:
                    frameNumber = 6;
                    break;
                case Spells.FREEZE:
                    frameNumber = 7;
                    break;
                case Spells.BOUNCY_SHIELD:
                    frameNumber = 8;
                    break;
                case Spells.LASER_SHOTS:
                    frameNumber = 9;
                    break;
                case Spells.ROCKET:
                    frameNumber = 10;
                    break;
            }
            return frameNumber;
        }

        public function showExpired():void
        {
            _mc.exp.visible = true;
        }
    }
}
