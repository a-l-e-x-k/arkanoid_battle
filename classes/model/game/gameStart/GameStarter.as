/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/24/12
 * Time: 6:31 PM
 * To change this template use File | Settings | File Templates.
 */
package model.game.gameStart
{
    import events.RequestEvent;

    import model.PopupsManager;
    import model.ServerTalker;
    import model.constants.GameConfig;
    import model.constants.GameTypes;
    import model.userData.UserData;

    import networking.BattleRequester;
    import networking.RoomFinder;

    import utils.EventHub;

    /**
     * Single place for aggregating all game start - related requests.
     * Game type and request origin do not matter
     * Does checks for enegy.
     */
    public class GameStarter
    {
        public static function init():void
        {
            EventHub.addEventListener(RequestEvent.GO_BATTLE, goFindRoom);
            EventHub.addEventListener(RequestEvent.PLAY_AGAIN, playAgain);
        }

        private static function goFindRoom(event:RequestEvent):void
        {
            if (enoughEnergy(event.stuff.type))
            {
                if (event.stuff.type == GameTypes.FIRST_100 || event.stuff.type == GameTypes.UPSIDE_DOWN)
                {
                    PopupsManager.showComingSoonPopup();
                    return;
                }

                PopupsManager.showFindingOpponent();
                RoomFinder.findRoom(event.stuff.type, event.stuff.hasOwnProperty("map") ? event.stuff.map : -1);
            }
            else
            {
                PopupsManager.showNotEnoughEnergyPopup();
            }
        }

        private static function playAgain(event:RequestEvent):void
        {
            trace("GameStarter: playAgain: ");
            if (enoughEnergy(RoomFinder.targetGameType))
            {
                trace("GameStarter: playAgain: enough energy");
                PopupsManager.showGettingReady();
                RoomFinder.playAgain();
            }
            else
            {
                trace("GameStarter: playAgain: not enough energy");
                PopupsManager.showNotEnoughEnergyPopup();
            }
        }

        private static function enoughEnergy(type:String):Boolean
        {
            trace("GameStarter: enoughEnergy: for type: " + type);
            if (type == GameTypes.BIG_BATTLE)
            {
                return GameConfig.ENERGY_CONSUMPTION_BIG_BATTLE <= UserData.energy;
            }
            else if (type == GameTypes.FAST_SPRINT)
            {
                return GameConfig.ENERGY_CONSUMPTION_SPRINT <= UserData.energy;
            }
            else if (type == GameTypes.FIRST_100)
            {
                return GameConfig.ENERGY_CONSUMPTION_FIRST_100 <= UserData.energy;
            }
            else if (type == GameTypes.UPSIDE_DOWN)
            {
                return GameConfig.ENERGY_CONSUMPTION_UPSIDE_DOWN <= UserData.energy;
            }
            return false;
        }

        public static function requestBattle(targetUid:String, uid:String):void
        {
            if (enoughEnergy(GameTypes.FAST_SPRINT))
            {
                BattleRequester.requestBattle(targetUid, uid);
                PopupsManager.showWaitingForPlayer(targetUid);
            }
            else
            {
                PopupsManager.showNotEnoughEnergyPopup();
            }
        }

        public static function cancelCurrentBattleRequest():void
        {
            BattleRequester.cancelCurrentRequest();
        }

        public static function acceptBattleRequest():void
        {
            if (enoughEnergy(GameTypes.FAST_SPRINT))
            {
                ServerTalker.acceptBattleRequest();
            }
            else
            {
                PopupsManager.showNotEnoughEnergyPopup();
            }
        }

        public static function cancelBattleRequest():void
        {
            ServerTalker.cancelBattleRequest(); //when someone else is requesting battle from this player
        }
    }
}
