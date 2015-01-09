/**
 * Author: Alexey
 * Date: 8/19/12
 * Time: 6:31 PM
 */
package view.popups.unlockSpell
{
    import events.RequestEvent;

    import flash.events.MouseEvent;

    import model.constants.GameConfig;
    import model.shop.ShopItemsInfo;
    import model.userData.Spells;

    import utils.EventHub;
    import utils.Popup;

    public class ActivateSpellPopup extends Popup
    {
        private var _spellName:String = "";
        private var _price:int;

        public function ActivateSpellPopup(spellName:String)
        {
            _spellName = spellName;
            _price = ShopItemsInfo.getItemPrice(spellName);

            super(new unlspe(), true);
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.close_btn.buttonMode = true;
            _mc.act_btn.addEventListener(MouseEvent.CLICK, activate);
            _mc.title_txt.text = 'Activate "' + Spells.getFullSpellName(spellName) + '" for ' + GameConfig.SPELL_ACTIVATION_TIME + ' hours';
            _mc.price_txt.text = _price;
        }

        private function activate(event:MouseEvent):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.BUY_ITEM, {itemKey: _spellName, tab: "spells", itemPrice: _price}));
            die();
        }

        override protected function clearListeners():void
        {
            stage.focus = stage;
        }
    }
}

