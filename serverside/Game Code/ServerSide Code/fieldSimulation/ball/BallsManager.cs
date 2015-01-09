using System;
using System.Collections;

namespace ServerSide
{
    public class BallsManager
    {
        public const int TEST_BALLS_NUMBER = 1; //thats for testing only
        private readonly ArrayList _balls = new ArrayList();
        private readonly BouncyShield _bouncyShield;
        private readonly FieldSimulation _fieldLink;

        private bool _allBallsLaunched;
        private int _currentSpeed;
        private int _currentTick; //how many 30ms intervals passed and were simulated
        private int _wigglesLeft;

        public EventHandler lostBall;

        public BallsManager(FieldSimulation fieldLink)
        {
            _fieldLink = fieldLink;
            _bouncyShield = new BouncyShield();
        }

        public int currentTick
        {
            get { return _currentTick; }
        }

        public int currentSpeed
        {
            get { return _currentSpeed; }
            set { _currentSpeed = value; }
        }

        public ArrayList balls
        {
            get { return _balls; }
        }

        public void createBall()
        {
            var ball = new Ball(_fieldLink);
                //NB! setting x & y after initiating. Because here, when passed to constructor ball x & y were rounded o_O
            ball.x = _fieldLink.bouncer.x + (_fieldLink.bouncer.currentWidth - GameConfig.BALL_SIZE)*0.7;
                //setting ball a lil bit to the right (because it's bouncing w angle)
            ball.y = _fieldLink.bouncer.y - GameConfig.BALL_SIZE - 1;
            Console.WriteLine((_fieldLink is NPCFieldSimulation ? " [NPC] " : " [Player] ") + "Ball at: " + ball.x +
                              " : " + ball.y + " current tick: " + currentTick);
            _balls.Add(ball);
        }

        public void moveBalls()
        {
            tryCreateStartBall();

            _bouncyShield.update();

            ArrayList ballsToRemove;
            for (int j = 0; j < _currentSpeed; j++)
            {
                ballsToRemove = new ArrayList();

                foreach (Ball ball in _balls)
                {
                    ball.updatePosition(_currentTick);
                    BallHitTester.hitTest(ball, _fieldLink, _bouncyShield.on);
                    if (ball.dead) //died during performing 1px moves
                    {
                        ballsToRemove.Add(ball);
                    }
                }

                foreach (Ball ball in ballsToRemove)
                {
                    removeBall(ball);
                }
            }

            _currentTick++;

            if (_wigglesLeft > 0)
            {
                _wigglesLeft--;
                if (_wigglesLeft == 0)
                    stopWiggle();
            }
        }

        public void goStealth()
        {
            foreach (Ball ball in _balls)
            {
                ball.goStealth();
                    //balls will go out of stealth when hitting panel (ensuring they won't conflict with new preset)
            }
        }

        public void goWiggle()
        {
            if (_wigglesLeft == 0)
            {
                foreach (Ball ball in _balls)
                {
                    ball.goWiggle();
                }
            }

            _wigglesLeft += GameConfig.WIGGLE_LENGTH;
        }

        public void goBouncyShield()
        {
            _bouncyShield.start();
        }

        private void stopWiggle()
        {
            foreach (Ball ball in _balls)
            {
                if (ball.wiggler.wiggling)
                    ball.stopWiggle();
            }
        }

        private void removeBall(Ball ball)
        {
            _balls.Remove(ball);
            Tracer.t("Removed ball. Left: " + _balls.Count + (_fieldLink is NPCFieldSimulation ? "[NPC]" : "[PLAYER]"),
                Relations.MISC_EVENTS);
            EventHandler handler = lostBall;
            handler(this, EventArgs.Empty);

            if (_balls.Count == 0)
                createBall();
        }

        private void tryCreateStartBall()
        {
            if (!_allBallsLaunched)
            {
                if (_currentTick%10 == 0 && _balls.Count < TEST_BALLS_NUMBER)
                {
                    createBall();

                    if (_balls.Count == TEST_BALLS_NUMBER)
                        _allBallsLaunched = true;
                }
            }
        }
    }
}