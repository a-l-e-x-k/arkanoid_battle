/**
 * Author: Alexey
 * Date: 9/15/12
 * Time: 3:49 PM
 */
package view.lobby.chat
{
	import events.RequestEvent;

	import external.caurina.transitions.Tweener;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

    import model.PopupsManager;

    import model.chat.MessageData;
    import model.userData.UserData;

    import utils.Misc;
	import utils.MovieClipContainer;

	public class ChatView extends MovieClipContainer
	{
		private const MESSAGE_BOX_HEIGHT:int = 459;
		private var _messageCounter:int = 0; //for colorising bgs of MessageViews
		private var _messages:Vector.<MessageView> = new Vector.<MessageView>();

		public function ChatView()
		{
			super(new chatthing());

			_mc.send_btn.buttonMode = true;
			_mc.send_btn.addEventListener(MouseEvent.CLICK, sendMessage);

			_mc.msgbox_mc.inp_txt.text = "";
			_mc.msgbox_mc.inp_txt.addEventListener(KeyboardEvent.KEY_DOWN, sendMessage);
			_mc.msgbox_mc.inp_txt.addEventListener(Event.CHANGE, checkForNewline);

			while (_mc.messageBox_mc.container_mc.numChildren > 0) //clean stuff left from design
			{
				_mc.messageBox_mc.container_mc.removeChildAt(0);
			}
		}

		private function checkForNewline(event:Event):void
		{
			_mc.msgbox_mc.inp_txt.text = _mc.msgbox_mc.inp_txt.text.replace("\r", "").replace("\n", "");
		}

		private function sendMessage(event:Event):void
		{
			if (event is MouseEvent || (event is KeyboardEvent && (event as KeyboardEvent).keyCode == Keyboard.ENTER))
			{
                if (UserData.isGuest)
                    PopupsManager.showFeatureUnavailableForGuest();
                else
				    dispatchEvent(new RequestEvent(RequestEvent.SEND_CHAT_MESSAGE, getCurrentMessageText()));
			}
		}

		public function clearInput():void
		{
			_mc.msgbox_mc.inp_txt.text = "";
		}

		private function getCurrentMessageText():String
		{
			return _mc.msgbox_mc.inp_txt.text;
		}

		public function addMessages(messages:Vector.<MessageData>):void
		{
			var messageViews:Vector.<MessageView> = createMessageViews(messages);
			pushMessages(messageViews);
			tryRemoveOldMessages();
		}

		private function tryRemoveOldMessages():void
		{
			for each (var messageView:MessageView in _messages)
			{
				if (messageView.y < -500)
				{
					_messages.splice(_messages.indexOf(messageView), 1);
					msgParent.removeChild(messageView);
				}
			}
		}

		private function pushMessages(messageViews:Vector.<MessageView>):void
		{
			var packHeight:int = 0;
			var messageView:MessageView;
			for (var i:int = 0; i < messageViews.length; i++)
			{
				messageView = messageViews[i];
				_messages.push(messageView);
				msgParent.addChild(messageView);
				messageView.y = MESSAGE_BOX_HEIGHT - messageView.height - packHeight;
				messageView.targetY = messageView.y;
				packHeight += messageView.height;
			}

			for each (var message:MessageView in _messages)
			{
				if (messageViews.indexOf(message) == -1)
				{
					message.targetY -= packHeight; //can't use "y" property, it may be tweening ATM
					Tweener.addTween(message, {y:message.targetY, time:1, transition:"easeOutExpo"});
				}
			}
		}

		private function createMessageViews(messages:Vector.<MessageData>):Vector.<MessageView>
		{
			var views:Vector.<MessageView> = new Vector.<MessageView>();
			var view:MessageView;
			for (var i:int = messages.length - 1; i >= 0; i--)  //reverse so that we keep _messageCounter incremented in an understandiple way (items are always "inserted at the bottom", upwards queue)
			{
				view = new MessageView(messages[i], _messageCounter % 2 == 0);
				views.unshift(view);
				_messageCounter++;
			}

			return views;
		}

		private function get msgParent():DisplayObjectContainer
		{
			return _mc.messageBox_mc.container_mc;
		}
	}
}
