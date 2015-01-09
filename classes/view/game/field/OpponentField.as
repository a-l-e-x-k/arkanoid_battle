/**
 * Author: Alexey
 * Date: 5/7/12
 * Time: 5:47 PM
 */
package view.game.field
{
    import events.RequestEvent;

    import model.constants.GameConfig;
    import model.game.Game;
    import model.game.GameResult;
    import model.game.gameStart.GameStartData;
    import model.game.panel.ChunkData;
    import model.game.panel.StepData;
    import model.game.playerInfo.PlayerData;
    import model.requests.GameRequest;
    import model.requests.GameRequestData;

    import utils.EventHub;

    import view.game.curveAnimations.PrefreezeEffectManager;
    import view.game.textPopups.OpponentLostPopup;
    import view.game.textPopups.OpponentWonPopup;
    import view.prewiggleEffect.PrewiggleEffectManager;

    public class OpponentField extends BaseField
    {
        public static const SYNC_FREQUENCY:int = 8; //264 / 8 = 33, every 30ms bouncer is synced
        private const START_BUFFER_SIZE:int = 4; //amount of messages required to start a game.

        public var _bouncerHitBuffer:Array = []; //contains x of bouncer when ball hit it, or x of bouncer when ball missed it. And whenever ball is below critical y, value from here is used to hard-set bouncer x

        private var _bouncerBuffer:Array = []; //mostly for beauty resons, updating opponent bouncer position
        private var _currentChunkNumber:int = 0;
        private var _currentChunkData:ChunkData;
        private var _wasAsync:Boolean = false;

        public function OpponentField(startData:GameStartData, playerData:PlayerData, gameLink:Game)
        {
            super(startData, playerData, gameLink);
        }

        override protected function setPosition():void
        {
            x = 401;
            y = 129;
            _view.x = 401; //coordinates at Starling stage
            _view.y = 129; //coordinates at Starling stage
        }

        public function processPanelSync(targetX:Number, criticalHits:String, executedRequestsData:String):void
        {
            var newHitsData:Array = new Array(8);

            //serverside & opponentField in the end have full sequence of bouncer positions for each tick.
            //opponent field is not operating with 8-chunks, 8-chunks are simply added to the queue
            //thus we have to push 8-chunks in queue

            if (criticalHits.length > 0)
            {
                trace("OpponentField: processPanelSync: " + criticalHits);
                var rawData:Array = criticalHits.split(",");
                var hitData:Array;
                var tickNumberWithinChunk:int = 0;
                var critHitInfo:Number = 0;
                for (var i:int = 0; i < rawData.length; i++)
                {
                    hitData = (rawData[i] as String).split(":");
                    tickNumberWithinChunk = int(hitData[0]);
                    critHitInfo = Number(hitData[1]);
                    newHitsData[tickNumberWithinChunk] = critHitInfo;
                }
            }

            _bouncerHitBuffer = _bouncerHitBuffer.concat(newHitsData);
            _bouncerBuffer.push(new ChunkData(targetX));

            if (executedRequestsData.length > 0)
            {
                _outstandingRequests.addFromString(executedRequestsData);
            }

            if (!_started && _bouncerBuffer.length == START_BUFFER_SIZE)
            {
                _started = true;
                startNewChunk();
            }
            else if (_wasAsync && _bouncerBuffer.length > 0) //buffer got empty once. It waits until buffer is refilled and starts animations again then.
            {
                _wasAsync = false;
                startNewChunk();
            }
        }

        override public function onTick():void
        {
            if (_started && !_gameFinished)
            {
                if (_currentChunkData)
                {
                    updateOpponentBouncerPosition(); //if there was crit hit postion will be updated. Otherwise it will be left the same
                    update();
                    syncPanelVelocity(); //used for visuals only, not as important as updateOpponentBouncerPosition() which may hard-set bouncer position
                    EventHub.dispatch(new RequestEvent(RequestEvent.OPPONENT_TICK, {oppID: playerInfo.uid, tickNumber: ballsManager.currentTick}));
                }
                else
                {
                    trace("[Opponent] Can't update ball position. No chunk data");
                }
            }

            _spellsPanel.tick();
        }

        override protected function executeRequest():void
        {
            var pd:GameRequestData = _outstandingRequests.requests[_ballsManager.currentTick];
            trace("[Request] [Opponent] Execute at: " + _ballsManager.currentTick + " request: " + pd.requestID + " reqData: " + pd.data);

            switch (pd.requestID)
            {
                case GameRequest.SPEED_UP:
                    _ballsManager.speedUpTo(int(pd.data));
                    break;
                case GameRequest.NEW_MAP:
                    gotoNewMap();
                    break;
                case GameRequest.SPLIT_BALL_IN_TWO:
                    explodeBalls(2);
                    break;
                case GameRequest.SPLIT_BALL_IN_THREE:
                    explodeBalls(3);
                    break;
                case GameRequest.LIGHTNING_ONE:
                    useLightning(1, pd.data);
                    break;
                case GameRequest.LIGHTNING_TWO:
                    useLightning(2, pd.data);
                    break;
                case GameRequest.LIGHTNING_THREE:
                    useLightning(3, pd.data);
                    break;
                case GameRequest.PRE_CHARM_BALLS: //it is complete fake for visual purposes. Inserted when player should go wiggle. Instead it plays anumation for a while, then execute CHARM_BALLS
                    dispatchShowCharmLightningsFromMe();
                    break;
                case GameRequest.CHARM_BALLS:
                    PrewiggleEffectManager.showBoom(this);
                    _ballsManager.goWiggle();
                    break;
                case GameRequest.PRE_FREEZE:
                    dispatchShowFreezingFromMe();
                    break;
                case GameRequest.FREEZE:
                    _freezer.freeze();
                    PrefreezeEffectManager.tryStopAnimation(this);
                    break;
                case GameRequest.BOUNCY_SHIELD:
                    goBouncyShield();
                    break;
                case GameRequest.LASER_SHOTS:
                    doLaserShots();
                    break;
                case GameRequest.ROCKET: //launch rocket from player's field
                    launchRocket();
                    break;
            }

            _spellsPanel.tryUsePowerup(pd.requestID);

            delete _outstandingRequests.requests[_ballsManager.currentTick];

            if (pd.requestID == GameRequest.GAME_FINISH)
            {
                stopPlaying();
            }
        }

        /**
         * Syncs bouncer. Sets it's x to the one which opponent's bouncer had when ball hit it.
         * Panel movement simulation & position setting algorithms have some inaccuaracy.
         */
        private function updateOpponentBouncerPosition():void
        {
            if (_bouncerHitBuffer[0] != null)
            {
                _bouncer.x = _bouncerHitBuffer[0];
            }

            _bouncerHitBuffer.shift();
        }

        private function syncPanelVelocity():void
        {
            var stepData:StepData = _currentChunkData.getVelocityChangeByIndex(_currentChunkNumber);
            if (_ballsManager.allBallsLaunched) //when starting multiple balls and agressively moving mouse bouncer starts moving early
            {
                _bouncer.x += stepData.xToAdd;
                _bouncer.x = Math.max(Math.min(_bouncer.x, GameConfig.FIELD_WIDTH_PX - GameConfig.BOUNCER_WIDTH), 0); //so it won't go over field borders
            }
            _currentChunkNumber++;
            if (_currentChunkNumber == SYNC_FREQUENCY)
            {
                startNewChunk();
            }
        }

        private function startNewChunk():void
        {
            if (_bouncerBuffer.length > 0)
            {
                _currentChunkData = _bouncerBuffer[0];
                _currentChunkData.setSteps(_bouncer.x);
                _bouncerBuffer.shift();
                _currentChunkNumber = 0;
            }
            else
            {
                _currentChunkData = null;
                _wasAsync = true;
                trace("startNewChunk BUFFER IS EMPTY!", Relations.OPPONENT_FIELD);
            }
        }

        public function showPostGame(gameResult:int):void
        {
            if (gameResult == GameResult.USER_LOST)
            {
                _view.addChild(new OpponentLostPopup(GameConfig.FIELD_WIDTH_PX / 2, GameConfig.FIELD_HEIGHT_PX / 2));
            }
            else if (gameResult == GameResult.USER_WON)
            {
                _view.addChild(new OpponentWonPopup(GameConfig.FIELD_WIDTH_PX / 2, GameConfig.FIELD_HEIGHT_PX / 2));
            }
            else if (gameResult == GameResult.USER_DRAW)
            {
                trace("OpponentField: showPostGame: doing nothing - draw...");
            }
        }

        public function showPreRocketLaunch():void
        {
            _rocketLauncher.showPreLaunch();
        }
    }
}
