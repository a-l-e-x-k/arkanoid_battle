/**
 * Author: Alexey
 * Date: 5/6/12
 * Time: 9:20 PM
 */
package model.game
{
    import events.RequestEvent;

    import flash.display.DisplayObjectContainer;

    import model.IGameState;
    import model.constants.GameTypes;
    import model.constants.Maps;
    import model.game.gameStart.GameStartData;
    import model.requests.GameRequest;
    import model.userData.UserData;

    import networking.RoomFinder;

    import playerio.Message;

    import utils.EventHub;

    import utils.Misc;

    import view.game.*;
    import view.game.ball.ColoredBallsManager;
    import view.game.curveAnimations.PrefreezeEffectManager;
    import view.game.field.BaseField;
    import view.prewiggleEffect.PrewiggleEffectManager;

    public class Game implements IGameState
    {
        private var _gameFinishedData:GameFinishData; //recording game finish data and waiting for client showing loss, then shouwing game results
        private var _isPlaying:Boolean = true; //if not playing -> can open skills bouncer & can show "gameUpdated" popup
        private var _opponentsFinished:Boolean;
        private var _eventsHandler:GameEventsHandler;
        private var _view:GameView;
        private var _gameLength:int;
        private var _gameType:String;
        private var _startTime:int;

        public function Game(startData:GameStartData, parent:DisplayObjectContainer)
        {
            traceme("Starting game with type: " + startData.gameType, Relations.MESSAGES);
            _view = new GameView(startData, this);
            parent.addChild(_view);

            _eventsHandler = new GameEventsHandler(this);
            _gameLength = startData.gameLength;
            _gameType = startData.gameType;
            _startTime = new Date().time;

            UserData.energy -= startData.energyConsumed;
            UserData.energyNextUpdate = startData.nextEnergyUpdate;
            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_UPDATED));
            RoomFinder.targetGameType = GameTypes.FAST_SPRINT; //set it so when "Play again" is clicked RoomFinders knows of game type
        }

        internal function oppTicked(playerID:String, tickNumber:int):void
        {
            _view.myField.onOppFieldTick(playerID, tickNumber);
        }

        internal static function onPointsAnimFinished(field:BaseField, pointsAmount:int):void
        {
            field.playerInfo.addPoints(pointsAmount);
        }

        internal function onPlayerClearedCell(playerID:String, cellX:int, cellY:int, cellType:int):void
        {
            _view.showCellCleared(playerID, cellX, cellY, cellType);
        }

        internal function onPlayerLostBall(playerID:String, fromX:int, fromY:int):void
        {
            _view.showLostBall(playerID, fromX, fromY);
        }

        internal function updateUserPanel():void
        {
            _view.myField.updateSpellsPanel(UserData.spellsConfiguration.getPanelData());
        }

        internal function onGameFinishMessageReceived(msg:Message):void
        {
            trace("Game : onGameFinishMessageReceived : ");

            _gameFinishedData = new GameFinishData(msg);
            if (msg.getBoolean(1)) //force finish
            {
                trace("Show forced finish... ");
                showFinishMessage();
            }
            else //regular finish
            {
                trace("Show regular finish... ");
                tryShowFinishMessage();
            }
        }

        internal function onClientGameTimerFinished():void
        {
            _view.myField.addRequest(GameRequest.GAME_FINISH);
        }

        internal function onPlayerFinished(playerID:String):void
        {
            if (playerID == _view.opponentField.name)
            {
                _opponentsFinished = true;
            }

            tryShowFinishMessage();
        }

        private function tryShowFinishMessage():void
        {
            if (_opponentsFinished && _gameFinishedData)
            {
                showFinishMessage();
            }
        }

        private function showFinishMessage():void
        {
            _view.showGameResult(_gameFinishedData);
            _isPlaying = false;
        }

        internal function onClientAllowedSpell(requestID:int):void
        {
            traceme("Powerup allowed: " + requestID, Relations.MESSAGES);
            _view.myField.addRequest(requestID); //Request ID was sent to server before. Now it came back and can be used
        }

        internal function processPanelSync(targetX:Number, criticalHits:String, executedRequestsData:String):void
        {
            _view.opponentField.processPanelSync(targetX, criticalHits, executedRequestsData);
        }

        internal function updatePanelPosition(stageX:Number):void
        {
            _view.myField.updatePanelPosition(stageX);
        }

        public function movePanelViaKeyboard(direction:int = 1):void
        {
            _view.myField.updatePanelPositionViaKeyboard(direction);
        }

        internal function tick():void
        {
            if (_isPlaying)
            {
                _view.myField.onTick();
                _view.opponentField.onTick();
                PrewiggleEffectManager.update();  //important to update after fields (will use right balls' positions)
                PrefreezeEffectManager.update();
            }
            ColoredBallsManager.update(); //let wiggle path naturally die out
        }

        internal function onSpeedUp(targetSpeed:int, speedupperID:String, speeduperTick:int):void
        {
            _view.myField.addFutureSpeedUp(targetSpeed, speedupperID, speeduperTick); //at next tick it'll execute speed up
        }

        internal function goCharmBalls():void
        {
            _view.opponentField.addRequest(GameRequest.PRE_CHARM_BALLS); //fake one. So we see that opponent attacks us
            Misc.delayCallback(goReallyCharmBalls, 1000); //at next tick it'll execute charming balls
        }

        public function goFreeze():void
        {
            _view.opponentField.addRequest(GameRequest.PRE_FREEZE); //fake one. So we see that opponent attacks us
            Misc.delayCallback(goReallyFreeze, 1000); //at next tick it'll execute charming balls
        }

        public function goLaunchRocket():void
        {
            _view.opponentField.addRequest(GameRequest.PRE_ROCKET); //fake one. So we see that opponent attacks us
            Misc.delayCallback(goReallyLaunchRocket, 1000); //at next tick it'll execute charming balls
        }

        private function goReallyLaunchRocket():void
        {
            _view.myField.addRequest(GameRequest.ROCKET);
        }

        /**
         * Delayed for 1000 milliseconds for visuals sake
         */
        private function goReallyCharmBalls():void
        {
            _view.myField.addRequest(GameRequest.CHARM_BALLS);
        }

        /**
         * Delayed for 1000 milliseconds for visuals sake
         */
        private function goReallyFreeze():void
        {
            _view.myField.addRequest(GameRequest.FREEZE);
        }

        internal function showCharmLightnings(fromField:BaseField):void
        {
            _view.showCharmLightnings(fromField);
        }

        internal function showPrefreeze(fromField:BaseField):void
        {
            _view.showPrefreeze(fromField);
        }

        public function cleanUp():void
        {
            _view.cleanUp();
            _eventsHandler.removeListeners();
            _view.parent.removeChild(_view);
        }

        public function get isPlaying():Boolean
        {
            return _isPlaying;
        }

        public function get view():GameView
        {
            return _view;
        }

        public function get gameLength():int
        {
            return _gameLength;
        }

        public function get lastsFor():int
        {
            return new Date().time - _startTime;
        }

        public function get gameType():String
        {
            return _gameType;
        }

        public function onSpellExpired(spellName:String):void
        {
            _view.myField.spellsPanel.onSpellExpired(spellName);
        }

        public function onSpellActivated(spellName:String):void
        {
            _view.myField.spellsPanel.onSpellActivated(spellName);
        }

        public function onOpponentActivatedSpell(opponentID:String, spellName:String):void
        {
            trace("Game: onOpponentActivatedSpell: oppID: " + opponentID + " spell: " + spellName);
            _view.opponentField.spellsPanel.onSpellActivated(spellName);
        }

        public function onPlayerClearedField(fieldName:String):void
        {
            var targetField:BaseField = fieldName == _view.myField.name ? _view.myField : _view.opponentField;
            trace("Game: onPlayerClearedField: " + fieldName);
            targetField.addRequest(GameRequest.NEW_MAP);
        }

        public function showOpponentPreRocketLaunch():void
        {
            _view.opponentField.showPreRocketLaunch();
        }
    }
}