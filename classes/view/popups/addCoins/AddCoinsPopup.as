/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/9/13
 * Time: 7:25 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.addCoins
{
    import events.RequestEvent;

    import flash.events.MouseEvent;

    import model.PopupsManager;
    import model.shop.ShopItemsInfo;

    import networking.init.PlayerioInteractions;

    import utils.Popup;

    public class AddCoinsPopup extends Popup
    {
        public function AddCoinsPopup()
        {
            super(new addcoinspop(), true);

            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);

            var coinsOffer:CoinsOfferItem;
            for (var i:int = 0; i < ShopItemsInfo.REFILL_COINS_AMOUNTS.length; i++)
            {
                coinsOffer = new CoinsOfferItem(ShopItemsInfo.REFILL_COINS_AMOUNTS[i], ShopItemsInfo.REFILL_COINS_PRICES[i]);
                coinsOffer.addEventListener(RequestEvent.BUY_ITEM, goBuyItem);
                coinsOffer.x = 30;
                coinsOffer.y = 75 + (coinsOffer.height + 20) * i;
                addChild(coinsOffer);
            }
        }

        private static function goBuyItem(event:RequestEvent):void
        {
            PlayerioInteractions.buyCoins(event.stuff.coinsAmount);
        }
    }
}
