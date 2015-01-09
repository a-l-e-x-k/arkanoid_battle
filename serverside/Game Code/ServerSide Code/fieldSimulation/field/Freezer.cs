using System;

namespace ServerSide
{
    public class Freezer
    {
        public const int STATE_FULL_SPEED = 0;
        public const int STATE_SLOWING_DOWN = 1;
        public const int STATE_FROZEN = 2;
        public const int STATE_SPEEDING_UP = 3;
        private readonly double _freezeTime;
        private readonly double _slowdownTime;

        private double _coef = 1; //1 -> no slowdown, 0 -> all stopped

        //Needed to make those 3 vars below double. Otherwise deviding one of them on another automatically results in int
        private double _currentTick; //using Game ticks (approx. 30 times per second)
        private int _state = STATE_FULL_SPEED;

        public Freezer(int slowdownTime, int freezeTime)
        {
            _slowdownTime = slowdownTime;
            _freezeTime = freezeTime;
        }

        public double coef
        {
            get { return _coef; }
        }

        public double state
        {
            get { return _state; }
        }

        public void update()
        {
            if (_state == STATE_FULL_SPEED)
            {
                Console.WriteLine(
                    "Freezer : update : That's bad! Don't call update on completely unfrozen Freezer. Returning...");
                return;
            }

            _currentTick++;

            if (_state == STATE_SLOWING_DOWN)
            {
                double percent = _currentTick/_slowdownTime;
                _coef = 1 - Utils.floorWithPrecision(percent, 4);
                if (_currentTick == _slowdownTime) //slowdown complete, now we are frozen
                {
                    _state = STATE_FROZEN;
                }
            }
            else if (_state == STATE_SPEEDING_UP)
            {
                double cycleLength = _slowdownTime + _freezeTime + _slowdownTime;
                _coef = Utils.floorWithPrecision((_currentTick - _slowdownTime - _freezeTime)/_slowdownTime, 4);
                    //how much time passed since speed up started / speed up length
                if (_currentTick == cycleLength) //cycle finished, we are at full speed now
                {
                    _state = STATE_FULL_SPEED;
                    _currentTick = 0;
                    _coef = 1;
                }
            }
            else if (_currentTick == (_slowdownTime + _freezeTime)) //enough being frozen, speed up now
            {
                _state = STATE_SPEEDING_UP;
            }
        }

        public void freeze()
        {
            _state = STATE_SLOWING_DOWN;
        }
    }
}