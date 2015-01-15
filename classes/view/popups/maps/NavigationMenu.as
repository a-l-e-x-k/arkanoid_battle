package view.popups.maps
{
	import events.RequestEvent;

	import caurina.transitions.Tweener;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class NavigationMenu extends Sprite
	{
		private const SPACE_BETWEEN_TINY_SELECTORS:int = 10;
		private const SPACE_BETWEEN_TINY_SELECTORS_AND_ARROWS:int = 38;
		private const OVER_RESISE:Number = 1.1; //by what number item resizes on mouse over
		private const RESIZE_TIME:Number = 0.15; //length of tween

		private var currentPage:int = 1;
		private var btnwidth:Number = 0;
		private var btnheight:Number = 0;
		private var _pageCount:int = 0;

		public function NavigationMenu(pageCount:int)
		{
			_pageCount = pageCount;

			var leftButton:MovieClip = new leftbtn();
			leftButton.buttonMode = true;
			leftButton.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			leftButton.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			leftButton.addEventListener(MouseEvent.CLICK, gotoPrevGroup);
			addChild(leftButton);

			var tinySelector:TinySelector;
			for (var i:int = 0; i < _pageCount; i++)
			{
				tinySelector = new TinySelector(i);
				tinySelector.addEventListener(MouseEvent.CLICK, selectGroup);
				tinySelector.x = leftButton.x + SPACE_BETWEEN_TINY_SELECTORS_AND_ARROWS + (tinySelector.width + SPACE_BETWEEN_TINY_SELECTORS) * i;
				tinySelector.y = leftButton.y - tinySelector.height / 2;
				tinySelector.name = "group_" + i;
				tinySelector.buttonMode = true;
				addChild(tinySelector);

				if (i > 0)
					tinySelector.goPassive(); //active by default
			}

			var rightButton:MovieClip = new rightbtn();
			rightButton.x = tinySelector.x + 57;
			rightButton.buttonMode = true;
			rightButton.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			rightButton.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			rightButton.addEventListener(MouseEvent.CLICK, gotoNextGroup);
			addChild(rightButton);

			btnwidth = rightButton.width;
			btnheight = rightButton.height;
		}

		private function onArrowOver(e:MouseEvent):void
		{
			Tweener.addTween(e.currentTarget as MovieClip, { width:btnwidth * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" });
			Tweener.addTween(e.currentTarget as MovieClip, { height:btnheight * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" });
		}

		private function onArrowOut(e:MouseEvent):void
		{
			Tweener.addTween(e.currentTarget as MovieClip, { width:btnwidth, time:RESIZE_TIME, transition:"easeOutSine" });
			Tweener.addTween(e.currentTarget as MovieClip, { height:btnheight, time:RESIZE_TIME, transition:"easeOutSine" });
		}

		private function gotoPrevGroup(e:MouseEvent):void
		{
			if (currentPage > 0)
			{
				currentPage--;
				dispatchGotoGroup();
				updateTinySelectors();
			}
		}

		private function gotoNextGroup(e:MouseEvent):void
		{
			if (currentPage < _pageCount - 1)
			{
				currentPage++;
				dispatchGotoGroup();
				updateTinySelectors();
			}
		}

		public function setGroup(groupID:int):void
		{
			currentPage = groupID;
			updateTinySelectors();
			dispatchGotoGroup();
		}

		private function selectGroup(e:MouseEvent):void
		{
			setGroup(int(e.currentTarget.name.charAt(e.currentTarget.name.length - 1)));
		}

		private function updateTinySelectors():void
		{
			for (var i:int = 0; i < _pageCount; i++)
			{
				var tinySelector:TinySelector = getChildByName("group_" + i) as TinySelector;
				if (tinySelector.id != currentPage)
					tinySelector.goPassive();
				else
					tinySelector.goActive();
			}
		}

		private function dispatchGotoGroup():void
		{
			dispatchEvent(new RequestEvent(RequestEvent.GOTO_PAGE, { page:currentPage }));
		}
	}
}