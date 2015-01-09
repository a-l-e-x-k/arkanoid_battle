package model.game.missile
{
    import events.RequestEvent;

    import flash.display.Sprite;

    import model.constants.GameConfig;

    import model.game.ball.BallsManager;

    import view.game.rocket.RocketView;

    /**
     * ...
     * @author Alexey Kuznetsov
     */
    public final class RocketLauncher
    {
        private const ROCKET_LAUNCH_X:int = 15;
        private const ROCKET_LAUNCH_Y:int = GameConfig.FIELD_HEIGHT_PX - 30;

        private var _rockets:Array = [];
        private var _rocketLayer:Sprite;
        private var _awaitingRocket:RocketView;
        private var _ballsManager:BallsManager;

        public function RocketLauncher(rocketLayer:Sprite, ballsManager:BallsManager)
        {
            _rocketLayer = rocketLayer;
            _ballsManager = ballsManager;
        }

        public function showPreLaunch():void
        {
            _awaitingRocket = createRocket();
        }

        public function instaLaunchRocket():void
        {
            trace("RocketLauncher: instaLaunchRocket: " + _awaitingRocket);
            if (_awaitingRocket)
            {
                _awaitingRocket.go();
            }
            else
            {
                var r:RocketView = createRocket();
                r.go();
            }
        }

        private function createRocket(color:uint = 0xFF0000):RocketView
        {
            trace("RocketLauncher: createRocket: ");
            var rocket:RocketView = new RocketView(ROCKET_LAUNCH_X, ROCKET_LAUNCH_Y, _ballsManager, color);
            rocket.addEventListener(RequestEvent.REMOVE_ME, removeRocket);
            _rockets.push(rocket);
            _rocketLayer.addChild(rocket);
            return rocket;
        }

        public function tick():void
        {
            for each (var m:RocketView in _rockets)
            {
                m.update();
            }
        }

        private function removeRocket(e:RequestEvent):void
        {
            trace("removeRocket" + e.currentTarget.name);
            e.currentTarget.removeEventListener(RequestEvent.IMREADY, removeRocket);
            _rocketLayer.removeChild(e.currentTarget as RocketView);
            _rockets.splice(_rockets.indexOf(e.currentTarget), 1);
        }
    }
}