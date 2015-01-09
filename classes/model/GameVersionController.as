/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/17/13
 * Time: 5:46 PM
 * To change this template use File | Settings | File Templates.
 */
package model
{
    import events.ServerMessageEvent;

    import model.game.Game;

    import utils.EventHub;
    import utils.Misc;

    import view.MainView;

    /**
     * Listens for update message from server & shows "Game updated message popup"
     */
    public class GameVersionController
    {
        private static var viewLink:MainView;

        public static function init(mainViewLink:MainView):void
        {
            viewLink = mainViewLink;
            EventHub.addEventListener(ServerMessageEvent.GAME_VERSION_UPDATED, onGameUpdated);
        }

        private static function onGameUpdated(event:ServerMessageEvent = null):void
        {
            if (viewLink.state is Game && (viewLink.state as Game).isPlaying)
            {
                Misc.delayCallback(onGameUpdated, 300); //will try to update later if game is currently on
            }
            else
            {
                PopupsManager.showGameUpdatedPopup();
            }
        }
    }
}
