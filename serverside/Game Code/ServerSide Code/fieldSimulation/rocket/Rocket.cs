using System;

namespace ServerSide
{
    public class Rocket
    {
        private const int EASE = 13;
        private const int MAX_SPEED = 11;
        private const double SPEED_INCREASE_STEP = 0.18;

        private readonly BallsManager _ballsManager;
        private double _currentRotation;
        private double _currentX;
        private double _currentY;
        private bool _exploded;
        private bool _launched;
        private int _particlesCount = 0; //remove event dispatches only when all smoke disappears
        private double _speed;
        private Ball _targetBall;

        public Rocket(double xx, double yy, BallsManager ballsManager)
        {
            _ballsManager = ballsManager;
            _currentRotation = -90;
            _currentX = xx;
            _currentY = yy;
        }

        public event EventHandler Exploded;

        public void go() //rocket starts movement
        {
            _launched = true;
        }

        public void update()
        {
            if (_launched && _speed < MAX_SPEED)
            {
                _speed += SPEED_INCREASE_STEP;
            }

            Point targetPoint = getTargetPoint();
            if (!_exploded && _speed > 0 && _targetBall != null)
                //if not after boom && started moving => may move && snake is not boosting and calling this func 2nd time
            {
                if (Math.Abs(_currentX - _targetBall.x) <= GameConfig.BALL_RADIUS &&
                    Math.Abs(_currentY - _targetBall.y) <= GameConfig.BALL_RADIUS)
                {
                    createBoom();
                }
                else
                {
                    double rotation = Math.Atan2(targetPoint.y, targetPoint.x)*180/Math.PI;
                    if (Math.Abs(rotation - _currentRotation) > 180)
                    {
                        if (rotation > 0 && _currentRotation < 0)
                        {
                            _currentRotation -= (360 - rotation + _currentRotation)/EASE;
                        }
                        else if (_currentRotation > 0 && rotation < 0)
                        {
                            _currentRotation += (360 + rotation - _currentRotation)/EASE;
                        }
                    }
                    else if (rotation < _currentRotation)
                    {
                        _currentRotation -= Math.Abs(_currentRotation - rotation)/EASE;
                    }
                    else
                    {
                        _currentRotation += Math.Abs(rotation - _currentRotation)/EASE;
                    }

                    double velocityX = _speed*(90 - Math.Abs(_currentRotation))/90;
                    double velocityY = 0;
                    if (_currentRotation < 0)
                    {
                        velocityY = -_speed + Math.Abs(velocityX);
                    }
                    else
                    {
                        velocityY = _speed - Math.Abs(velocityX);
                    }

                    _currentX += velocityX;
                    _currentY += velocityY;
                }
            }
        }

        private Point getTargetPoint()
        {
            var p = new Point();
            if (_targetBall == null)
            {
                foreach (Ball b in _ballsManager.balls)
                {
                    if (!b.dead)
                    {
                        _targetBall = b;
                        break;
                    }
                }
            }

            if (_targetBall != null) //there still might not be any ball in a weird scenarios
            {
                p.x = _targetBall.x - _currentX;
                p.y = _targetBall.y - _currentY;
            }

            return p;
        }

        private void createBoom()
        {
            _exploded = true;
            EventHandler handler = Exploded; //other guy will receive some spoints
            if (handler != null)
                handler(this, EventArgs.Empty);
        }
    }
}