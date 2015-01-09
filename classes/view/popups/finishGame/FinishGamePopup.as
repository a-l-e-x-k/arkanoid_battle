/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/22/12
 * Time: 5:25 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.finishGame
{
    import events.RequestEvent;

    import flash.events.MouseEvent;

    import model.constants.Maps;
    import model.userData.UserData;

    import utils.EventHub;
    import utils.Popup;

    public class FinishGamePopup extends Popup
    {
        /**
         * @param gameResult
         * @param points
         * @param mapID if it was a Sprint game, where only one map was played -> show points earned
         * @param coinsReceived
         * @param newRank
         * @param newRankProgress
         * @param newRankProtectionCount
         */
        public function FinishGamePopup(gameResult:int, points:int, mapID:int, coinsReceived:uint, newRank:int, newRankProgress:int, newRankProtectionCount:int)
        {
            super(new gamefinipiop());
            _mc.gotoAndStop(gameResult); //passed here is the GameResult constant
            _mc.b_btn.addEventListener(MouseEvent.CLICK, die);
           // _mc.b_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.close_btn.buttonMode = true;

            if (mapID != -1)
            {
                _mc.score_mc.gotoAndStop(2);
                var starsEarned:int = Maps.getMapStarsByPoints(mapID, points);
                _mc.score_mc.star1.visible = starsEarned > 0;
                _mc.score_mc.star2.visible = starsEarned > 1;
                _mc.score_mc.star3.visible = starsEarned > 2;
                UserData.mapsConfiguration.updateStars(mapID, starsEarned);
            }

            _mc.score_mc.score_txt.text = points.toString();
            _mc.coins_txt.text = "+" + coinsReceived;
            UserData.coins += coinsReceived; //not good to modify player from popup but fuck it

            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED)); //update coins at top bar

            var prevRank:int = UserData.rankNumber;
            var prevRankProgress:int = UserData.rankProgress;
            var prevRankProtectionCount:int = UserData.rankProtectionCount;

            trace("FinishGamePopup: FinishGamePopup: prevRank: " + prevRank);
            trace("FinishGamePopup: FinishGamePopup: prevRankProgress: " + prevRankProgress);
            trace("FinishGamePopup: FinishGamePopup: newRank: " + newRank);
            trace("FinishGamePopup: FinishGamePopup: newRankProgress: " + newRankProgress);

            //newRank = 70;
            //newRankProgress = 2;

            UserData.rankNumber = newRank;
            UserData.rankProgress = newRankProgress;
            UserData.rankProtectionCount = newRankProtectionCount;

            var ru:AnimatedRankUnit = new AnimatedRankUnit(prevRank, prevRankProgress, newRank, newRankProgress, prevRankProtectionCount, newRankProtectionCount);
            addChild(ru);
        }

        /**
         * In case if popup was closed before rank change tween ended
         * (which triggers top bar update on it's complete) -
         * force update top bar (UserData was updated already at constructor)
         */
        override protected function clearListeners():void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED));
        }
    }
}
