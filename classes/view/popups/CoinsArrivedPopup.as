/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/9/13
 * Time: 11:01 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import flash.events.MouseEvent;

    import utils.Popup;

    public class CoinsArrivedPopup extends Popup
    {
        public function CoinsArrivedPopup(coinsAmount:int)
        {
            super(new coinsArrivedp(), true);
            _mc.coins_txt.text = coinsAmount;
            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.ok_btn.addEventListener(MouseEvent.CLICK, die);
        }
    }
}
