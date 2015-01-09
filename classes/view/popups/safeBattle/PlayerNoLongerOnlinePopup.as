/**
 * Author: Alexey
 * Date: 11/30/12
 * Time: 4:22 PM
 */
package view.popups.safeBattle
{
	import flash.events.MouseEvent;

	import utils.Popup;

	public class PlayerNoLongerOnlinePopup extends Popup
	{
		public function PlayerNoLongerOnlinePopup(playerName:String)
		{
			super (new nolongeronline());

			playerName = playerName == "" ? "Player" : playerName;
			_mc.message_txt.text = playerName + " is no longer online. Try someone else.";
			_mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
		}
	}
}
