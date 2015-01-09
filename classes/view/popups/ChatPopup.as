/**
 * Author: Alexey
 * Date: 11/30/12
 * Time: 11:04 PM
 */
package view.popups
{
    import events.RequestEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.getTimer;

    import model.PopupsManager;

    import model.userData.UserData;

    import utils.EventHub;
    import utils.Misc;
    import utils.MovieClipContainer;

    public class ChatPopup extends MovieClipContainer
	{
		private static var instance:ChatPopup;
		private var currentUID:String = "";
		private const COLOR_OUT:uint = 0xFFFFFF;
		private const COLOR_OVER:uint = 0xCCCCCC;
		private var lastShownAt:uint = 0;

		public static function getInstance():ChatPopup
		{
			if (instance == null)
				instance = new ChatPopup(new SingletonEnforcer());
			return instance;
		}

		public function ChatPopup(singletonEnforcer:SingletonEnforcer)
		{
			super(new chatpop());

			_mc.mc.profile_mc.addEventListener(MouseEvent.MOUSE_OVER, setOverBg);
			_mc.mc.profile_mc.addEventListener(MouseEvent.CLICK, dispatchProfileClick);
			_mc.mc.profile_mc.addEventListener(MouseEvent.MOUSE_OUT, setOutBg);

			_mc.mc.report_mc.addEventListener(MouseEvent.MOUSE_OVER, setOverBg);
			_mc.mc.report_mc.addEventListener(MouseEvent.CLICK, dispatchReportClick);
			_mc.mc.report_mc.addEventListener(MouseEvent.MOUSE_OUT, setOutBg);

			_mc.mc.battle_mc.addEventListener(MouseEvent.MOUSE_OVER, setOverBg);
			_mc.mc.battle_mc.addEventListener(MouseEvent.CLICK, dispatchBattleClick);
			_mc.mc.battle_mc.addEventListener(MouseEvent.MOUSE_OUT, setOutBg);

			_mc.mc.battle_mc.buttonMode = true;
			_mc.mc.report_mc.buttonMode = true;
			_mc.mc.profile_mc.buttonMode = true;

			_mc.mc.battle_mc.mouseChildren = false;
			_mc.mc.report_mc.mouseChildren = false;
			_mc.mc.profile_mc.mouseChildren = false;

			Misc.applyColorTransform(_mc.mc.profile_mc.bg_mc, COLOR_OUT);
			Misc.applyColorTransform(_mc.mc.report_mc.bg_mc, COLOR_OUT);
			Misc.applyColorTransform(_mc.mc.battle_mc.bg_mc, COLOR_OUT);

			addEventListener(Event.ADDED_TO_STAGE, onAdded);

			hide();
		}

		private function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}

		private function onStageClick(event:MouseEvent):void
		{
			if (getTimer() - lastShownAt > 100) //hide if popup was shown more than 100ms ago (preventing instant close)
				hide();
		}

		private function dispatchBattleClick(event:MouseEvent):void
		{
			EventHub.dispatch(new RequestEvent(RequestEvent.REQUEST_BATTLE, {uid:currentUID}));
			hide();
		}

		private function dispatchReportClick(event:MouseEvent):void
		{
            PopupsManager.showComingSoonPopup();
			//EventHub.dispatch(new RequestEvent(RequestEvent.REPORT_USER, {uid:currentUID}));
			hide();
		}

		private function dispatchProfileClick(event:MouseEvent):void
		{
            PopupsManager.showComingSoonPopup();
			EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_USER_PROFILE, {uid:currentUID}));
			hide();
		}

		public function showForUser(uid:String, coordinates:Point):void
		{
			if (uid != UserData.uid)
			{
				x = coordinates.x;
				y = coordinates.y;
				currentUID = uid;
				visible = true;
				lastShownAt = getTimer();
			}
		}

		private function setOutBg(event:MouseEvent):void
		{
			Misc.applyColorTransform(event.currentTarget.bg_mc, COLOR_OUT);
		}

		private function setOverBg(event:MouseEvent):void
		{
			Misc.applyColorTransform(event.currentTarget.bg_mc, COLOR_OVER);
		}

		private function hide(e:MouseEvent = null):void
		{
			visible = false;
		}
	}
}

class SingletonEnforcer
{
}