/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 11:20 PM
 */
package view.popups.shop.activeTab
{
	import caurina.transitions.Tweener;

	import flash.display.Sprite;

	import model.shop.ShopItemVO;

	import model.shop.ShopItemsInfo;

	public class ShopItemsGroupsContainer extends Sprite
	{
		private var _groupsPodium:Sprite = new Sprite();
		private var _pageCount:int;

		public function ShopItemsGroupsContainer(tabName:String)
		{
			addChild(_groupsPodium);

			var items:Vector.<ShopItemVO> = ShopItemsInfo.getTabContaints(tabName);
			var itemsPerGroup:int = ShopItemsGroup.COLUMNS * ShopItemsGroup.ROWS;
			_pageCount = Math.ceil(items.length / itemsPerGroup);
			_pageCount = Math.max(_pageCount, 1);
			var group:ShopItemsGroup;
			var sliceEnd:int;
			for (var i:int = 0; i < _pageCount; i++)
			{
				sliceEnd = Math.min((i + 1) * itemsPerGroup, items.length);
				group = new ShopItemsGroup(items.slice(i * itemsPerGroup, sliceEnd));
				group.x = ShopItemsGroup.GROUP_WIDTH * i;
				_groupsPodium.addChild(group);
			}
		}

		public function showPage(number:int):void
		{
			Tweener.addTween(_groupsPodium, { x: -(number - 1) * ShopItemsGroup.GROUP_WIDTH, time: 0.5, transition: "easeOutSine" });
		}

		public function get pageCount():int
		{
			return _pageCount;
		}
	}
}
