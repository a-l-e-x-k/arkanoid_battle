/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:17 PM
 */
package view.popups.shop.backgroundTabs
{
	import utils.MovieClipContainer;

	public class ShopBackgroundTab extends MovieClipContainer
	{
		public var tabName:String;
		public function ShopBackgroundTab(tn:String)
		{
			super(new shopbackgroundtab());
			tabName = tn;
			_mc.mc.mc.name_txt.text = tn;
		}
	}
}
