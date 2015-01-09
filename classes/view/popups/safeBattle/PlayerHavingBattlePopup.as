/**
 * Author: Alexey
 * Date: 11/30/12
 * Time: 4:23 PM
 */
package view.popups.safeBattle
{
	import flash.events.MouseEvent;

	import utils.Popup;

	public class PlayerHavingBattlePopup extends Popup
	{
		public function PlayerHavingBattlePopup(playerName:String)
		{
			super(new playerplayingpop());

			playerName = playerName == "" ? "Player" : playerName;
			_mc.message_txt.text = playerName + " is having battle with someone else. Try another one.";
			_mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
		}
	}
}
