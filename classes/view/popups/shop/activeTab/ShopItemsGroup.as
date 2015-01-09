/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 11:20 PM
 */
package view.popups.shop.activeTab
{
	import flash.display.Sprite;

	import model.shop.ShopItemVO;

	public class ShopItemsGroup extends Sprite
	{
		public static const ROWS:int = 2;
		public static const COLUMNS:int = 3;
		public static const ITEM_WIDTH:int = 139;
		public static const SPACE:int = 21;

		public function ShopItemsGroup(items:Vector.<ShopItemVO>)
		{
			var it:ShopItem;
			var count:int = 0;
			for (var i:int = 0; i < ROWS; i++)
			{
				for (var j:int = 0; j < COLUMNS; j++)
				{
					if (count == items.length) //all requested items are shown (there may be less than MAX possible amount)
						break;

					it = new ShopItem(items[count]);
					it.x = (ITEM_WIDTH + SPACE) * j;
					it.y = (it.height + SPACE) * i;
					addChild(it);

					count++;
				}
			}
		}

		public static function get GROUP_WIDTH():int
		{
		   return (ShopItemsGroup.ITEM_WIDTH + ShopItemsGroup.SPACE) * ShopItemsGroup.COLUMNS;
		}
	}
}
