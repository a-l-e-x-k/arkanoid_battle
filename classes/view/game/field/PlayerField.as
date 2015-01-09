/**
 * Author: Alexey
 * Date: 5/7/12
 * Time: 5:20 PM
 */
package view.game.field
{
    import events.RequestEvent;

    import flash.utils.Dictionary;

    import model.ServerTalker;
    import model.constants.GameConfig;
    import model.constants.GameTypes;
    import model.game.Game;
    import model.game.SpeedUpData;
    import model.game.gameStart.GameStartData;
    import model.game.playerInfo.PlayerData;
    import model.requests.GameRequest;
    import model.requests.GameRequestData;

    import utils.EventHub;

    import view.game.curveAnimations.PrefreezeEffectManager;
    import view.game.spells.SpellsPanel;
    import view.game.textPopups.PostGameDecisionPopup;
    import view.popups.finishGame.FinishGamePopup;
    import view.prewiggleEffect.PrewiggleEffectManager;

    public class PlayerField extends BaseField
    {
        private var _mapID:int = -1; //used for FinishPopup only (showing stars).
        private var _criticalHits:Array = []; //x's of bouncer when it was hit by ball (or ball missed it)
        private var _executedRequests:Array = [];
        private var _tickNumberWithinChunk:int = -1; //from 0 to 7: number of current tick within sync chunk (8 ticks)
        private var _speedUpQueue:Dictionary = new Dictionary();
        private const KEYBOARD_PANEL_STEP:int = 13; //move keyboard this much on each game tick (30 times per second) when arrow key is down
        //here targets speeds are written. Speed up occurs when

        public function PlayerField(startData:GameStartData, playerData:PlayerData, gameLink:Game)
        {
            super(startData, playerData, gameLink);
            _started = true;
            if (startData.gameType == GameTypes.FAST_SPRINT)
            {
                _mapID = int(startData.mapsProgramData);
            }
        }

        public function addFutureSpeedUp(targetSpeed:int, speedupperID:String, speeduperTick:int):void
        {
            _speedUpQueue[speeduperTick] = new SpeedUpData(targetSpeed, speedupperID);
        }

        public function onOppFieldTick(oppID:String, tickNumber:int):void
        {
            if (_speedUpQueue[tickNumber] && _speedUpQueue[tickNumber].speedupperID == oppID)
            {
                addRequest(GameRequest.SPEED_UP, _speedUpQueue[tickNumber].targetSpeed.toString());
                _speedUpQueue[tickNumber] = null;
            }
        }

        override public function onTick():void
        {
            _tickNumberWithinChunk++;

            if (_started)
            {
                update();
            }

            _spellsPanel.tick();
        }

        public function showPostGamePopups(gameResult:int, playerPoints:int, coinsAdded:uint, newRank:int, newRankProgress:int, newRankProtectionCount:int):void
        {
            addChild(new PostGameDecisionPopup());
            stage.addChild(new FinishGamePopup(gameResult, playerPoints, _mapID, coinsAdded, newRank, newRankProgress, newRankProtectionCount));
            var cs:ChangeSpellsButton = new ChangeSpellsButton();
            cs.x = _spellsPanel.x + _spellsPanel.powerupIcons[0].x + SpellsPanel.ITEM_SIZE / 2;
            cs.y = _spellsPanel.y - 23;
            addChild(cs);
        }

        override public function saveCriticalHit(bouncerX:Number):void
        {
            _criticalHits.push(_tickNumberWithinChunk + ":" + bouncerX);
        }

        override protected function executeRequest():void
        {
            var pd:GameRequestData = _outstandingRequests.requests[_ballsManager.currentTick];
            var result:String = "";

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
                    result = useLightning(1);
                    break;
                case GameRequest.LIGHTNING_TWO:
                    result = useLightning(2);
                    break;
                case GameRequest.LIGHTNING_THREE:
                    result = useLightning(3);
                    break;
                case GameRequest.PRE_CHARM_BALLS: //executed when charming powerup is allowed
                    dispatchShowCharmLightningsFromMe();
                    break;
                case GameRequest.CHARM_BALLS:
                    PrewiggleEffectManager.showBoom(this);
                    _ballsManager.goWiggle();
                    break;
                case GameRequest.PRE_FREEZE: //executed when freezing powerup is allowed
                    dispatchShowFreezingFromMe();
                    break;
                case GameRequest.FREEZE:
                    _freezer.freeze();
                    PrefreezeEffectManager.tryStopAnimation(this);
                    trace("PlayerField : executeRequest : pd.requestID: " + pd.requestID + " at: " + _ballsManager.currentTick);
                    break;
                case GameRequest.BOUNCY_SHIELD:
                    goBouncyShield();
                    break;
                case GameRequest.LASER_SHOTS:
                    doLaserShots();
                    break;
                case GameRequest.PRE_ROCKET: //Only visual request. Player just launched rocket. Now tell opponent's field to create rocket that will be launched when opponent will execute ROCKET request
                    dispatchOpponentShowPreRocketLaunch();
                    break;
                case GameRequest.ROCKET: //launch rocket from opponent's field (it is visually located at opponent's field, but logically is related to player's field)
                    launchRocket();
                    break;
            }

            trace("[Request] [Player] Execute at: " + _ballsManager.currentTick + " request: " + pd.requestID + " spellName: " + GameRequest.getSpellNameByRequest(pd.requestID) + " reqData: " + pd.data + " result: " + result);

            _spellsPanel.tryUsePowerup(pd.requestID);

            if (pd.requestID != GameRequest.PRE_CHARM_BALLS && pd.requestID != GameRequest.PRE_FREEZE && pd.requestID != GameRequest.PRE_CHARM_BALLS && pd.requestID != GameRequest.PRE_ROCKET) //no need to send over purely visual effect to a server
            {
                _executedRequests.push(pd.requestID + ":" + _ballsManager.currentTick + ":" + result);
            }

            delete _outstandingRequests.requests[_ballsManager.currentTick];

            if (pd.requestID == GameRequest.GAME_FINISH)
            {
                stopPlaying();
            }
        }

        /**
         * See description of spell flow at GameRequest.as
         */
        private static function dispatchOpponentShowPreRocketLaunch():void
        {
            trace("PlayerField: dispatchOpponentShowPreRocketLaunch: ");
            EventHub.dispatch(new RequestEvent(RequestEvent.OPPONENT_SHOW_PRE_ROCKET_LAUNCH));
        }

        /**
         * Sends message in format: x (rounded to int), velocity % (in percents. E.g 0.23 = 23%)
         *
         * Called at the very end of "update" function (in BaseField).
         * Or at the end of game.
         */
        override protected function sendSyncMessage():void
        {
            ServerTalker.sendPanelSyncWithCriticalHits(_bouncer.x, _criticalHits.join(","), _executedRequests.join("$"));
            _criticalHits = [];
            _executedRequests = [];
            _tickNumberWithinChunk = -1; //next tick tick() function will increment counter (before calling tick() on field) so it will become 0, which is #1 within chunk
        }

        public function updatePanelPosition(mouseX:Number):void
        {
            if (_ballsManager.allBallsLaunched && !_gameCompletelyFinished) //wait until balls will launch (so bouncer X won't be messed up).
            {
                var targX:Number = Math.max(Math.min(mouseX - GameConfig.BOUNCER_WIDTH / 2, GameConfig.FIELD_WIDTH_PX - GameConfig.BOUNCER_WIDTH), 0);
                _bouncer.x = targX;//+= (targX - _bouncer.x) * _freezer.coef * _freezer.coef * _freezer.coef * _freezer.coef; //need stronger coef, thus double multiplication
            }
        }

        public function updatePanelPositionViaKeyboard(direction:int):void
        {
            if (_ballsManager.allBallsLaunched && !_gameCompletelyFinished) //wait until balls will launch (so bouncer X won't be messed up).
            {
                var targX:Number = Math.max(Math.min(_bouncer.x + direction * KEYBOARD_PANEL_STEP, GameConfig.FIELD_WIDTH_PX - GameConfig.BOUNCER_WIDTH), 0);
                _bouncer.x += (targX - _bouncer.x) * _freezer.coef;
            }
        }
    }
}