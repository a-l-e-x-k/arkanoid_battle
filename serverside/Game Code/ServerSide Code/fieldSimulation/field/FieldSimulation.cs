using System;
using System.Collections;
using System.Collections.Generic;

namespace ServerSide
{
    public class FieldSimulation
    {
        protected OutstandingRequests _awaitingRequests = new OutstandingRequests();
            //these are requests which wait for client to tell at which tick to execute them. And if not executed within 10 sec they are forced to execute and crush everything :)

        protected BallsManager _ballsManager;
        private int _currentCritHitNumber;

        private Dictionary<int, double> _currentCriticalHits;
            //is set when calling simulateEightTicks() func, then when BallHitTester says that ball is in inCriticalArea is called which uses this var to set panel x

        protected Freezer _freezer;
        protected LaserShotsManager _laserShotsManager;
        protected OutstandingRequests _outstandingRequests = new OutstandingRequests();
        protected RocketLauncher _rocketLauncher;
        public Bouncer bouncer = new Bouncer();
        public FieldCells fieldCells;
        public Player playerLink;
        public ArrayList requestsExecutedAt8Ticks;

        public FieldSimulation(string mapsProgram, Player plLink)
        {
            playerLink = plLink;
            _ballsManager = new BallsManager(this);
            _ballsManager.lostBall += onLostBall;

            _rocketLauncher = new RocketLauncher(_ballsManager);

            fieldCells = new FieldCells(mapsProgram, playerLink.roomLink);
            fieldCells.cellCleared += onCellCleared;
            fieldCells.fieldCleared += onFieldCleared;

            _laserShotsManager = new LaserShotsManager(fieldCells, bouncer, this);
            _freezer = new Freezer(GameConfig.FREEZER_SLOWDOWN_TIME, GameConfig.FREEZER_FREEZE_TIME);
        }

        public BallsManager ballsManager
        {
            get { return _ballsManager; }
        }

        public OutstandingRequests outstandingRequests
        {
            get { return _outstandingRequests; }
        }

        public OutstandingRequests awaitingRequests
        {
            get { return _awaitingRequests; }
        }

        public Freezer freezer
        {
            get { return _freezer; }
        }

        public event EventHandler FieldCleared;
        public event EventHandler BallLost;
        public event EventHandler CellCleared;
        public event EventHandler GameFinished;

        public void simulateEightTicks(string criticalHits, string executedRequestsData)
        {
            requestsExecutedAt8Ticks = new ArrayList();
            parseCriticalHits(criticalHits);
            if (criticalHits != "")
                Console.WriteLine("[Received critical hits]: " + criticalHits);

            if (executedRequestsData.Length > 0)
                _outstandingRequests.addFromString(executedRequestsData);

            for (int i = 0; i < 8; i++)
            {
                setExactBouncerPosition();
                    //if there was crit hit postion will be updated. Otherwise it will be left the same

                if (_freezer.state != Freezer.STATE_FULL_SPEED)
                    _freezer.update();

                _laserShotsManager.tick();
                _ballsManager.moveBalls();

                if (tryExecuteOutstandingRequest()) //if ture, then game finished. Period
                    return;

                if (_awaitingRequests.requests.ContainsKey(_ballsManager.currentTick)) //force execution
                {
                    executeRequest(_awaitingRequests.requests[_ballsManager.currentTick], true);
                    _awaitingRequests.requests.Remove(_ballsManager.currentTick);
                }
            }
        }

        protected bool tryExecuteOutstandingRequest(bool force = false)
        {
            bool gameFinishRequest = false;
            if (_outstandingRequests.requests.ContainsKey(_ballsManager.currentTick))
            {
                GameRequestData req = _outstandingRequests.requests[_ballsManager.currentTick];
                gameFinishRequest = req.requestID == GameRequest.GAME_FINISH;

                //Commented down so that game runs on the Free Playerio plan (not paying for services for now)
                //if (playerLink.spellUseCounter.beforeUsage(req.requestID)) //note that request id here is pretty much any game request
                //{
                executeRequest(req, force);
                //}
                //else //using lightings / splitter when such usage was not allowed before (on tryUseSpell() in Game class)
                //	playerLink.roomLink.PlayerIO.ErrorLog.WriteError("Unexpected spell usage! RequestID: " + req.requestID + " userID: " + playerLink.realID);				

                _outstandingRequests.requests.Remove(_ballsManager.currentTick);
            }
            return gameFinishRequest;
        }

        private void onFieldCleared(object sender, EventArgs args)
        {
            Tracer.t("FieldSimulation::  field cleared", Relations.PLAYER_FIELD);
            EventHandler handler = FieldCleared;
            if (handler != null)
                handler(this, EventArgs.Empty);
        }

        private void executeRequest(GameRequestData reqData, bool force = false)
        {
            string result = "";

            switch (reqData.requestID)
            {
                case GameRequest.SPEED_UP:
                    speedUp(reqData, force);
                    result = _ballsManager.currentSpeed.ToString();
                    break;
                case GameRequest.NEW_MAP:
                    switchPreset(reqData, force);
                    break;
                case GameRequest.SPLIT_BALL_IN_TWO:
                    explodeBalls(2);
                    break;
                case GameRequest.SPLIT_BALL_IN_THREE:
                    explodeBalls(3);
                    break;
                case GameRequest.LIGHTNING_ONE:
                    fieldCells.hitLightning(1, reqData.data);
                    result = reqData.data;
                        //goes into requestsExecutedAt8Ticks and this stuff broadcasts to other players
                    break;
                case GameRequest.LIGHTNING_TWO:
                    fieldCells.hitLightning(2, reqData.data);
                    result = reqData.data;
                    break;
                case GameRequest.LIGHTNING_THREE:
                    fieldCells.hitLightning(3, reqData.data);
                    result = reqData.data;
                    break;
                case GameRequest.CHARM_BALLS:
                    goWiggle(reqData, force);
                    break;
                case GameRequest.FREEZE:
                    goFreeze(reqData, force);
                    break;
                case GameRequest.BOUNCY_SHIELD:
                    ballsManager.goBouncyShield();
                    break;
                case GameRequest.LASER_SHOTS:
                    _laserShotsManager.shoot();
                    break;
                case GameRequest.ROCKET:
                    goLaunchRocket(reqData, force);
                    break;
            }

            Console.WriteLine("[Request executed] at: " + ballsManager.currentTick + " request: " + reqData.requestID +
                              " spell name: " + GameRequest.getSpellNameByRequest(reqData.requestID) + " reqData: " +
                              reqData.data + " Result: " + result +
                              (this is NPCFieldSimulation ? " [NPC] " : "[Player]"));

            requestsExecutedAt8Ticks.Add(reqData.requestID + ":" + _ballsManager.currentTick + ":" + result);

            if (reqData.requestID == GameRequest.GAME_FINISH)
                finishGame();
        }

        private void finishGame()
        {
            Console.WriteLine("Player finished playing at... " + _ballsManager.currentTick);
            EventHandler handler = GameFinished;
            handler(this, EventArgs.Empty);
        }

        private void speedUp(GameRequestData reqData, bool force)
        {
            if (!force)
                //get safe awaiting request with all valuable request data. Only receiving tick number from client
            {
                GameRequestData awaitingRequest = getAndRemoveAwaitingRequest(reqData);
                _ballsManager.currentSpeed = Convert.ToInt16(awaitingRequest.data);
            }
            else //force execution
                _ballsManager.currentSpeed = Convert.ToInt16(reqData.data);

            Console.WriteLine("speedUp " + (this is NPCFieldSimulation ? " NPC " : " player") + " to: " +
                              _ballsManager.currentSpeed + " at " + _ballsManager.currentSpeed);
        }

        private void switchPreset(GameRequestData reqData, bool force)
        {
            if (!force)
                //get safe awaiting request with all valuable request data. Only receiving tick number from client
            {
                GameRequestData awaitingRequest = getAndRemoveAwaitingRequest(reqData);
                gotoNewMap();
            }
            else //force execution
                gotoNewMap();

            Console.WriteLine("switchPreset " + (this is NPCFieldSimulation ? " NPC " : " player"));
        }

        private void goWiggle(GameRequestData reqData, bool force)
        {
            if (!force)
                //get safe awaiting request with all valuable request data. Only receiving tick number from client
            {
                GameRequestData awaitingRequest = getAndRemoveAwaitingRequest(reqData);
            }

            _ballsManager.goWiggle();
        }

        private void goFreeze(GameRequestData reqData, bool force)
        {
            if (!force)
                //get safe awaiting request with all valuable request data. Only receiving tick number from client
            {
                GameRequestData awaitingRequest = getAndRemoveAwaitingRequest(reqData);
            }

            _freezer.freeze();
        }

        private void goLaunchRocket(GameRequestData reqData, bool force)
        {
            Console.WriteLine("goLaunchRocket: force: " + force);
            if (!force)
                //get safe awaiting request with all valuable request data. Only receiving tick number from client
            {
                GameRequestData awaitingRequest = getAndRemoveAwaitingRequest(reqData);
            }

            _rocketLauncher.instaLaunchRocket();
        }

        private GameRequestData getAndRemoveAwaitingRequest(GameRequestData reqData)
        {
            var ar = new GameRequestData(-1, "abrakadabra");
            foreach (int key in _awaitingRequests.requests.Keys)
            {
                if (_awaitingRequests.requests[key].requestID == reqData.requestID)
                    //found first request with ID which was requested
                {
                    ar = _awaitingRequests.requests[key];
                    _awaitingRequests.requests.Remove(key);
                    break;
                }
            }
            if (ar.requestID == -1 && reqData.requestID != 1)
                //there was a problem with switch map request. Skipping it for now
                throw new Exception("Did not found target awaiting request");
            return ar;
        }

        private void explodeBalls(int targetBallsCount)
        {
            BallSplitter.splitBalls(this, targetBallsCount);
        }

        private void onLostBall(object sender, EventArgs args)
        {
            EventHandler handler = BallLost;
            if (handler != null)
                handler(this, EventArgs.Empty);
        }

        private void parseCriticalHits(string info)
        {
            _currentCritHitNumber = 0;
            _currentCriticalHits = new Dictionary<int, double>();

            //so we have dict with possible keys from 0 to 7 (8 ticks within chunk)
            //if there were no crit hit at certain tick bouncer position just will not be updated

            if (info.Length > 0)
            {
                string[] hits = info.Split(new[] {','});
                string[] critHit;
                int tickNumberWithinChunk;
                double critHitPosition;
                for (int i = 0; i < hits.Length; i++)
                {
                    critHit = hits[i].Split(new[] {':'});
                    tickNumberWithinChunk = Convert.ToInt16(critHit[0]);
                    critHitPosition = Convert.ToDouble(critHit[1]);
                    _currentCriticalHits[tickNumberWithinChunk] = critHitPosition;
                }
            }
        }

        private void gotoNewMap()
        {
            fieldCells.newMap();
            _ballsManager.goStealth();
        }

        private void onCellCleared(object sender, EventArgs args)
        {
            EventHandler handler = CellCleared;
            handler(this, args);
        }

        /**
         * There is a little bit of difference between how it happens here and on client.
         * Here we have dictionary of (max) 8 items and get hit data by 0-7 key
         * At client there is a queue of tick bouncer positions (either "" or some data) - approach is different, it is real-time simulation and not 8 ticks instantly
         **/

        protected virtual void setExactBouncerPosition()
        {
            if (_currentCriticalHits.ContainsKey(_currentCritHitNumber))
            {
                //if there is no crit hit for that tick, no need to update panel position
                bouncer.x = _currentCriticalHits[_currentCritHitNumber];
            }
            _currentCritHitNumber++;
        }

        public virtual void saveCriticalHitForNPC()
        {
            //used by NPC only, saving & sending only those ticks at which ball was hit / missed by bouncer (very differnet from Opponent field at client)
        }
    }
}