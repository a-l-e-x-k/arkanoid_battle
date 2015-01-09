using System;

namespace ServerSide
{
    public class BallWiggler
    {
        private readonly Ball _ballLink;
        private double _currentPerpendicularAngle;
        private double _currentShiftX;
        private double _currentShiftY;
        private double _currentStepNumber;
        private bool _wiggling;

        public BallWiggler(Ball ballModel)
        {
            _ballLink = ballModel;
        }

        public bool wiggling
        {
            get { return _wiggling; }
        }

        public double currentShiftX
        {
            get { return _currentShiftX; }
            set { _currentShiftX = value; }
        }

        public double currentShiftY
        {
            get { return _currentShiftY; }
            set { _currentShiftY = value; }
        }

        public double currentPerpendicularAngle
        {
            get { return _currentPerpendicularAngle; }
            set { _currentPerpendicularAngle = value; }
        }

        public double currentStepNumber
        {
            get { return _currentStepNumber; }
            set { _currentStepNumber = value; }
        }

        public void tryUpdateShift()
        {
            if (_wiggling)
            {
                double angleBefore = _currentPerpendicularAngle;
                _currentPerpendicularAngle = (-_ballLink.getCurrentAngle() + 180) + 90; //(get perpendicular)

                if (_currentPerpendicularAngle != angleBefore) //update
                    reset();

                double currentShiftPercent =
                    Math.Sin((Math.PI*2)*(_currentStepNumber/GameConfig.WIGGLER_WAVE_LENGTH_IN_TICKS)); //from 0 to 1
                double currentShiftSize = GameConfig.WIGGLER_WAVE_HEIGHT*currentShiftPercent;

                _currentShiftX = currentShiftSize*Math.Cos(Utils.radians(_currentPerpendicularAngle));
                _currentShiftY = currentShiftSize*Math.Sin(Utils.radians(_currentPerpendicularAngle));
                _currentStepNumber++;
            }
        }

        private void reset()
        {
            _currentShiftX = 0;
            _currentShiftY = 0;
            _currentStepNumber = 0;
        }

        public void startWiggling()
        {
            _wiggling = true;
        }

        public void stopWiggling()
        {
            reset();
            _wiggling = false;
        }
    }
}