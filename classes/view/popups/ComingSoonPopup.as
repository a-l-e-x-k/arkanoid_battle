/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/10/13
 * Time: 12:14 AM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.events.MouseEvent;

    import utils.Popup;

    public class ComingSoonPopup extends Popup
    {
        public function ComingSoonPopup()
        {
            super(new comingSoon(), true);

            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
        }
    }
}
