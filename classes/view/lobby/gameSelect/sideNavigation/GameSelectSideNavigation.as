/**
 * Author: Alexey
 * Date: 12/12/12
 * Time: 5:16 PM
 */
package view.lobby.gameSelect.sideNavigation
{
	import events.RequestEvent;

	import caurina.transitions.Tweener;

	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GameSelectSideNavigation extends Sprite
	{
		private const OVER_RESISE:Number = 1.1; //by what number item resizes on mouse over
		private const RESIZE_TIME:Number = 0.15; //length of tween
		private var btnwidth:Number = 0;
		private var btnheight:Number = 0;

		public function GameSelectSideNavigation()
		{
			var left:GameSelectSideNavigationLeftButton = new GameSelectSideNavigationLeftButton();
			left.buttonMode = true;
			left.addEventListener(MouseEvent.CLICK, dispatchLeft);
			left.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			left.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			addChild(left);

			var right:GameSelectSideNavigationRightButton = new GameSelectSideNavigationRightButton();
			right.buttonMode = true;
			right.x = 67;
			right.addEventListener(MouseEvent.CLICK, dispatchRight);
			right.addEventListener(MouseEvent.MOUSE_OVER, onArrowOver);
			right.addEventListener(MouseEvent.MOUSE_OUT, onArrowOut);
			addChild(right);

			btnwidth = right.width;
			btnheight = right.height;
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

		private function dispatchRight(event:MouseEvent):void
		{
			dispatchEvent(new RequestEvent(RequestEvent.GOTO_NEXT_PAGE));
		}

		private function dispatchLeft(event:MouseEvent):void
		{
			dispatchEvent(new RequestEvent(RequestEvent.GOTO_PREV_PAGE));
		}
	}
}
