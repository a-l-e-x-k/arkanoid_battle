/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:32 PM
 */
package view.popups.shop.activeTab
{
	import flash.display.Sprite;

	/**
	 * Background thingy & active tabs
	 */
	public class ShopActiveTabArea extends Sprite
	{
		private var _background:ShopActiveTabBackground;
		private var _content:ShopActiveTabContent;

		public function ShopActiveTabArea()
		{
			_background = new ShopActiveTabBackground();
			addChild(_background);

			_content = new ShopActiveTabContent();
			_content.y = _content.x = (_background.width - _content.width) / 2;
			addChild(_content);
		}

		public function show(tabName:String):void
		{
			_background.showSelectedTab(tabName);
			_content.showTab(tabName);
		}
	}
}
