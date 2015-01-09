/**
 * Author: Alexey
 * Date: 12/5/12
 * Time: 12:37 AM
 */
package view.popups.maps
{
	import events.RequestEvent;

	import external.caurina.transitions.Tweener;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import utils.Misc;
	import utils.Popup;

	public class MapsPopup extends Popup
	{
		private var groupsContainer:Sprite = new Sprite();
		private var groups:Vector.<ItemsGroup> = new Vector.<ItemsGroup>();
		private const POPUP_WIDTH:int = 680;

		public function MapsPopup()
		{
			super(new mapspop());

			_mc.close_btn.buttonMode = true;
			_mc.close_btn.addEventListener(MouseEvent.CLICK, die);

			groupsContainer.y = 70;
			groupsContainer.mask = Misc.createRectangle(POPUP_WIDTH, _mc.height, _mc.x, _mc.y);
			_mc.addChild(groupsContainer);

			var nm:NavigationMenu = new NavigationMenu(ItemsGroup.getGroupsCount());
			nm.addEventListener(RequestEvent.GOTO_PAGE, gotoPage);
			nm.x = (Config.APP_WIDTH - nm.width) / 2;
			nm.y = 473;
			nm.setGroup(0);
			_mc.addChild(nm);

			var c:int = ItemsGroup.getGroupsCount();
			for (var i:int = 0; i < c; i++)
			{
				var levelGroup:ItemsGroup = new ItemsGroup(i);
				levelGroup.x = POPUP_WIDTH * i;
				groupsContainer.addChild(levelGroup);
				groups.push(levelGroup);
			}

			gotoPage(new RequestEvent(RequestEvent.GOTO_PAGE, { page:0, insta:true }))
		}

		private function gotoPage(event:RequestEvent):void
		{
			if (groups.length == 0)
				return;

			var transitionLength:Number = 0.5;
			var pageID:int = event.stuff.page;
			var insta:Boolean = event.stuff.insta != null;
			var targetX:Number = -POPUP_WIDTH * pageID;
			if (targetX < groupsContainer.x) //do alpha tween for all groups at the left side when going to the right
			{
				for (var i:int = 0; i < pageID; i++)
				{
					groups[i].instaFadeIn();
					groups[i].fadeOutByItems(true, transitionLength);
				}
			}
			else if (targetX > groupsContainer.x) //do alpha tween for all groups at the right side when going to the left
			{
				for (i = groups.length - 1; i > pageID; i--)
				{
					groups[i].instaFadeIn();
					groups[i].fadeOutByItems(false, transitionLength);
				}
			}

			if (insta)
				groups[pageID].instaFadeIn();
			else
			{
				groups[pageID].instaFadeOut();
				groups[pageID].fadeIn(groups[pageID].x > targetX, transitionLength);
			}

			Tweener.addTween(groupsContainer, { x:targetX, time:insta ? 0 : transitionLength, transition:"easeOutSine" });
		}
	}
}
