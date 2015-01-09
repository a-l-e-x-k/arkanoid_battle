package
{
    import com.demonsters.debugger.MonsterDebugger;

    import events.RequestEvent;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.*;
    import flash.geom.Rectangle;

    import model.GameVersionController;
    import model.PopupsManager;
    import model.QualityManager;
    import model.ServerTalker;
    import model.animations.AnimationsManager;
    import model.constants.Maps;
    import model.game.gameStart.GameStarter;
    import model.lobby.MapsPreviewsCache;
    import model.shop.ShopItemsInfo;
    import model.sound.SoundAssetManager;
    import model.spells.PreviewsLoader;
    import model.timer.GlobalTimer;
    import model.timer.GlobalTimerOneSecond;
    import model.userData.Spells;
    import model.userData.UserData;

    import networking.special.ViralEvent;

    import playerio.Connection;
    import playerio.Message;

    import starling.core.Starling;
    import starling.events.ResizeEvent;

    import utils.EventHub;
    import utils.snapshoter.SnapshotManager;
    import utils.snapshoter.Snapshoter;

    import view.MainView;
    import view.StarlingLayer;

    /**
     * ...
     * @author Alexey Kuznetsov
     */

    [SWF(width="774", height="605", backgroundColor="#ffffff", frameRate="60")]
    public class Main extends Sprite
    {
        private var _animManagerReady:Boolean = false;
        private var _networkingReady:Boolean = false;

        private var _view:MainView;

        /**
         * Initialisation flow:
         * 1. Starling is created
         * 2. Managers initialisaed
         * 3. When Starlinf fully inited MainView is created and LoginPopup is shown
         * 4. When user is done with LoginPopup InitManagerMultiplayer does connection
         * 5. When connected to Playerio and Client is obtained CONNECTED_TO_PLAYERIO event is dispatched
         * 6. This class inits Networing & listeners and waits till Networking will finish all the connecting business
         * 7. When all of networking business is done lobby view is created
         */
        public function Main():void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.addEventListener(ResizeEvent.RESIZE, resizeStage);

            Starling.handleLostContext = true;
            var starly:Starling = new Starling(StarlingLayer, stage);
            starly.addEventListener(starling.events.Event.ROOT_CREATED, createMainView);
            starly.start();

            MonsterDebugger.initialize(this);
//			SnapshotManager.init(stage, Spells.LIGHTNING_THREE);
//			Snapshoter.setRectangle(12, 123, 374, 525); //manually set area (Player field)
//            Snapshoter.setRectangle(395, 123, 759, 524); //manually set area (Opponent field)

            EventHub.addEventListener(RequestEvent.ANIMATIONS_MANAGER_READY, onAnimManagerReady);
            EventHub.addEventListener(ViralEvent.CONNECTED_TO_PLAYERIO, onConnectedToPlayerio);
            UserData.initListeners(); //will listen to energy updates, bouncers purchase, etc
            AnimationsManager.init();
            QualityManager.init(stage);
            GlobalTimer.start(); //will be used instead of event.enter_frame stuff (anti-cheat, stable)
            GlobalTimerOneSecond.start();
            Maps.init(); //maps codes dictionary
            MapsPreviewsCache.init(); //creates previews of all maps for Maps popup
            ShopItemsInfo.init(); //creates array of shop items VO
            GameStarter.init(); //subscribe to game start related events
        }

        private static function receviedAuthData(event:ViralEvent):void
        {
            var m:Message = event.stuff as Message;
            UserData.energy = m.getInt(0);
            UserData.energyNextUpdate = m.getNumber(1);
        }

        private function resizeStage(e:Event):void
        {
            var w:int = Math.min(Config.APP_WIDTH, stage.stageWidth);
            var h:int = Math.min(Config.APP_HEIGHT, stage.stageHeight);
            var viewPortRectangle:Rectangle = new Rectangle();
            viewPortRectangle.width = w;
            viewPortRectangle.height = h;
            Starling.current.viewPort = viewPortRectangle;
            Starling.current.stage.stageWidth = w;
            Starling.current.stage.stageHeight = h;
        }

        private function createMainView(e:starling.events.Event):void
        {
            _view = new MainView();
            addChild(_view);

            GameVersionController.init(_view);
            PopupsManager.showLoginWindow();
        }

        private function onConnectedToPlayerio(event:ViralEvent):void
        {
            Starling.current.showStats = true;
            Starling.current.mStatsDisplay.y = 48; //stats position

            ServerTalker.setClient(event.stuff.client);
            UserData.uid = event.stuff.client.connectUserId; //name is equal to uid now (login / nickname)
            UserData.name = UserData.nameFromUid(UserData.uid);

            if (!_networkingReady) //first login. NOT the situation when player loging from guest mode
            {
                EventHub.addEventListener(ViralEvent.START_DATA_LOADED, startupDataReady);
                EventHub.addEventListener(ViralEvent.CONNECTED_TO_PLAYERIO_ROOM, onConnectedToRoom);
                EventHub.addEventListener(ViralEvent.RECEIVED_AUTH_DATA, receviedAuthData);
                EventHub.addEventListener(ViralEvent.PLAYER_OBJECT_LOADED, onPlayerObjectLoaded);
                PreviewsLoader.init(); //start loading spells spells
            }
            else //need to set to false because of logging in from guest mode
            {
                _networkingReady = false;
            }
        }

        private static function onPlayerObjectLoaded(event:ViralEvent):void
        {
            if (event.stuff.firstTime)
            {
                UserData.setDefaults();
            }
            else
            {
                UserData.fromPayVault(ServerTalker.client.payVault);
                UserData.fromPlayerObject(event.stuff.obj);
            }
        }

        private static function onConnectedToRoom(event:ViralEvent):void
        {
            ServerTalker.setServiceConnection(event.stuff as Connection);
        }

        private function onAnimManagerReady(event:RequestEvent):void
        {
            trace("Main: onAnimManagerReady: ");

            _animManagerReady = true;
            tryStart();
        }

        private function startupDataReady(e:ViralEvent):void
        {
            trace("Main: startupDataReady: ");
            _networkingReady = true;
            tryStart();
        }

        private function tryStart():void
        {
            trace("anim: " + _animManagerReady + " net: " + _networkingReady);

            if (_animManagerReady && _networkingReady)
            {
                SoundAssetManager.init(); //start loading sounds if they are needed (soundsOn / musicOn is set to true). Initing here so player can disable music & sounds from topbar
                _view.init();
            }
        }
    }
}