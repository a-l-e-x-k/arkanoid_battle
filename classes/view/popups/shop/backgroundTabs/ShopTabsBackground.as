/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:04 PM
 */
package view.popups.shop.backgroundTabs
{
	import events.RequestEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import model.shop.ShopItemsInfo;

	/**
	 * Inactive tabs, sitting below ShopActiveTabArea
	 */
	public class ShopTabsBackground extends Sprite
	{
		private var _tabs:Vector.<ShopBackgroundTab> = new Vector.<ShopBackgroundTab>();

		public function ShopTabsBackground()
		{
			var allTabs:Array = ShopItemsInfo.getAllTabs();
			var areaWidth:int = 518;
			var testTab:ShopBackgroundTab = new ShopBackgroundTab("");
			var space:int = (areaWidth - allTabs.length * testTab.width) / (allTabs.length + 1);
			var tab:ShopBackgroundTab;
			for (var i:int = 0; i < allTabs.length; i++)
			{
				tab = new ShopBackgroundTab(allTabs[i]);
				tab.buttonMode = true;
				tab.mouseChildren = false;
				tab.x = space + (tab.width + space) * i;
				tab.y -= tab.height - 5;
				tab.addEventListener(MouseEvent.CLICK, dispatchTabClick);
				_tabs.push(tab);
				addChild(tab);
			}
		}

		private function dispatchTabClick(event:MouseEvent):void
		{
			var clickedTab:ShopBackgroundTab = event.currentTarget as ShopBackgroundTab;
			clickedTab.visible = true;
			for each (var shopBackgroundTab:ShopBackgroundTab in _tabs) //show all other tabs (previously selected tab is invisible ATM)
			{
				if (clickedTab != shopBackgroundTab)
					shopBackgroundTab.visible = true;
			}
			dispatchEvent(new RequestEvent(RequestEvent.SHOP_TAB_CLICKED, {tabName:clickedTab.tabName}));
		}
	}
}
