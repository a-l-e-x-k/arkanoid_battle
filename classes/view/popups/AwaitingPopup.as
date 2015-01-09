/**
 * Author: Alexey
 * Date: 9/8/12
 * Time: 7:05 PM
 */
package view.popups
{
import utils.Popup;

/**
 * Shown when connecting to room / awaiting "playing again"
 */
public class AwaitingPopup extends Popup
{
	public function AwaitingPopup(text:String)
	{
		super(new connecttoroom());

		_mc.message_txt.text = text;
	}
}
}
