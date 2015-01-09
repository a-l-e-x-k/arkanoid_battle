/**
 * Author: Alexey
 * Date: 11/30/12
 * Time: 4:24 PM
 */
package view.popups.safeBattle
{
    import flash.events.MouseEvent;

    import model.game.gameStart.GameStarter;

    import utils.Popup;

    public class BattleRequestedPopup extends Popup
	{
		public function BattleRequestedPopup(playerName:String)
		{
			super (new acceptbattlepop());

			playerName = playerName == "" ? "Player" : playerName;

			_mc.message_txt.text = playerName + " requests Safe Battle with you.";

			_mc.accept_btn.addEventListener(MouseEvent.CLICK, onAccept);
			_mc.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
		}

		private function onCancel(event:MouseEvent):void
		{
            GameStarter.cancelBattleRequest();
			die();
		}

		private function onAccept(event:MouseEvent):void
		{
            GameStarter.acceptBattleRequest();
			die();
		}
	}
}
