/**
 * Author: Alexey
 * Date: 12/11/12
 * Time: 10:18 PM
 */
package view.popups.shop.activeTab
{
    import events.RequestEvent;

    import flash.display.Bitmap;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import model.PopupsManager;

    import model.shop.ShopItemVO;
    import model.shop.ShopItemsInfo;
    import model.userData.UserData;

    import utils.EventHub;
    import utils.MovieClipContainer;

    public class ShopItem extends MovieClipContainer
    {
        private const ITEM_AREA_WIDTH:int = 128;
        private const ITEM_AREA_HEIGHT:int = 109;
        private var _info:ShopItemVO;

        public function ShopItem(info:ShopItemVO)
        {
            super(new shopItem());
            _info = info;
            _mc.mc.price_txt.text = info.price;
            _mc.mc.name_txt.text = info.name;
            _mc.mc.buy_btn.addEventListener(MouseEvent.CLICK, dispatchBuy);

            var itemPic:DisplayObject = getItemPic(info.key);
            itemPic.x = (ITEM_AREA_WIDTH - itemPic.width) / 2;
            itemPic.y = (ITEM_AREA_HEIGHT - itemPic.height) / 2 + 10;
            _mc.mc.addChild(itemPic);

            EventHub.addEventListener(RequestEvent.ACTIVATE_BOUNCER, updateBouncerItem);
            EventHub.addEventListener(RequestEvent.BUY_ITEM, updateBouncerItem);
            addEventListener(Event.REMOVED_FROM_STAGE, clearListeners);
            updateBouncerItem();
        }

        private function clearListeners(event:Event):void
        {
            EventHub.removeEventListener(RequestEvent.ACTIVATE_BOUNCER, updateBouncerItem);
            EventHub.removeEventListener(RequestEvent.BUY_ITEM, updateBouncerItem);
        }

        /**
         * When item is representing bouncer item it should be updated
         */
        private function updateBouncerItem(e:RequestEvent = null):void
        {
            if (_info.tab == ShopItemsInfo.TAB_BOUNCERS)
            {
                if (UserData.payVaultItems.hasItem(_info.key))
                {
                    if (UserData.bouncerID == _info.key) //shows "Active" text
                    {
                        _mc.mc.gotoAndStop(3);
                    }
                    else //shows "Activate" button
                    {
                        _mc.mc.gotoAndStop(2);
                        _mc.mc.activate_btn.addEventListener(MouseEvent.CLICK, activateBouncer);
                    }
                }
            }
        }

        /**
         * Player has bouncer which should be activated - just change bouncerID at UserData
         * @param event
         */
        private function activateBouncer(event:MouseEvent):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.ACTIVATE_BOUNCER, {bouncerID: _info.key}));
            _mc.mc.gotoAndStop(3);
        }

        public static function getItemPic(itemKey:String):DisplayObjectContainer
        {
            var r:DisplayObjectContainer;
            var bmp:Bitmap;

            switch (itemKey)
            {
                case ShopItemsInfo.ENERGY_REFILL:
                    r = new batterysymbol();
                    break;
                case ShopItemsInfo.ENERGY_TICKET_1_DAY:
                    bmp = new Bitmap(new ticket1());
                    r = new Sprite();
                    r.addChild(bmp);
                    break;
                case ShopItemsInfo.ENERGY_TICKET_3_DAYS:
                    bmp = new Bitmap(new ticket3());
                    r = new Sprite();
                    r.addChild(bmp);
                    break;
                case ShopItemsInfo.ENERGY_TICKET_7_DAYS:
                    bmp = new Bitmap(new ticket7());
                    r = new Sprite();
                    r.addChild(bmp);
                    break;
                case ShopItemsInfo.ARMOR_3X:
                    r = new threeshields();
                    break;
                case ShopItemsInfo.ARMOR_5X:
                    r = new fiveshields();
                    break;
                case ShopItemsInfo.ARMOR_10X:
                    r = new tenshields();
                    break;
                case ShopItemsInfo.BOUNCER_STANDART_RED:
                    r = new starpanelr();
                    break;
                case ShopItemsInfo.BOUNCER_STANDART_BLUE:
                    r = new panelstartb();
                    break;
                case ShopItemsInfo.BOUNCER_STANDART_GREEN:
                    r = new starpanelg();
                    break;
                case ShopItemsInfo.BOUNCER_STANDART_PURPLE:
                    r = new starpanelp();
                    break;
                case ShopItemsInfo.BOUNCER_CHECKED_BLUE:
                    r = new checkedoutb();
                    break;
                case ShopItemsInfo.BOUNCER_CHECKED_PURPLE:
                    r = new checkedoutp();
                    break;
                case ShopItemsInfo.BOUNCER_CHECKED_RED:
                    r = new chedoutr();
                    break;
                case ShopItemsInfo.BOUNCER_CHECKED_BLACK:
                    r = new checkedoutbl();
                    break;
                case ShopItemsInfo.BOUNCER_ZAPPER_RED:
                    r = new zapperr();
                    break;
                case ShopItemsInfo.BOUNCER_ZAPPER_BLUE:
                    r = new zapperb();
                    break;
                case ShopItemsInfo.BOUNCER_ZAPPER_PURPLE:
                    r = new zapperp();
                    break;
                case ShopItemsInfo.BOUNCER_ZAPPER_BLACK:
                    r = new zapperbl();
                    break;
                case ShopItemsInfo.BOUNCER_ELECTRO_RED:
                    r = new electrored();
                    break;
                case ShopItemsInfo.BOUNCER_ELECTRO_BLUE:
                    r = new electroblue();
                    break;
                case ShopItemsInfo.BOUNCER_ELECTRO_PURPLE:
                    r = new electropurple();
                    break;
                case ShopItemsInfo.BOUNCER_ELECTRO_BLACK:
                    r = new electroblack();
                    break;
                case ShopItemsInfo.BOUNCER_PERFETTO_RED:
                    r = new perfettored();
                    break;
                case ShopItemsInfo.BOUNCER_PERFETTO_BLUE:
                    r = new perfettoblue();
                    break;
                case ShopItemsInfo.BOUNCER_PERFETTO_PURPLE:
                    r = new perfettopur();
                    break;
                case ShopItemsInfo.BOUNCER_PERFETTO_BLACK:
                    r = new perfettoblack();
                    break;
            }

            return r;
        }

        private function dispatchBuy(event:MouseEvent):void
        {
            if (UserData.isGuest)
            {
                PopupsManager.showFeatureUnavailableForGuest();
            }
            else
            {
                EventHub.dispatch(new RequestEvent(RequestEvent.BUY_ITEM,
                        {
                            itemKey: _info.key,
                            itemPrice: _info.price,
                            tab: _info.tab,
                            itemName: _info.name
                        }));
                updateBouncerItem();
            }
        }
    }
}
