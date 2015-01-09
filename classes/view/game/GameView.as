/**
 * Author: Alexey
 * Date: 11/5/12
 * Time: 10:34 PM
 */
package view.game
{
    import flash.display.Sprite;

    import model.constants.GameConfig;
    import model.constants.PointsPrizes;

    import model.game.Game;
    import model.game.GameFinishData;
    import model.game.GameResult;
    import model.game.TimerPanel;
    import model.game.gameStart.GameStartData;
    import model.game.particlesAnimations.CurveAnimsShower;
    import model.game.playerInfo.PlayerData;
    import model.userData.UserData;

    import starling.core.Starling;

    import view.StarlingLayer;
    import view.game.curveAnimations.PrefreezeEffectManager;
    import view.game.field.BaseField;
    import view.game.field.OpponentField;
    import view.game.field.PlayerField;
    import view.prewiggleEffect.PrewiggleEffectManager;

    public class GameView extends Sprite
    {
        private var _myField:PlayerField;
        private var _opponentField:OpponentField;
        private var _tp:TimerPanel;

        public function GameView(startData:GameStartData, gameLink:Game)
        {
            var ids:Array = startData.oppIDs.split(",");
            var playerData:PlayerData = new PlayerData(UserData.uid, UserData.spellsConfiguration.getPanelData(), UserData.bouncerID);
            var oppData:PlayerData = new PlayerData(ids[0], startData.oppPanelConfigurations, startData.opponentBouncerIDs); //just 1 opp for now

            _myField = new PlayerField(startData, playerData, gameLink);
            _myField.name = playerData.uid;
            addChild(_myField);

            _opponentField = new OpponentField(startData, oppData, gameLink);
            _opponentField.name = oppData.uid;
            addChild(_opponentField);

            _tp = new TimerPanel(startData.gameLength);
            addChild(_tp);

            PrewiggleEffectManager.setFields([_myField, _opponentField], this);
            PrefreezeEffectManager.init((Starling.current.root as StarlingLayer).prefreezeAnimationsLayer);
        }

        public function cleanUp():void
        {
            _tp.die();
            _myField.cleanUp();
            _opponentField.cleanUp();
            PrewiggleEffectManager.clear();
            PrefreezeEffectManager.clear();
        }

        public function get myField():PlayerField
        {
            return _myField;
        }

        public function get opponentField():OpponentField
        {
            return _opponentField;
        }

        public function showLostBall(playerID:String, fromX:int, fromY:int):void
        {
            if (!(getChildByName(playerID) as BaseField).gameFinished) //it may be the situation when game is finished already but game finish message was not yet received
            {
                var targetField:BaseField = getOtherFields(playerID)[0];
                targetField.addPointsForTest(PointsPrizes.LOST_BALL);
                CurveAnimsShower.showLostBall(targetField, fromX, fromY);
            }
        }

        public function showCellCleared(playerID:String, cellX:int, cellY:int, cellType:int):void
        {
            var fromField:BaseField = (getChildByName(playerID) as BaseField);
            if (fromField.gameFinished)
            {
                return;
            }

            fromField.addPointsForTest(PointsPrizes.CELL_CLEARED);
            CurveAnimsShower.showCellCleared(fromField, getOtherFields(playerID)[0], cellX, cellY, cellType);
        }

        public function showCharmLightnings(fromField:BaseField):void
        {
            var oppField:BaseField = getOtherFields(fromField.name)[0];
            PrewiggleEffectManager.showLightnings(oppField, fromField);
        }

        public function showPrefreeze(fromField:BaseField):void
        {
            var oppField:BaseField = getOtherFields(fromField.name)[0];
            PrefreezeEffectManager.createAnimation(fromField, oppField);
        }

        /**
         * Gets all fields with id different from passed id
         * @param fieldName
         * @return
         */
        public function getOtherFields(fieldName:String):Vector.<BaseField>
        {
            var r:Vector.<BaseField> = new Vector.<BaseField>();
            if (fieldName == _myField.name)
            {
                r.push(_opponentField);
            }
            else if (fieldName == _opponentField.name)
            {
                r.push(_myField);
            }
            return r;
        }

        public function showGameResult(gameFinishedData:GameFinishData):void
        {
            var winnerId:String = gameFinishedData.winner;
            var playersPoints:int = gameFinishedData.getPlayerPoints(_myField.name);

            _myField.finishGame();
            _opponentField.finishGame();

            var gameResult:int;
            if (_myField.name == winnerId)
            {
                gameResult = GameResult.USER_WON;
            }
            else if (winnerId == "nobody")
            {
                gameResult = GameResult.USER_DRAW;
            }
            else
            {
                gameResult = GameResult.USER_LOST;
            }

            _myField.showPostGamePopups(gameResult, playersPoints, gameFinishedData.coinsAdded, gameFinishedData.newRank, gameFinishedData.newRankProgress, gameFinishedData.newRankProtectionCount);
            _opponentField.showPostGame(gameResult);
        }
    }
}
