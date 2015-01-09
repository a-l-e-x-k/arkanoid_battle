/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/9/13
 * Time: 7:46 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.addCoins
{
    import events.RequestEvent;

    import flash.events.MouseEvent;

    import utils.MovieClipContainer;

    public class CoinsOfferItem extends MovieClipContainer
    {
        private var _coinsAmount:int;

        public function CoinsOfferItem(coinsAmount:int, priceInCents:int)
        {
            super(new shopOption());

            _coinsAmount = coinsAmount;
            _mc.mc.coins_txt.text = coinsAmount;
            _mc.mc.usd_txt.text = (priceInCents / 100).toString() + "$";
            _mc.mc.buy_btn.addEventListener(MouseEvent.CLICK, dispatchBuy);
        }

        private function dispatchBuy(event:MouseEvent):void
        {
            dispatchEvent(new RequestEvent(RequestEvent.BUY_ITEM, {coinsAmount:_coinsAmount}));
        }
    }
}
