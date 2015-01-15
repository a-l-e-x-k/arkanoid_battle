package view.game.rocket
{
    import events.RequestEvent;

    import caurina.transitions.Tweener;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Point;

    import model.constants.GameConfig;
    import model.game.ball.BallModel;
    import model.game.ball.BallsManager;

    import utils.Misc;
    import utils.MovieClipContainer;

    /**
     * ...
     * @author Alexey Kuznetsov
     */
    public final class RocketView extends MovieClipContainer
    {
        private const EASE:int = 7;
        private const MAX_SPEED:int = 11;
        private const SPEED_INCREASE_STEP:Number = 0.18;

        private var _ballsManager:BallsManager;
        private var _targetBall:BallModel;
        private var _speed:Number = 0;
        private var _currentRotation:Number;
        private var _currentX:Number;
        private var _currentY:Number;
        private var _particlesCount:int = 0; //remove event dispatches only when all smoke disappears
        private var _boom:MovieClip;
        private var _launched:Boolean = false;
        private var _exploded:Boolean = false;

        public function RocketView(xx:Number, yy:Number, ballsManager:BallsManager, color:uint)
        {
            super(new missilething());
            _ballsManager = ballsManager;
            _currentX = xx;
            _currentY = yy;
            _currentRotation = -90;
            updateMC();
            Misc.applyColorTransform(_mc.color_mc, color);
        }

        public function go():void //rocket starts movement
        {
            trace("RocketView: go: ");
            _launched = true;
        }

        public function update():void
        {
            if (_launched && _speed < MAX_SPEED)
            {
                trace("RocketView: update: changed speed: " + _speed);
                _speed += SPEED_INCREASE_STEP;
            }

            var targetPoint:Point = getTargetPoint();
            if (!_exploded && _speed > 0 && _targetBall) //if not after boom && started moving => may move && snake is not boosting and calling this func 2nd time
            {
                if (Math.abs(_currentX - _targetBall.x) <= GameConfig.BALL_RADIUS && Math.abs(_currentY - _targetBall.y) <= GameConfig.BALL_RADIUS)
                {
                    createBoom();
                }
                else
                {
                    var rot:Number = Math.atan2(targetPoint.y, targetPoint.x) * 180 / Math.PI;
                    if (Math.abs(rot - _currentRotation) > 180)
                    {
                        if (rot > 0 && _currentRotation < 0)
                        {
                            _currentRotation -= (360 - rot + _currentRotation) / EASE;
                        }
                        else if (_currentRotation > 0 && rot < 0)
                        {
                            _currentRotation += (360 + rot - _currentRotation) / EASE;
                        }
                    }
                    else if (rot < _currentRotation)
                    {
                        _currentRotation -= Math.abs(_currentRotation - rot) / EASE;
                    }
                    else
                    {
                        _currentRotation += Math.abs(rot - _currentRotation) / EASE;
                    }

                    var velocityX:Number = _speed * (90 - Math.abs(_currentRotation)) / 90;
                    var velocityY:Number;
                    if (_currentRotation < 0)
                    {
                        velocityY = -_speed + Math.abs(velocityX);
                    }
                    else
                    {
                        velocityY = _speed - Math.abs(velocityX);
                    }

                    _currentX += velocityX;
                    _currentY += velocityY;
                    updateMC();
                }

                updateTrail();
            }
        }

        private function getTargetPoint():Point
        {
            var p:Point = new Point();
            if (!_targetBall)
            {
                for each (var b:BallModel in _ballsManager.balls)
                {
                    if (!b.dead)
                    {
                        _targetBall = b;
                        break;
                    }
                }
            }

            if (_targetBall) //there still might not be any ball in a weird scenarios
            {
                p.x = _targetBall.x - _currentX;
                p.y = _targetBall.y - _currentY;
            }

            return p;
        }

        private function updateTrail():void
        {
            _particlesCount++;
            var particle:MovieClip = new smokeparticle();
            particle.x = _currentX + Misc.randomNumber(3);
            particle.y = _currentY + Misc.randomNumber(3);
            particle.rotation = Misc.randomNumber(360);
            particle.scaleX = particle.scaleY = ((Misc.randomNumber(50) / 100) + 0.5);
            particle.speed = (Misc.randomNumber(6) + 2) / 100;
            particle.alpha = 0.01;
            Tweener.addTween(particle, {alpha: 1, time: 0.3, delay: 0.1, transition: "linear", onComplete: function():void
            {
                particle.addEventListener(Event.ENTER_FRAME, onParticleEnterFrame);
            }}); //snake is not going from the head. Hence the tiny delay, so it looks like smoke from the tail
            addChild(particle);
        }

        private function onParticleEnterFrame(e:Event):void
        {
            e.currentTarget.scaleX += e.currentTarget.speed;
            e.currentTarget.scaleY += e.currentTarget.speed;
            e.currentTarget.alpha -= e.currentTarget.speed;
            if (e.currentTarget.alpha <= 0)
            {
                e.currentTarget.removeEventListener(Event.ENTER_FRAME, onParticleEnterFrame);
                removeChild(e.currentTarget as DisplayObject);
                _particlesCount--;
                if (_boom != null && _boom.parent != null) //remove firework animation even if it is not finished
                {
                    removeBoom();
                }
                if (_particlesCount == 0)
                {
                    dispatchEvent(new RequestEvent(RequestEvent.REMOVE_ME));
                }
            }
        }

        private function createBoom():void
        {
            trace("createBoom");
            dispatchEvent(new RequestEvent(RequestEvent.IMREADY));
            _boom = new firework();
            _boom.addEventListener(Event.ENTER_FRAME, onBoomEnter); //SnakeField will remove rocket
            _mc.alpha = 0;
            _exploded = true;
        }

        private function updateMC():void
        {
            _mc.rotation = _currentRotation;
            _mc.x = _currentX;
            _mc.y = _currentY;
        }

        private function onBoomEnter(e:Event):void
        {
            if (_boom.currentFrame == _boom.totalFrames) removeBoom();
        }

        private function removeBoom():void
        {
            _boom.removeEventListener(Event.ENTER_FRAME, onBoomEnter);
        }
    }
}