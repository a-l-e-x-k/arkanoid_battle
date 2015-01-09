/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/5/13
 * Time: 1:34 AM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.events.MouseEvent;

    import model.PopupsManager;

    import utils.Popup;

    public class FeatureUnavailable extends Popup
    {
        public function FeatureUnavailable()
        {
            super(new feaunava(), true);
            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.create_btn.addEventListener(MouseEvent.CLICK, goCreateAccount);
        }

        private function goCreateAccount(e:MouseEvent):void
        {
            PopupsManager.showLoginWindow(true);
            PopupsManager.removeShopPopup();
            PopupsManager.removeSpellsPopup();
            die();
        }
    }
}
