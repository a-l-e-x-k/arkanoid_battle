/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 11:10 PM
 */
package view.popups.shop.activeTab
{
	import utils.MovieClipContainer;

	public class ShopActiveTab extends MovieClipContainer
	{
		public var tabName:String;

		public function ShopActiveTab(tabname:String)
		{
			super(new shopActiveTab());
			_mc.mc.name_txt.text = tabname;
			tabName = tabname;
		}
	}
}
