/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/24/12
 * Time: 7:25 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.events.MouseEvent;

    import model.PopupsManager;
    import model.shop.ShopItemsInfo;

    import utils.Popup;

    public class NotEnoughEnergyPopup extends Popup
    {
        public function NotEnoughEnergyPopup()
        {
            super(new notenoughenergyout());
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.close_btn.buttonMode = true;
            _mc.add_btn.addEventListener(MouseEvent.CLICK, gotoShop);
        }

        private function gotoShop(event:MouseEvent):void
        {
            PopupsManager.showShop(ShopItemsInfo.TAB_ENERGY);
            die();
        }
    }
}
