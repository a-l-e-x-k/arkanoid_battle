/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/19/12
 * Time: 3:34 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.events.MouseEvent;

    import model.PopupsManager;

    import utils.Popup;

    public class NotEnoughCoinsPopup extends Popup
    {
        public function NotEnoughCoinsPopup()
        {
            super(new notenoughcoins(), true);
            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.add_btn.addEventListener(MouseEvent.CLICK, dispatchAdd);
        }

        private function dispatchAdd(event:MouseEvent):void
        {
            PopupsManager.showAddCoinsPopup();
            die();
        }
    }
}
