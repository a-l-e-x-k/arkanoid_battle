/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:16 PM
 */
package view.popups.shop.activeTab
{
	import events.RequestEvent;

	import flash.display.MovieClip;

	import flash.events.MouseEvent;

	import utils.MovieClipContainer;

	public class ShopNavigation extends MovieClipContainer
	{
		private var _current:int = 0; //0-based index
		private var _total:int = 1;

		public function ShopNavigation()
		{
			super(new shopNavigation());

			_mc.back_mc.buttonMode = true;
			_mc.forw_mc.buttonMode = true;
			_mc.back_mc.addEventListener(MouseEvent.CLICK, goBack);
			_mc.forw_mc.addEventListener(MouseEvent.CLICK, goForward);
		}

		private function goForward(event:MouseEvent):void
		{
			if (_current < _total - 1)
			{
				_current++;
				if (_current == _total - 1)
					deactivateArrow(_mc.forw_mc);
				else if (_current == 1)
					activateArrow(_mc.back_mc);
				dispatchEvent(new RequestEvent(RequestEvent.GOTO_NEXT_PAGE));
				updateView();
			}
		}

		private static function activateArrow(b:MovieClip):void
		{
			b.gotoAndStop(1);
			b.buttonMode = true;
		}

		private static function deactivateArrow(b:MovieClip):void
		{
			b.gotoAndStop(2);
			b.buttonMode = false;
		}

		private function goBack(event:MouseEvent):void
		{
			if (_current > 0)
			{
				_current--;
				if (_current == 0)
					deactivateArrow(_mc.back_mc);
				else if (_current == _total - 2)
					activateArrow(_mc.forw_mc);
				dispatchEvent(new RequestEvent(RequestEvent.GOTO_PREV_PAGE));
				updateView();
			}
		}

		public function setStart(pageCount:int):void
		{
			_current = 0;
			_total = pageCount;
			deactivateArrow(_mc.back_mc);
			if (_total == 1)
				deactivateArrow(_mc.forw_mc);
			else
				activateArrow(_mc.forw_mc);
			updateView();
		}

		private function updateView():void
		{
			_mc.pageCounter_txt.text = (_current + 1).toString() + "/" + _total;
		}
	}
}
