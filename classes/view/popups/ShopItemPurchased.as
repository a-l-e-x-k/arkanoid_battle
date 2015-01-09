/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/9/13
 * Time: 11:08 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    import utils.Popup;

    import view.popups.shop.activeTab.ShopItem;

    public class ShopItemPurchased extends Popup
    {
        private const ITEM_AREA_SIZE:Number = 110;

        public function ShopItemPurchased(itemKey:String, itemName:String)
        {
            super(new shopitempurch(), true);

            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.itemName_txt.text = itemName;

            var itemPic:DisplayObject = ShopItem.getItemPic(itemKey);
            itemPic.x = 192 + (ITEM_AREA_SIZE - itemPic.width) / 2;
            itemPic.y = 179 + (ITEM_AREA_SIZE - itemPic.height) / 2 + 10;
            _mc.addChild(itemPic);
        }
    }
}
