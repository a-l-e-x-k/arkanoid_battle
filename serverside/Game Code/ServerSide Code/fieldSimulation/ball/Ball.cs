using System;

namespace ServerSide
{
    public class Ball
    {
        private const int BALL_START_ANGLE = 55;
        private const int SPEED_UNIT = 3;
        private const int MIN_BOUNCEOFF_ANGLE = 40;
        private readonly FieldSimulation _fieldLink;

        private readonly MovementVector _movementVector = new MovementVector();
        private readonly BallWiggler _wiggler;
        private bool _dead;
        private bool _stealthMode;
        private double _x;
        private double _y;
        public bool isNPC;

        public Ball(FieldSimulation fieldLink)
        {
            _fieldLink = fieldLink;
            isNPC = fieldLink is NPCFieldSimulation;
            setVector(BALL_START_ANGLE);

            _wiggler = new BallWiggler(this);
        }

        /**
	 * Pass true if brick hit a wall (not a ceil and not a floor)
	 * @param hitWall
	 * @param hitPanelXPercent - how much to the right of left side of a panel ball hit a panel / panel width
	 */

        public bool goingLeft
        {
            get { return _movementVector.xComponent < 0; }
        }

        public bool goingDown
        {
            get { return _movementVector.yComponent < 0; }
        }

        public bool goingUp
        {
            get { return _movementVector.yComponent > 0; }
        }

        public bool goingRight
        {
            get { return _movementVector.xComponent > 0; }
        }

        public BallWiggler wiggler
        {
            get { return _wiggler; }
        }

        public bool dead
        {
            get { return _dead; }

            set { _dead = value; }
        }

        public bool stealthMode
        {
            get { return _stealthMode; }

            set { _stealthMode = value; }
        }

        public double x
        {
            get { return _x; }

            set { _x = value; }
        }

        public double y
        {
            get { return _y; }

            set { _y = value; }
        }

        public void bounceOff(bool hitWall, double hitPanelXPercent = -1)
        {
            if (hitWall)
                _movementVector.xComponent *= -1;
            else
                _movementVector.yComponent *= -1;

            //When ball hit left side of panel it'll go less to top & more to left.
            //When hit center it'll just bounce off.
            //When hit right it'll go more to the right & less to the top
            if (hitPanelXPercent != -1)
            {
                double adjustedPercent = Utils.floorWithPrecision(hitPanelXPercent, 2);
                double angle = Math.Ceiling(MIN_BOUNCEOFF_ANGLE + (180 - MIN_BOUNCEOFF_ANGLE*2)*(1 - adjustedPercent));
                setVector(angle);
                Tracer.t(
                    "adjustedPercent: " + adjustedPercent + " hitPanelXPercent: " + hitPanelXPercent +
                    " Angle on bounce off : " + angle + " x: " + _movementVector.xComponent + " y: " +
                    _movementVector.yComponent, isNPC ? Relations.NPC_FIELD : Relations.PLAYER_FIELD);
            }
        }

        public void updatePosition(int tickNum)
        {
            _x += (_movementVector.xComponent*SPEED_UNIT + _wiggler.currentShiftX)*_fieldLink.freezer.coef;
            _y -= (_movementVector.yComponent*SPEED_UNIT - _wiggler.currentShiftY)*_fieldLink.freezer.coef;

            _wiggler.tryUpdateShift();

            _x = Utils.floorWithPrecision(_x, 4);
            _y = Utils.floorWithPrecision(_y, 4);

            Tracer.t("new bp x: " + _x + " y: " + _y + " tickNum: " + tickNum, Relations.BALLS);
        }

        public void die()
        {
            _dead = true;
        }

        /**
		 * Entering mode at which ball ain't hittested against bricks.
		 * It happens during switching brick presets
		 */

        public void goStealth()
        {
            _stealthMode = true;
        }

        /**
		 * Exiting stealth mode so ball is hittested again.
		 * It happens when ball hits panel and is being at the stealth mode at the same time.
		 */

        public void goOutOfStealth()
        {
            _stealthMode = false;
        }

        public void goWiggle()
        {
            _wiggler.startWiggling();
        }

        public void stopWiggle()
        {
            _wiggler.stopWiggling();
        }

        public void setVector(double angle)
        {
            _movementVector.xComponent = Utils.ceilWithPrecision(Math.Cos(Utils.radians(angle)), 4);
            _movementVector.yComponent = Utils.ceilWithPrecision(Math.Sin(Utils.radians(angle)), 4);
        }

        public double getCurrentAngle()
        {
            double deg = Math.Atan2(_movementVector.yComponent, _movementVector.xComponent);
            if (deg < 0)
                deg += 2*Math.PI;

            return Utils.degrees(deg);
        }
    }
}