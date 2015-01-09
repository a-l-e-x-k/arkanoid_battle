/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:06 PM
 */
package view.popups.shop.activeTab
{
	import events.RequestEvent;

	import utils.MovieClipContainer;

	/**
	 * Content of a tab. Navigation within a tab sits here as well.
	 * May conain groups of items.
	 */
	public class ShopActiveTabContent extends MovieClipContainer
	{
		private var _navigation:ShopNavigation;
		private var _itemsGroupContainer:ShopItemsGroupsContainer;
		private var _currentPage:int = 1;

		public function ShopActiveTabContent()
		{
			super(new shoptabcontainer());

			_navigation = new ShopNavigation();
			_navigation.x = (_mc.width - _navigation.width) / 2;
			_navigation.y = _mc.height + 5;
			_navigation.addEventListener(RequestEvent.GOTO_NEXT_PAGE, nextTabPage);
			_navigation.addEventListener(RequestEvent.GOTO_PREV_PAGE, prevTabPage);
			addChild(_navigation);
		}

		private function prevTabPage(event:RequestEvent):void
		{
			_currentPage--;
			_itemsGroupContainer.showPage(_currentPage);
		}

		private function nextTabPage(event:RequestEvent):void
		{
			_currentPage++;
			_itemsGroupContainer.showPage(_currentPage);
		}

		public function showTab(tabName:String):void
		{
			if (_itemsGroupContainer)
				_mc.mc.cont_mc.removeChild(_itemsGroupContainer);

            _currentPage = 1; //it must be set to 1 every time simply because we don't need old counter from the previously selected tab.

			_itemsGroupContainer = new ShopItemsGroupsContainer(tabName);
			_itemsGroupContainer.x = 20;
			_itemsGroupContainer.y = 20;
			_mc.mc.cont_mc.addChild(_itemsGroupContainer);

			_navigation.setStart(_itemsGroupContainer.pageCount);
		}
	}
}
