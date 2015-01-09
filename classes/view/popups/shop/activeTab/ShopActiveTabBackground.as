/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:43 PM
 */
package view.popups.shop.activeTab
{
	import model.shop.ShopItemsInfo;

	import utils.MovieClipContainer;

	public class ShopActiveTabBackground extends MovieClipContainer
	{
		private var _tabs:Vector.<ShopActiveTab> = new Vector.<ShopActiveTab>();

		public function ShopActiveTabBackground()
		{
			super(new shopitemscont());

			var allTabs:Array = ShopItemsInfo.getAllTabs();
			var areaWidth:int = 518;
			var testTab:ShopActiveTab = new ShopActiveTab("");
			var space:int = (areaWidth - allTabs.length * testTab.width) / (allTabs.length + 1);
			var tab:ShopActiveTab;
			for (var i:int = 0; i < allTabs.length; i++)
			{
				tab = new ShopActiveTab(allTabs[i]);
				tab.buttonMode = true;
				tab.mouseChildren = false;
				tab.x = space + (tab.width + space) * i;
				tab.y -= tab.height - 5;
				_tabs.push(tab);
				addChild(tab);
			}
		}

		public function showSelectedTab(tabName:String):void
		{
			for each (var shopBackgroundTab:ShopActiveTab in _tabs) //show all other tabs (previously selected tab is invisible ATM)
			{
				shopBackgroundTab.visible = tabName == shopBackgroundTab.tabName;
			}
		}
	}
}
