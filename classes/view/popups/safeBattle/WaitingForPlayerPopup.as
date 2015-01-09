/**
 * Author: Alexey
 * Date: 11/30/12
 * Time: 4:24 PM
 */
package view.popups.safeBattle
{
	import events.RequestEvent;

	import flash.events.MouseEvent;

	import utils.EventHub;

	import utils.Popup;

	public class WaitingForPlayerPopup extends Popup
	{
		public function WaitingForPlayerPopup(playerName:String)
		{
			super (new awaitingplayerpop());

			playerName = playerName == "" ? "Player" : playerName;

			_mc.message_txt.text = "Waiting for " + playerName + "...";
			_mc.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
		}

		private function onCancel(event:MouseEvent):void
		{
			EventHub.dispatch(new RequestEvent(RequestEvent.CANCEL_BATTLE_REQUEST));
			die();
		}
	}
}
