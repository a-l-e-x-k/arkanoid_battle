/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:02 PM
 */
package view.popups.shop
{
    import flash.events.MouseEvent;

    import model.shop.ShopItemsInfo;

    import utils.Popup;

    public class ShopPopup extends Popup
    {
        private static var instance:ShopPopup;
        private var _shopItems:ShopContent;

        public static function getInstance():ShopPopup
        {
            if (instance == null)
                instance = new ShopPopup(new SingletonEnforcer());
            return instance;
        }

        public function showTab(tab:String):void
        {
            if (ShopItemsInfo.getAllTabs().indexOf(tab) != -1)
            {
                _shopItems.showTab(tab);
            }
        }

        public function ShopPopup(singletonEnforcer:SingletonEnforcer)
        {
            super(new shopop());

            _shopItems = new ShopContent();
            _shopItems.x = (_mc.width - _shopItems.width) / 2;
            _shopItems.y = 110;
            _mc.addChild(_shopItems);

            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.close_btn.buttonMode = true;
        }
    }
}

class SingletonEnforcer
{
}