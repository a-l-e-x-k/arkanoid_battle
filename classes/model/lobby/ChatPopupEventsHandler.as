/**
 * Author: Alexey
 * Date: 12/1/12
 * Time: 5:59 PM
 */
package model.lobby
{
    import events.RequestEvent;

    import model.PopupsManager;
    import model.game.gameStart.GameStarter;
    import model.userData.UserData;

    import utils.EventHub;

    /**
     * Interlayer between BattleRequester & ChatPopup
     * Listens for ChatPopup clicks, asks to find room, handles battle request acceptance from opponent
     */
    public class ChatPopupEventsHandler
    {
        public static function init():void
        {
            EventHub.addEventListener(RequestEvent.REQUEST_BATTLE, goRequestBattle);
            EventHub.addEventListener(RequestEvent.REPORT_USER, goReportUser);
            EventHub.addEventListener(RequestEvent.SHOW_USER_PROFILE, goShowUserProfile);
            EventHub.addEventListener(RequestEvent.CANCEL_BATTLE_REQUEST, goCancelBattleRequest);
            EventHub.addEventListener(RequestEvent.SHOW_PLAYER_NO_LONGER_ONLINE, showPlayerNoLongerOnline);
            EventHub.addEventListener(RequestEvent.SHOW_PLAYER_IS_PLAYING_ALREADY, showPlayerIsPlayingAlready);
            EventHub.addEventListener(RequestEvent.SHOW_PLAYER_CANCELLED_BATTLE, showPlayerCancelledBattle);
        }

        private static function goRequestBattle(event:RequestEvent):void
        {
            GameStarter.requestBattle(event.stuff.uid, UserData.uid);
        }

        private static function goCancelBattleRequest(event:RequestEvent):void
        {
            GameStarter.cancelCurrentBattleRequest();
        }

        private static function showPlayerCancelledBattle(event:RequestEvent):void
        {
            PopupsManager.removeWaitingBattleRequestPopup();
            PopupsManager.showPlayerCancelledBattle(event.stuff.uid);
        }

        private static function showPlayerIsPlayingAlready(event:RequestEvent):void
        {
            PopupsManager.removeWaitingBattleRequestPopup();
            PopupsManager.showPlayerHavingBattle(event.stuff.uid);
        }

        private static function showPlayerNoLongerOnline(event:RequestEvent):void
        {
            PopupsManager.removeWaitingBattleRequestPopup();
            PopupsManager.showPlayerNoLongerOnline(event.stuff.uid);
        }

        private static function goShowUserProfile(event:RequestEvent):void
        {
            //TODO: show profile
        }

        private static function goReportUser(event:RequestEvent):void
        {
            //TODO: UserReporter.report(event.stuff.uid);
        }
    }
}
