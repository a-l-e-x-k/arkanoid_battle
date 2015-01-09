/**
 * Author: Alexey
 * Date: 8/7/12
 * Time: 11:21 PM
 */
package view.popups.myspells
{
    import events.RequestEvent;
    import events.ServerMessageEvent;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    import model.PopupsManager;
    import model.ServerTalker;
    import model.spells.ItemsRearranger;
    import model.userData.Spells;
    import model.userData.UserData;

    import utils.EventHub;
    import utils.Popup;

    import view.popups.myspells.preview.SpellsPreview;

    public class SpellsPopup extends Popup
    {
        private const COLUMNS_COUNT:int = 5;
        private const ROWS_COUNT:int = 2;
        private const MARGIN_X:int = 32;
        private const MARGIN_Y:int = 120;
        private const ITEM_SIZE:int = 62;
        private const SPACE_X:int = 35;
        private const SPACE_Y:int = 50;
        private const SLOTS_TOTAL:int = 5;

        private var _items:Dictionary = new Dictionary();
        private var _panelPlaces:Array = [];
        private var _baseSpellPlaces:Dictionary = new Dictionary();

        private var _preview:SpellsPreview = new SpellsPreview();
        private var _selectedSpell:SpellItem;
        private var _selectedSpellPlace:SpellPlace;

        private var _placesLayer:Sprite = new Sprite();
        private var _itemsLayer:Sprite = new Sprite();

        public function SpellsPopup()
        {
            super(new spellspanelbg());

            addEventListener(Event.ADDED_TO_STAGE, onAdded);

            EventHub.addEventListener(ServerMessageEvent.SPELL_ACTIVATION_ALLOWED, onActivationAllowed);
            EventHub.addEventListener(RequestEvent.SPELL_ACTIVATED_BY_CLIENT, onClientActivatedSpell);
            EventHub.addEventListener(RequestEvent.SPELL_EXPIRED, onSpellExpired);
        }

        private function onSpellExpired(event:RequestEvent):void
        {
            var spellItem:SpellItem = (_items[event.stuff.spellName] as SpellItem);
            if (spellItem.spellPlace.isBase && !_selectedSpell) //shows "Activate" near base place if we are not draggin item and it is attached to base place
            {
                trace("SpellsPopup: onSpellExpired (65): ");
                spellItem.showActivateBtn();
            }
            else //shows "Expired & Activate" within item.
            {
                spellItem.showExpired();
            }

            _baseSpellPlaces[spellItem.spellName].tryRemoveTimeLeft();
        }

        private function onClientActivatedSpell(event:RequestEvent):void
        {
            var spellName:String = event.stuff.spellName;
            (_items[spellName] as SpellItem).removeActivateButton();
            _baseSpellPlaces[spellName].showTimeLeft();
            makeItemDraggable(_items[spellName]);
        }

        private function onAdded(event:Event):void
        {
            _preview.showPreview(Spells.SPLIT_IN_TWO); //show first preview
            addChild(_preview);

            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);

            _itemsLayer.mouseEnabled = false;
            _placesLayer.mouseEnabled = false;
            addChild(_placesLayer);
            addChild(_itemsLayer);

            var panelPlace:SpellPlace;
            for (var i:int = 1; i < 6; i++)
            {
                panelPlace = createSpellPlace(72 + (i - 1) * (ITEM_SIZE + 15), 384, i);
                _panelPlaces[i] = panelPlace;
            }

            createSpellItems();

            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.CLICK, tryShowActivationPopup); //thats a crazy hack. Allows disabling mouse of items and still catching click on item
        }

        private static function tryShowActivationPopup(event:MouseEvent):void
        {
            if (event.target is spellitem || event.target is unlbtn || event.target is SpellItem)
            {
                var na:String;
                if (event.target is spellitem || (event.target is unlbtn))
                {
                    na = (event.target.parent as SpellItem).spellName;
                }
                else
                {
                    na = (event.target as SpellItem).spellName;
                }

                if (UserData.spellsConfiguration.spellIsExpired(na))
                {
                    if (UserData.isGuest)
                    {
                        PopupsManager.showFeatureUnavailableForGuest();
                    }
                    else if (na == Spells.ROCKET)
                    {
                        PopupsManager.showComingSoonPopup();
                    }
                    else
                    {
                        PopupsManager.showActivateSpellPopop(na);
                    }
                }
            }
        }

        private function createSpellItems():void
        {
            var allSpells:Array = Spells.getAll();
            var currentRow:int = 0;
            var currentColumn:int = 0;
            for each (var spellName:String in allSpells)
            {
                createSpellItem(currentRow, currentColumn, spellName);
                currentColumn++;
                if (currentColumn == COLUMNS_COUNT)
                {
                    currentColumn = 0;
                    currentRow++;

                    if (currentRow == ROWS_COUNT)
                    {
                        trace("Fill next page!");
                    }
                }
            }
        }

        private function createSpellItem(currentRow:int, currentColumn:int, spellName:String):void
        {
            var playerHasSpell:Boolean = UserData.spellsConfiguration.spellResearched(spellName);

            var item:SpellItem = new SpellItem(spellName, playerHasSpell);
            item.x = MARGIN_X + currentColumn * (ITEM_SIZE + SPACE_X);
            item.y = MARGIN_Y + currentRow * (ITEM_SIZE + SPACE_Y);
            item.addEventListener(MouseEvent.ROLL_OVER, showPreview);

            var sp:SpellPlace = createSpellPlace(item.x, item.y);
            sp.setBase(spellName);
            _baseSpellPlaces[spellName] = sp; //associate spellName with its "base" place
            item.attachToSkillPlace(sp);
            _itemsLayer.addChild(item);

            if (playerHasSpell) //it can be dragged to bouncer
            {
                var itemSlotNumber:int = UserData.spellsConfiguration.getSpellSlotNumber(spellName);
                if (itemSlotNumber != -1) //skill attached to bouncer
                {
                    item.attachToSkillPlace(_panelPlaces[itemSlotNumber]);
                }

                makeItemDraggable(item);

                if (UserData.spellsConfiguration.spellIsExpired(spellName))
                {
                    if (itemSlotNumber != -1) //spell at bouncer
                    {
                        item.showExpired();
                    }
                    else //spell at base place
                    {
                        item.showActivateBtn();
                    }
                }
                else
                {
                    sp.showTimeLeft();
                }
            }
            else
            {
                item.showActivateBtn();
            }

            item.hardSetCoordinates(); //anti-tween first time

            _items[spellName] = item;
        }

        private function showPreview(event:MouseEvent):void
        {
            if ((event.currentTarget as SpellItem).mouseEnabled) //nuts, yeah. It was cathing "Over" events nevertheless
            {
                _preview.showPreview((event.currentTarget as SpellItem).spellName);
            }
        }

        private function makeItemDraggable(item:SpellItem):void
        {
            item.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            item.mouseChildren = false;
            item.addEventListener(RequestEvent.SPELL_SLOT_CHANGED, onSpellSlotChanged);
        }

        private static function onActivationAllowed(event:ServerMessageEvent):void
        {   //do nothing really. It is assumed by default that everything is ok. Error is thrown if problem occured
            trace("SpellsPopup: onActivationAllowed (167): ");
        }

        private static function onSpellSlotChanged(event:RequestEvent):void
        {
            ServerTalker.changeSpellSlot(event.currentTarget.spellName, event.stuff.slotID); //server will modify player object
            UserData.spellsConfiguration.setPowerupSlot(event.currentTarget.spellName, event.stuff.slotID);
        }

        private function createSpellPlace(xx:Number, yy:Number, i:int = -1):SpellPlace
        {
            var spellPlace:SpellPlace = new SpellPlace(i);
            spellPlace.x = xx;
            spellPlace.y = yy;
            spellPlace.addEventListener(MouseEvent.MOUSE_OVER, selectSpellPlace);
            spellPlace.addEventListener(MouseEvent.MOUSE_OUT, deselectSpellPlace);
            _placesLayer.addChild(spellPlace);
            return spellPlace;
        }

        private function deselectSpellPlace(event:MouseEvent):void
        {
            _selectedSpellPlace = null;
        }

        private function selectSpellPlace(event:MouseEvent):void
        {
            _selectedSpellPlace = event.currentTarget as SpellPlace;

            var rightPlace:Boolean = _selectedSpell && _selectedSpellPlace.id != -1;
            var spellAttached:Boolean = spellPlaceIsAttachedAlready(_selectedSpellPlace);

            if (rightPlace && _selectedSpellPlace != _selectedSpell.spellPlace && spellAttached)
            {
                var busySlotsCount:int = UserData.spellsConfiguration.busySlotsCount;
                if (busySlotsCount < SLOTS_TOTAL || !_selectedSpell.spellPlace.isBase)
                {
                    //try move items if there are less than max possible amount of items OR there is max amount but movement occurs within bouncer
                    ItemsRearranger.tryRearrangeItems(_selectedSpellPlace.id, _items, _selectedSpell, _panelPlaces);
                    _selectedSpell.attachToSkillPlace(_selectedSpellPlace, true); //just link (without visual changes)
                }
                else //remove item from current slot and place the one which user holds
                {
                    for each (var spellItem:SpellItem in _items)
                    {
                        if (spellItem.spellPlace == _selectedSpellPlace) //find item which is attached to place at which we wanna place an item
                        {
                            spellItem.attachToSkillPlace(_baseSpellPlaces[spellItem.spellName]);
                            break;
                        }
                    }
                }
            }
        }

        /**
         * Returns true if this place is attached to some item already
         * @param spellPlace
         * @return
         */
        private function spellPlaceIsAttachedAlready(spellPlace:SpellPlace):Boolean
        {
            for each (var spellItem:SpellItem in _items)
            {
                if (spellItem.spellPlace == spellPlace)
                {
                    return true;
                }
            }
            return false;
        }

        private function onMouseMove(event:MouseEvent):void
        {
            if (_selectedSpell)
            {
                _selectedSpell.x = stage.mouseX - _mc.x - ITEM_SIZE / 2;
                _selectedSpell.y = stage.mouseY - _mc.y - ITEM_SIZE / 2;

                //this is a sweet hack, we dont disable mouse on MOUSE_DOWN because we need CLICK event to go through
                for each (var spell:SpellItem in _items) //thus spell places will receive OVER events
                {
                    spell.mouseEnabled = false;
                }
            }
        }

        private function onMouseUp(event:MouseEvent):void
        {
            if (_selectedSpell)
            {
                if (_selectedSpellPlace)
                {
                    if (_selectedSpellPlace.isBase) //when placing back, on base place
                    {
                        if (_selectedSpellPlace != _baseSpellPlaces[_selectedSpell.spellName]) //if placing at skill place of other skill
                        {
                            _selectedSpellPlace = _baseSpellPlaces[_selectedSpell.spellName];
                        }
                    } //force-set

                    _selectedSpell.attachToSkillPlace(_selectedSpellPlace);
                }

                _selectedSpell.resetCoordinates();
                enableItemsMouse();
            }

            _selectedSpell = null;
            _selectedSpellPlace = null;
        }    //we need to catch CLICK event while catching MOUSEDOWN event as well (for expired items)

        private function onMouseDown(event:MouseEvent):void
        {
            if (UserData.isGuest)
            {
                PopupsManager.showFeatureUnavailableForGuest();
            }
            else
            {
                _selectedSpell = event.currentTarget as SpellItem;
                if (_selectedSpell.spellName == Spells.ROCKET)
                {
                    PopupsManager.showComingSoonPopup();
                }
                else
                {
                    _itemsLayer.setChildIndex(_selectedSpell, _itemsLayer.numChildren - 1);
                }
            }
        }

        private function enableItemsMouse():void
        {
            for each (var spell:SpellItem in _items)
            {
                spell.mouseEnabled = true;
            }
        }

        override protected function clearListeners():void
        {
            for each (var sp:SpellPlace in _baseSpellPlaces)
            {
                sp.tryRemoveTimeLeft(); //it'll remove timer listeners
            }

            EventHub.removeEventListener(ServerMessageEvent.SPELL_ACTIVATION_ALLOWED, onActivationAllowed);
            EventHub.removeEventListener(RequestEvent.SPELL_ACTIVATED_BY_CLIENT, onClientActivatedSpell);
            EventHub.removeEventListener(RequestEvent.SPELL_EXPIRED, onSpellExpired);
        }
    }
}