/**
 * Author: Alexey
 * Date: 10/6/12
 * Time: 8:52 PM
 */
package view.popups
{
    import flash.events.MouseEvent;

    import utils.Popup;

public class MessagePopup extends Popup
{
	public function MessagePopup(text:String, canClose:Boolean = false):void
	{
		super(new msgpop(), true);
		_mc.message_txt.text = text;
		_mc.message_txt.y += Math.round((_mc.message_txt.height - _mc.message_txt.textHeight) / 2); //Vertical align for simple TextField
        _mc.close_btn.visible = canClose;
        if(canClose)
        {
            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
        }
	}
}
}
