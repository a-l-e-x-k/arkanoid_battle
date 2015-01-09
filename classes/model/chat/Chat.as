/**
 * Author: Alexey
 * Date: 11/5/12
 * Time: 3:34 PM
 */
package model.chat
{
    import events.RequestEvent;

    import flash.display.DisplayObjectContainer;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import model.ServerTalker;
    import model.userData.UserData;

    import networking.init.PlayerioInteractions;

    import view.lobby.chat.ChatView;

    public class Chat
	{
		private var _view:ChatView;
		private var _messagesLoaded:Boolean = false;
		private var _lastIndexTime:Number = 0;
		private var _updateTimer:Timer = new Timer(2000); //try find new messages every 2 seconds

		public function Chat(parent:DisplayObjectContainer, xx:int, yy:int)
		{
			_view = new ChatView();
			_view.x = xx;
			_view.y = yy;
			_view.addEventListener(RequestEvent.SEND_CHAT_MESSAGE, onSendChatMessage);
			parent.addChild(_view);
			loadMessages();

			_updateTimer.addEventListener(TimerEvent.TIMER, loadMessages);
			_updateTimer.start();
		}

		public function cleanUp():void
		{
			_updateTimer.removeEventListener(TimerEvent.TIMER, loadMessages);
			_updateTimer.stop();
		}

		/**
		 * Loads 25 oldest messages
		 */
		private function loadMessages(e:TimerEvent = null):void
		{
			ServerTalker.client.bigDB.loadRange("ChatMessages", "date", null, 999999999999999, _lastIndexTime + 0.1, 25, onMessagesLoaded, PlayerioInteractions.handlePlayerIOError);
		}

		private function onMessagesLoaded(dbarr:Array):void
		{
			if (dbarr.length == 0)
				return;

			_lastIndexTime = dbarr[0].d;
			var messagesPack:Vector.<MessageData> = new Vector.<MessageData>();
			for (var i:int = 0; i < dbarr.length; i++)
			{
				if (!(_messagesLoaded && dbarr[i].u == UserData.uid)) //don't add message sent by user in this session again (it was already added when user hit Enter key)
					messagesPack.push(new MessageData(dbarr[i].m, dbarr[i].u, dbarr[i].r));
			}
			_view.addMessages(messagesPack);

			_messagesLoaded = true;
		}

		private function onSendChatMessage(event:RequestEvent):void
		{
			var text:String = event.stuff as String;
			if (text.length > 0 && _messagesLoaded) //TODO: bad words check
			{
				text = UserData.name + ": " + text;
				ServerTalker.sendChatMessage(text);
				var v:Vector.<MessageData> = new Vector.<MessageData>();
				v.push(new MessageData(text, UserData.uid, UserData.rankNumber)); //add message to chat (pure client-side)
				_view.addMessages(v);
				_view.clearInput();
			}
		}
	}
}
