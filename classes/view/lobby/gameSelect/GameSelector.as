/**
 * Author: Alexey
 * Date: 9/15/12
 * Time: 3:55 PM
 */
package view.lobby.gameSelect
{
	import events.RequestEvent;

	import flash.display.Sprite;

	import view.lobby.gameSelect.scroller.ItemsScroller;
	import view.lobby.gameSelect.sideNavigation.GameSelectSideNavigation;

	public class GameSelector extends Sprite
	{
		private var _itemsScroller:ItemsScroller;

		public function GameSelector()
		{
			var sideNavigation:GameSelectSideNavigation = new GameSelectSideNavigation();
			sideNavigation.addEventListener(RequestEvent.GOTO_PREV_PAGE, gotoLeft);
			sideNavigation.addEventListener(RequestEvent.GOTO_NEXT_PAGE, gotoRight);
			sideNavigation.x = 565;
			sideNavigation.y = 345;
			sideNavigation.scaleX = sideNavigation.scaleY = 0.7;
			addChild(sideNavigation);

			_itemsScroller = new ItemsScroller();
			_itemsScroller.x = 446;
			_itemsScroller.y = 155;
			addChild(_itemsScroller);
		}

		private function gotoRight(event:RequestEvent):void
		{
			_itemsScroller.addRightTask();
		}

		private function gotoLeft(event:RequestEvent):void
		{
			_itemsScroller.addLeftTask();
		}

		public function get currentGameType():String
		{
			return _itemsScroller.currentGameType;
		}

		public function clean():void
		{
			_itemsScroller.clean();
		}
	}
}
