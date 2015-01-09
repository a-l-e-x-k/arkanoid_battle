/**
 * Author: Alexey
 * Date: 10/6/12
 * Time: 8:48 PM
 */
package model
{
    import events.ServerMessageEvent;

    import flash.display.Sprite;

    import model.userData.UserData;

    import utils.EventHub;
    import utils.Popup;

    import view.popups.AwaitingOverlay;

    import view.popups.AwaitingPopup;
    import view.popups.CoinsArrivedPopup;
    import view.popups.ComingSoonPopup;
    import view.popups.EnterOpponentNicknamePopup;
    import view.popups.FeatureUnavailable;
    import view.popups.GameUpdatedPopup;
    import view.popups.MessagePopup;
    import view.popups.NotEnoughCoinsPopup;
    import view.popups.NotEnoughEnergyPopup;
    import view.popups.RestoreRequestSentPopup;
    import view.popups.ShopItemPurchased;
    import view.popups.addCoins.AddCoinsPopup;
    import view.popups.login.LoginPopup;
    import view.popups.maps.MapsPopup;
    import view.popups.maps.PlayMapConfirmationPopup;
    import view.popups.myspells.SpellsPopup;
    import view.popups.safeBattle.BattleRequestedPopup;
    import view.popups.safeBattle.PlayerCanceledBattle;
    import view.popups.safeBattle.PlayerHavingBattlePopup;
    import view.popups.safeBattle.PlayerNoLongerOnlinePopup;
    import view.popups.safeBattle.WaitingForPlayerPopup;
    import view.popups.shop.ShopPopup;
    import view.popups.unlockSpell.ActivateSpellPopup;

    /**
     * Handles various kinds of errors.
     * Shows popup with error message.
     * May write errors to log
     */
    public class PopupsManager
    {
        private static var _popupLayer:Sprite;

        public static function init(popupLayer:Sprite):void
        {
            _popupLayer = popupLayer;

            EventHub.addEventListener(ServerMessageEvent.BATTLE_REQUESTED, showSafeBattleRequest);
            EventHub.addEventListener(ServerMessageEvent.BATTLE_REQUEST_CANCELLED, onBattleRequestCancelled);
            EventHub.addEventListener(ServerMessageEvent.PURCHASE_FAILED, onPurchaseFailed);
        }

        private static function onPurchaseFailed(event:ServerMessageEvent):void
        {
            var pop:MessagePopup = new MessagePopup("There was a problem with transaction: " + event.message.getString(0) + ". Please refresh the page.");
            _popupLayer.addChild(pop);
        }

        private static function onBattleRequestCancelled(event:ServerMessageEvent):void
        {
            cleanByClass(BattleRequestedPopup);
        }

        public static function showSafeBattleRequest(e:ServerMessageEvent):void
        {
            _popupLayer.addChild(new BattleRequestedPopup(UserData.nameFromUid(e.message.getString(0))));
        }

        public static function showWaitingForPlayer(playerID:String):void
        {
            _popupLayer.addChild(new WaitingForPlayerPopup(UserData.nameFromUid(playerID)));
        }

        public static function showPlayerHavingBattle(playerID:String):void
        {
            _popupLayer.addChild(new PlayerHavingBattlePopup(UserData.nameFromUid(playerID)));
        }

        public static function showPlayerNoLongerOnline(playerID:String):void
        {
            _popupLayer.addChild(new PlayerNoLongerOnlinePopup(UserData.nameFromUid(playerID)));
        }

        public static function showPlayerCancelledBattle(playerID:String):void
        {
            _popupLayer.addChild(new PlayerCanceledBattle(UserData.nameFromUid(playerID)));
        }

        public static function showShop(tab:String = ""):void
        {
            var pop:ShopPopup = ShopPopup.getInstance();
            pop.showTab(tab);
            _popupLayer.addChild(pop);
        }

        public static function showSendWhenDisconnectedPopup():void
        {
            _popupLayer.addChild(new MessagePopup("Trying to send message when disconnected from server. Please refresh the page."));
        }

        public static function showStreamErrorPopup():void
        {
            _popupLayer.addChild(new MessagePopup("Connection error. Make sure your Internet connection is alright and refresh the page."));
        }

        public static function showFindingOpponent():void
        {
            _popupLayer.addChild(new AwaitingPopup("Finding opponent..."));
        }

        public static function showGettingReady():void
        {
            _popupLayer.addChild(new AwaitingPopup("Getting ready..."));
        }

        public static function showMaps():void
        {
            _popupLayer.addChild(new MapsPopup());
        }

        public static function showPlayMapConfirmation(mapID:int):void
        {
            _popupLayer.addChild(new PlayMapConfirmationPopup(mapID, true));
        }

        public static function removeWaitingBattleRequestPopup():void
        {
            cleanByClass(WaitingForPlayerPopup);
        }

        public static function removeMapsPopup():void
        {
            cleanByClass(MapsPopup);
        }

        public static function showActivateSpellPopop(spellName:String):void
        {
            _popupLayer.addChild(new ActivateSpellPopup(spellName));
        }

        public static function removeAwatingGamePopups():void
        {
            cleanByClass(AwaitingPopup);
        }

        private static function cleanByClass(targetClass:Class):void
        {
            for each(var p:Popup in Popup.popups) //iterate through visible / unshown popups
            {
                if (p is targetClass)
                {
                    p.die();
                }
            }
        }

        public static function showNotEnoughCoinsPopup():void
        {
            _popupLayer.addChild(new NotEnoughCoinsPopup());
        }

        public static function showAddCoinsPopup():void
        {
            _popupLayer.addChild(new AddCoinsPopup());
        }

        public static function showNotEnoughEnergyPopup():void
        {
            _popupLayer.addChild(new NotEnoughEnergyPopup());
        }

        public static function showSpellsPopup():void
        {
            _popupLayer.addChild(new SpellsPopup());
        }

        public static function showLoginWindow(showRegistration:Boolean = false):void
        {
            new LoginModel(_popupLayer, showRegistration); //creates view and adds it to popup layer
        }

        public static function showMessagePopup(message:String, canClose:Boolean = true):void
        {
            removeAwaitingOverlay(); //there might be shown "Wait a sec..." thing
            _popupLayer.addChild(new MessagePopup(message, canClose));
        }

        public static function showGameUpdatedPopup():void
        {
            removeAwaitingOverlay(); //there might be shown "Wait a sec..." thing
            cleanByClass(GameUpdatedPopup);
            _popupLayer.addChild(new GameUpdatedPopup("Game was updated. Please refresh the page.", false));
        }

        public static function showRestorePasswordSent():void
        {
            removeAwaitingOverlay(); //there might be shown "Wait a sec..." thing
            _popupLayer.addChild(new RestoreRequestSentPopup());
        }

        public static function removeAwaitingOverlay():void
        {
            cleanByClass(AwaitingOverlay);
        }

        public static function removeLoginWindow():void
        {
            cleanByClass(LoginPopup);
        }

        public static function showAwaitingOverlay():void
        {
            _popupLayer.addChild(new AwaitingOverlay());
        }

        public static function showFeatureUnavailableForGuest():void
        {
            _popupLayer.addChild(new FeatureUnavailable());
        }

        public static function removeShopPopup():void
        {
            cleanByClass(ShopPopup);
        }

        public static function removeSpellsPopup():void
        {
            cleanByClass(SpellsPopup);
        }

        public static function showCoinsArrival(amountArrived:int):void
        {
            _popupLayer.addChild(new CoinsArrivedPopup(amountArrived))
        }

        public static function showItemBought(itemKey:String, itemName:String):void
        {
            _popupLayer.addChild(new ShopItemPurchased(itemKey, itemName));
        }

        public static function showComingSoonPopup():void
        {
            _popupLayer.addChild(new ComingSoonPopup());
        }

        public static function showEnterOpponentNicknamePopup():void
        {
            _popupLayer.addChild(new EnterOpponentNicknamePopup());
        }
    }
}
