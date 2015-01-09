/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:04 PM
 */
package view.popups.shop
{
	import events.RequestEvent;

	import flash.display.Sprite;

	import model.shop.ShopItemsInfo;

	import view.popups.shop.activeTab.ShopActiveTabArea;
	import view.popups.shop.backgroundTabs.ShopTabsBackground;

	/**
	 * Tabs, background tabs, items containers which show contents of the tab
	 */
	public class ShopContent extends Sprite
	{
		private var _backgroundTabs:ShopTabsBackground;
		private var _activeTab:ShopActiveTabArea; //tab & tab content here

		public function ShopContent()
		{
			_backgroundTabs = new ShopTabsBackground();
			_backgroundTabs.addEventListener(RequestEvent.SHOP_TAB_CLICKED, showActiveTab);
			addChild(_backgroundTabs);

			_activeTab = new ShopActiveTabArea();
			_activeTab.show(ShopItemsInfo.TAB_ENERGY);
			addChild(_activeTab);
		}

        public function showTab(tabName:String):void
        {
			_activeTab.show(tabName);
        }

		private function showActiveTab(event:RequestEvent):void
		{
            showTab(event.stuff.tabName);
		}
	}
}
