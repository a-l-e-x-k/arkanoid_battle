/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/3/13
 * Time: 11:15 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.events.MouseEvent;

    import utils.Popup;

    public class RestoreRequestSentPopup extends Popup
    {
        public function RestoreRequestSentPopup()
        {
            super(new restorepop(), true);
            _mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
        }
    }
}
