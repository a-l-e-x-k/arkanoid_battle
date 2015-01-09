/**
 * Author: Alexey
 * Date: 12/1/12
 * Time: 6:25 PM
 */
package view.popups.safeBattle
{
	import flash.events.MouseEvent;

	import utils.Popup;

	public class PlayerCanceledBattle extends Popup
	{
		public function PlayerCanceledBattle(playerName:String)
		{
			super(new playercancelledpop());

			playerName = playerName == "" ? "Player" : playerName;
			_mc.message_txt.text = playerName + " could not play with you.";
			_mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
		}
	}
}
