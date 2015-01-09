/**
 * Author: Alexey
 * Date: 5/16/12
 * Time: 10:59 PM
 */
package view.game.field
{
    import events.RequestEvent;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;

    import model.constants.GameConfig;
    import model.game.Freezer;
    import model.game.Game;
    import model.game.ball.BallModel;
    import model.game.ball.BallSplitter;
    import model.game.ball.BallsManager;
    import model.game.bricks.FieldCells;
    import model.game.gameStart.GameStartData;
    import model.game.laser.LaserShotsManager;
    import model.game.lightning.LightningEffect;
    import model.game.missile.RocketLauncher;
    import model.game.playerInfo.PlayerData;
    import model.requests.OutstandingRequests;

    import starling.core.Starling;

    import utils.EventHub;

    import view.StarlingLayer;
    import view.game.bouncer.Bouncer;
    import view.game.playerInfo.PlayerInfo;
    import view.game.spells.SpellsPanel;
    import view.game.textPopups.MissPopup;

    /**
     * Contains logic which is same for both OpponentField & PlayerField.
     */
    public class BaseField extends Sprite
    {
        public var currentPointsForTest:int = 0;

        protected var _gameFinished:Boolean = false; //when GAME_FINISH event is executed
        protected var _gameCompletelyFinished:Boolean = false; //when finish popup is shown
        protected var _bouncer:Bouncer;
        protected var _outstandingRequests:OutstandingRequests = new OutstandingRequests();
        protected var _ballsManager:BallsManager;
        protected var _laserShotsManager:LaserShotsManager;
        protected var _started:Boolean = false;
        protected var _spellsPanel:SpellsPanel;
        protected var _view:BaseFieldView;
        protected var _fieldCells:FieldCells;
        protected var _freezer:Freezer;
        protected var _rocketLauncher:RocketLauncher;

        private var _startData:GameStartData;
        private var _playerData:PlayerData;
        private var _gameLink:Game;

        public function BaseField(startData:GameStartData, playerData:PlayerData, gameLink:Game)
        {
            _startData = startData;
            _playerData = playerData;
            _gameLink = gameLink;

            _view = new BaseFieldView();
            _view.playerInfo.fillFromPlayerData(playerData);
            setPosition();

            _freezer = new Freezer(GameConfig.FREEZER_SLOWDOWN_TIME, GameConfig.FREEZER_FREEZE_TIME);

            addEventListener(Event.ADDED_TO_STAGE, onAdded);
        }

        public function addPointsForTest(amount:int):void
        {
            currentPointsForTest += amount;
            trace("BaseField: addPoints: tick: " + ballsManager.currentTick + " now: " + currentPointsForTest + " amount: " + amount + (this is OpponentField ? " [opp] " : " [player] "));
        }

        protected function setPosition():void
        {
            x = 18;
            y = 129;
            _view.x = 18; //coordinates at Starling stage
            _view.y = 129; //coordinates at Starling stage
        }

        private function onAdded(event:Event):void
        {
            (Starling.current.root as StarlingLayer).gameFieldLayer.addChild(_view);

            _fieldCells = new FieldCells(_startData.mapsProgramData, this, _view.fieldCellsLayer);

            _ballsManager = new BallsManager(this, _startData.currentSpeed, _startData.testBallNumber, _view.ballsLayer);
            _ballsManager.addEventListener(RequestEvent.SPEED_UP, onSpeedUp);
            _ballsManager.addEventListener(RequestEvent.BALL_DEAD, onBallDead);

            _spellsPanel = new SpellsPanel(_playerData.panelConfiguration, this);
            addChild(_spellsPanel);

            _rocketLauncher = new RocketLauncher(this, _ballsManager);

            _bouncer = new Bouncer(_playerData.bouncerID);
            _bouncer.x = (GameConfig.FIELD_WIDTH_PX - GameConfig.BOUNCER_WIDTH) / 2;
            _bouncer.y = GameConfig.FIELD_HEIGHT_PX - GameConfig.BOUNCER_HEIGHT;
            _view.bouncerLayer.addChild(_bouncer);

            _laserShotsManager = new LaserShotsManager(_fieldCells, _bouncer, _view.laserBulletsLayer, this);

            var borderShadow:Sprite = new fieldbordershadow();
            addChild(borderShadow);
        }

        private function onBallDead(event:RequestEvent):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_LOST_BALL, {name: this.name, fromX: event.stuff.x + this.x, fromY: event.stuff.y + this.y}));
            _view.addChild(new MissPopup(event.stuff.x, event.stuff.y));
        }

        private function onSpeedUp(event:RequestEvent):void
        {
            _view.showSpeedUpFires();
        }

        protected function update():void
        {
            if (_freezer.state != Freezer.STATE_FULL_SPEED)
            {
                _freezer.update();
                _view.freezeOverlay.alpha = 1 - _freezer.coef;
            }

            _laserShotsManager.tick();
            _ballsManager.tick();
            _rocketLauncher.tick();

            if (_outstandingRequests.requests[currentTick]) //Game may become finished in the call before! (if FINISH_GAME request will execute)
            {
                executeRequest();
            }

            if (currentTick % OpponentField.SYNC_FREQUENCY == 0 && !_gameFinished) //send every 264ms (GlobalTimer is 33ms timer).
            {
                sendSyncMessage();
            }
        }

        public function gotoNewMap():void
        {
            _ballsManager.goStealth();
            _fieldCells.newMap();
        }

        public function updateSpellsPanel(panelConfig:Object):void
        {
            removeChild(_spellsPanel);
            _spellsPanel = new SpellsPanel(panelConfig, this);
            addChild(_spellsPanel);
        }

        public function doLaserShots():void
        {
            _laserShotsManager.shoot();
        }

        /**
         * Add new powerup requestID to queue. If target tick aint specified, requestID will be executed in next tick
         * @param requestID
         * @param requestData
         */
        public function addRequest(requestID:int, requestData:String = ""):void
        {
            _outstandingRequests.add(requestID, ballsManager.currentTick + 1, requestData);

            trace("BaseField : addRequest : " + requestID + " : " + requestData + " " + this);
        }

        protected function explodeBalls(targetBallsCount:int):void
        {
            BallSplitter.splitBalls(this, targetBallsCount);
        }

        /**
         * Used by both PlayerField (just using numberOfBricks) and by OpponentField (when lighting data is already specified)
         * @param numberOfBricks
         * @param lightningData
         * @return
         */
        protected function useLightning(numberOfBricks:int, lightningData:String = ""):String
        {
            return LightningEffect.strike(this, numberOfBricks, lightningData);
        }

        protected function dispatchShowCharmLightningsFromMe():void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_CHARM_LIGHTNINGS_FROM_ME, {fromField: this}));
        }

        protected function dispatchShowFreezingFromMe():void
        {
            trace("BaseField : dispatchShowFreezingFromMe : " + this);
            EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_PREFREEZE_FROM_ME, {fromField: this}));
        }

        public function showSmoke():void
        {
            _view.showSmoke();
        }

        public function goBouncyShield():void
        {
            _ballsManager.goBouncyShield();
        }

        /**
         * This func is called by other field when it executed ROCKET request.
         * Basically calling this func means "saying field to hit itself with a rocket"
         */
        public function launchRocket():void
        {
            trace("BaseField: launchRocket: ");
            _rocketLauncher.instaLaunchRocket();
        }

        public function finishGame():void
        {
            _gameFinished = true;
            _gameCompletelyFinished = true;
            _ballsManager.stopPathAnimations();
            _spellsPanel.onGameFinish();

            var darkeningThing:Shape = new Shape(); //thus popups "Player lost" & "Play again" - "Leave" will be above field-shader
            darkeningThing.graphics.beginFill(0, 0.7);
            darkeningThing.graphics.drawRect(0, 0, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);
            addChild(darkeningThing);
        }

        /**
         * Called when game is removed (e.g. when Playing Again / going to lobby)
         * Removing all the visual stuff from StarlingLayer, other links
         */
        public function cleanUp():void
        {
            _view.cleanUp();
            _ballsManager.cleanUp();
            _view.removeFromParent(true);
        }

        /**
         * Game timer finished on client; but there is no message from server yet
         * Turning off listening for bricks clearance,
         * fading balls out
         * Flush all executed requests / ticks buffers
         * GameFinish request closes the game
         */
        protected function stopPlaying():void
        {
            trace("Player " + this.name + " finished playing at... " + _ballsManager.currentTick + " points: " + _view.playerInfo.points);

            _gameFinished = true;
            _ballsManager.goStealth();
            sendSyncMessage();
            EventHub.dispatch(new RequestEvent(RequestEvent.PLAYER_FINISHED, this.name));
        }

        //Overriden in PLayerfield & OpponentField
        protected function executeRequest():void
        {
        }

        //what happens on timer tick is defferent in PlayerField & OppField and is described in those classes
        public function onTick():void
        {
        }

        //Overriden in PlayerField
        public function saveCriticalHit(bouncerX:Number):void
        {
        }

        //Overriden in PlayerField
        protected function sendSyncMessage():void
        {
        }

        public function get cellsGrid():Array
        {
            return _fieldCells.cells;
        }

        public function get allCells():Array
        {
            return _fieldCells.allCells;
        }

        public function get bouncer():Bouncer
        {
            return _bouncer;
        }

        public function get currentTick():int
        {
            return _ballsManager.currentTick;
        }

        public function get balls():Vector.<BallModel>
        {
            return _ballsManager.balls;
        }

        public function get ballsManager():BallsManager
        {
            return _ballsManager;
        }

        public function get gameFinished():Boolean
        {
            return _gameFinished;
        }

        public function get view():BaseFieldView
        {
            return _view;
        }

        public function get playerInfo():PlayerInfo
        {
            return _view.playerInfo;
        }

        public function get gameLink():Game
        {
            return _gameLink;
        }

        public function get freezer():Freezer
        {
            return _freezer;
        }

        public function get spellsPanel():SpellsPanel
        {
            return _spellsPanel;
        }
    }
}