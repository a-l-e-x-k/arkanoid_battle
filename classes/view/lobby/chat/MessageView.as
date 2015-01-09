/**
 * Author: Alexey
 * Date: 11/5/12
 * Time: 3:07 AM
 */
package view.lobby.chat
{
	import external.caurina.transitions.Tweener;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import flash.text.TextFieldAutoSize;

	import model.chat.MessageData;

	import flash.text.TextField;

    import model.constants.Ranks;

    import utils.Misc;

	import utils.MovieClipContainer;
	import utils.t;

	import view.popups.ChatPopup;

	public class MessageView extends MovieClipContainer
	{
		private const GREY_COLOR:uint = 0x3E3E3E;
		private const DARK_GREY_COLOR:uint = 0x272727;
		private const WHITEISH_COLOR:uint = 0xDEDEDE;
		public var targetY:int; //value to which message is being (was) tweened (used to handle multiple tweens)
		private var _uid:String = "";

		public function MessageView(messageData:MessageData, greyBG:Boolean)
		{
			super(new messageView());

			var iTF:TextField = _mc.message_txt;
			iTF.autoSize = TextFieldAutoSize.LEFT;
			setNameButton(messageData, greyBG, iTF);
			_uid = messageData.userID;
			_mc.bg.height = _mc.message_txt.height + 7;
			Misc.applyColorTransform(_mc.bg, greyBG ? GREY_COLOR : DARK_GREY_COLOR);
			alpha = 0;
			Tweener.addTween(this, {alpha:1, time:1, transition:"easeOutSine", delay:0.2});
		}

		/**
		 * Hides name part in message, fills in button instead
		 * @param messageData
		 * @param greyBG
		 * @param iTF
		 */
		private function setNameButton(messageData:MessageData, greyBG:Boolean, iTF:TextField):void
		{
			var userName:String = messageData.text.substr(0, messageData.text.indexOf(":") + 1);
            var color:uint = greyBG ? GREY_COLOR : DARK_GREY_COLOR;
            var colorString:String = "#" + color.toString(16);
			var coloredUserNameForBG:String = '<font color="' + colorString + '">' + userName + "</font>"; //making name part "invisible" by setting same color as bg

            var userNameForNickButtonColorString:String = messageData.senderRank >= 100 ? WHITEISH_COLOR.toString(16) : 0x333333.toString(16);//handling max rank
			_mc.name_mc.name_txt.htmlText = '<font color="#' + userNameForNickButtonColorString + '">' + userName + "</font>";
            _mc.name_mc.name_txt.selectable = false;
			_mc.name_mc.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_mc.name_mc.bg_mc.width = _mc.name_mc.name_txt.width + 7;
			Misc.applyColorTransform(_mc.name_mc.bg_mc, Ranks.getColorByRank(messageData.senderRank));
			_mc.name_mc.buttonMode = true;
			_mc.name_mc.mouseChildren = false;
			_mc.name_mc.addEventListener(MouseEvent.CLICK, showChatPopup);

			userName = messageData.text.substr(0, messageData.text.indexOf(":") + 2); //include ": " part. With space now
			userName = userName.replace(/: /, ":W"); //so no new line will be there. HACK! :)
			iTF.htmlText = coloredUserNameForBG + messageData.text.substring(userName.length, messageData.text.length);
		}

		private function showChatPopup(event:MouseEvent):void
		{
			var pop:ChatPopup = ChatPopup.getInstance();
			parent.addChild(pop); //put it in here
			pop.showForUser(_uid, (new Point(x + _mc.name_mc.width + 12, y - pop.height + 26)));
		}
	}
}
