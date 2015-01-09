/**
 * Author: Alexey
 * Date: 12/5/12
 * Time: 12:46 AM
 */
package view.popups.maps
{
	import external.caurina.transitions.Tweener;

	import flash.display.Sprite;

	import model.constants.Maps;

	public class ItemsGroup extends Sprite
	{
		private static const ROWS:int = 2;
		private static const COLUMNS:int = 3;
		private const SPACE:int = 30;
		private const ITEM_WIDTH:int = 180;
		private const ITEM_HEIGHT:int = 158;
		private var _items:Vector.<MapItem> = new Vector.<MapItem>();

		/**
		 * @param groupID here is not 0-based, but starts from 1 (first group has groupID = 1)
		 */
		public function ItemsGroup(groupID:int)
		{
			var currentItemIndex:int = groupID * ROWS * COLUMNS;
			for (var j:int = 0; j < ROWS; j++)
			{
				for (var i:int = 0; i < COLUMNS; i++)
				{
					if (currentItemIndex < Maps.count)
					{
						var levelItem:MapItem = new MapItem(currentItemIndex);
						levelItem.name = currentItemIndex.toString();
						levelItem.x = (ITEM_WIDTH + SPACE) * i + 140;
						levelItem.y = (ITEM_HEIGHT + SPACE) * j + ITEM_HEIGHT / 2;
						addChild(levelItem);
						currentItemIndex++;
						_items.push(levelItem);
					}
					else
						break;
				}
			}
		}

		public static function getGroupsCount():int
		{
			return Math.ceil(Maps.count / (ROWS * COLUMNS));
		}

		public function fadeOutByItems(toTheLeft:Boolean, transitionLength:Number):void
		{
			var fastCoef:Number;
			for each (var mapItem:MapItem in _items)
			{
				if (toTheLeft)
					fastCoef = mapItem.x / width;
				else
					fastCoef = (1 - ((mapItem.x) / width));

				fastCoef *= 0.7;

				Tweener.addTween(mapItem, { alpha:0, time:transitionLength * fastCoef, transition:"easeOutSine" });
			}
		}

		public function fadeIn(toTheLeft:Boolean, transitionLength:Number):void
		{
			var fastCoef:Number;
			for each (var mapItem:MapItem in _items)
			{
				if (toTheLeft)
					fastCoef = mapItem.x / width;
				else
					fastCoef = (1 - ((mapItem.x) / width));

				fastCoef *= 1.5;

				fastCoef = Math.min(1, fastCoef);

				Tweener.addTween(mapItem, { alpha:1, time:transitionLength * fastCoef, transition:"easeInSine" });
			}
		}

		public function instaFadeIn():void
		{
			for each (var mapItem:MapItem in _items)
			{
				mapItem.alpha = 1;
			}
		}

		public function instaFadeOut():void
		{
			for each (var mapItem:MapItem in _items)
			{
				mapItem.alpha = 0;
			}
		}
	}
}
