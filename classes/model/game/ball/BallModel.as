/**
 * Author: Alexey
 * Date: 5/19/12
 * Time: 2:51 PM
 */
package model.game.ball
{
    import model.game.panel.MovementVector;

    import starling.display.DisplayObjectContainer;

    import utils.Misc;

    import view.game.ball.*;
    import view.game.field.BaseField;
    import view.game.field.PlayerField;

    /**
     * Class uses cirle with radius = 1 to calculate x & y components of movement vector.
     */

    public class BallModel
    {
        public static const SPEED_UNIT:int = 3;
        private const BALL_START_ANGLE:int = 55;
        private const MIN_BOUNCEOFF_ANGLE:int = 40;

        private var _movementVector:MovementVector = new MovementVector();
        private var _dead:Boolean;
        private var _preciseX:Number = 0;
        private var _preciseY:Number = 0;
        private var _stealthMode:Boolean = false;
        private var _view:BallView;
        private var _wiggler:BallWiggler;
        private var _fieldLink:BaseField;

        /**
         * @param x
         * @param y
         * @param parent To which DisplayObject ball should be added
         * @param fieldLink
         */
        public function BallModel(x:Number, y:Number, parent:DisplayObjectContainer, fieldLink:BaseField)
        {
            _fieldLink = fieldLink;
            _preciseX = x;
            _preciseY = y;

            setVector(BALL_START_ANGLE);

            _view = new BallView();
            _view.updateCoordinates(_preciseX, _preciseY, 1);
            _view.updateAngle(BALL_START_ANGLE);
            parent.addChild(_view);

            _wiggler = new BallWiggler(this);
        }

        /**
         * Pass true if brick hit a wall (not a ceil and not a floor)
         * @param hitWall
         * @param hitPanelXPercent - how much to the right of left side of a bouncer ball hit a bouncer / bouncer width
         */
        public function bounceOff(hitWall:Boolean, hitPanelXPercent:Number = -1):void
        {
            if (hitWall)
            {
                _movementVector.xComponent *= -1;
            }
            else
            {
                _movementVector.yComponent *= -1;
            }

            //When ball hit left side of bouncer it'll go less to top & more to left.
            //When hit center it'll just bounce off.
            //When hit right it'll go more to the right & less to the top
            if (hitPanelXPercent != -1)
            {
                var adjustedPercent:Number = Misc.floorWithPrecision(hitPanelXPercent, 2);
                var angle:Number = Math.ceil(MIN_BOUNCEOFF_ANGLE + (180 - MIN_BOUNCEOFF_ANGLE * 2) * (1 - adjustedPercent));
                setVector(angle);
                traceme("adjustedPercent: " + adjustedPercent + " hitPanelXPercent: " + hitPanelXPercent + " Angle on bounce off : " + angle + " x: " + _movementVector.xComponent + " y: " + _movementVector.yComponent, _view.parent.parent is PlayerField ? Relations.PLAYER_FIELD : Relations.OPPONENT_FIELD)
            }

            _view.updateAngle(getCurrentAngle());
        }

        public function die():void
        {
            _dead = true;
        }

        public function destroyView():void
        {
            _view.cleanUp();
            _view.removeFromParent(true);
            _view = null;
        }

        /**
         * Entering mode at which ball ain't hittested against bricks.
         * It happens during switching brick presets
         */
        public function goStealth():void
        {
            _stealthMode = true;
            _view.goStealth();
        }

        /**
         * Exiting stealth mode so ball is hittested again.
         * It happens when ball hits bouncer and is being at the stealth mode at the same time.
         */
        public function goOutOfStealth():void
        {
            _stealthMode = false;
            _view.goOutOfStealth();
        }

        public function goWiggle():void
        {
            _wiggler.startWiggling();
            _view.hidePath();
        }

        public function stopWiggle():void
        {
            _wiggler.stopWiggling();
            _view.showPath();
        }

        public function updatePosition():void
        {
            _preciseX += (_movementVector.xComponent * SPEED_UNIT + _wiggler.currentShiftX) * _fieldLink.freezer.coef;
            _preciseY -= (_movementVector.yComponent * SPEED_UNIT - _wiggler.currentShiftY) * _fieldLink.freezer.coef;

            /**
             * X & Y coordinates get rounded by next 0.05th of a pixel (by Flash).
             * But we still need super-precise X & Y values for sync with server
             */
            _preciseX = Misc.floorWithPrecision(_preciseX, 4);
            _preciseY = Misc.floorWithPrecision(_preciseY, 4);

            _view.updateCoordinates(_preciseX, _preciseY, _fieldLink.freezer.coef);

            _wiggler.tryUpdateShift();
        }

        public function setVector(angle:Number):void
        {
            _movementVector.xComponent = Misc.ceilWithPrecision(Math.cos(radians(angle)), 4);
            _movementVector.yComponent = Misc.ceilWithPrecision(Math.sin(radians(angle)), 4);
        }

        public function getCurrentAngle():Number
        {
            var deg:Number = Math.atan2(_movementVector.yComponent, _movementVector.xComponent);
            if (deg < 0)
            {
                deg += 2 * Math.PI;
            }

            return degrees(deg);
        }

        private static function radians(degrees:Number):Number
        {
            return degrees * Math.PI / 180;
        }

        private static function degrees(radians:Number):Number
        {
            return radians * 180 / Math.PI;
        }

        public function get goingDown():Boolean
        {
            return _movementVector.yComponent < 0;
        }

        public function get goingUp():Boolean
        {
            return _movementVector.yComponent > 0;
        }

        public function get goingLeft():Boolean
        {
            return _movementVector.xComponent < 0;
        }

        public function get goingRight():Boolean
        {
            return _movementVector.xComponent > 0;
        }

        /**
         * Thus real ball x will be received and not the one which is messed up by shadows & effects
         */
        public function get x():Number
        {
            return _preciseX;
        }

        /**
         * Thus real ball y will be received and not the one which is messed up by shadows & effects
         */
        public function get y():Number
        {
            return _preciseY;
        }

        public function get dead():Boolean
        {
            return _dead;
        }

        public function resetY(number:Number):void
        {
            _preciseY = number;
            _view.updateCoordinates(_preciseX, _preciseY, _fieldLink.freezer.coef);
        }

        public function get stealthMode():Boolean
        {
            return _stealthMode;
        }

        public function set dead(value:Boolean):void
        {
            _dead = value;
        }

        public function get path():BallPath
        {
            return _view.path;
        }

        public function set stealthMode(value:Boolean):void
        {
            _stealthMode = value;
        }

        public function get view():BallView
        {
            return _view;
        }

        public function get wiggler():BallWiggler
        {
            return _wiggler;
        }

        public function get fieldLink():BaseField
        {
            return _fieldLink;
        }
    }
}
