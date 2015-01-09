/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/29/12
 * Time: 3:56 PM
 * To change this template use File | Settings | File Templates.
 */
package model.userData
{
    import model.shop.ShopItemsInfo;

    public class PayVaultItems
    {
        private var _items:Array = [];

        public function PayVaultItems(items:Array)
        {
            for each (var item:Object in items)
            {
                _items.push(item.itemKey);
            }
        }

        public function getRankProtectionCount():int
        {
            var c:int = 0;
            for each (var itemKey:String in _items)
            {
                if (itemKey == ShopItemsInfo.ARMOR_ITEM)
                {
                    c++;
                }
            }
            return c;
        }

        public function hasItem(itemID:String):Boolean
        {
            for each (var itemKey:String in _items)
            {
                if (itemID == itemKey)
                {
                    return true;
                }
            }
            return false;
        }

        public function addItem(itemKey:String):void
        {
            _items.push(itemKey);
        }
    }
}
