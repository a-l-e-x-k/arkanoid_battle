/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 1/7/13
 * Time: 11:44 PM
 * To change this template use File | Settings | File Templates.
 */
package view.game.field
{
    import external.bouncyShield.CubicBezier;
    import external.bouncyShield.physics.Particle;
    import external.bouncyShield.physics.ParticleSystem;
    import external.caurina.transitions.Tweener;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import model.constants.GameConfig;
    import model.game.ball.BallModel;

    public class BouncyShield extends Sprite
    {
        //TODO: make bouncer non-Starling. This would allow it to be on top of this bouncy shield
        //Make shield shady thing on the sides (simple shadow border) non-Starling as well.

        private const ATTRACTION_STRENGTH:int = -500;
        private const MIN_ATTRACTION_DISTANCE:int = 0;
        private const MAGNET_PARTICLE_MASS:int = 20;
        private const BALL_MASS:int = 20;
        private const SKY_AND_EARTH_PARTICLE_MASS:int = 1;
        private const WATER_PARTICLE_MASS:Number = 0.1;
        private const PARTICLES_COUNT:int = 25;
        private const BALL_TO_WATER_ATTRACTION:int = -2000;
        private const WATER_WIDTH:int = GameConfig.FIELD_WIDTH_PX;
        private const WATER_COLOR:uint = 0x00CCFF;

        private var s:ParticleSystem;
        private var waterParticles:Array;
        private var sky:Array;
        private var earth:Array;
        private var _magnets:Dictionary = new Dictionary(); //magnet - ballModel association
        private var points:Array;
        private var water:Sprite = new Sprite();
        private var _ballsLink:Vector.<BallModel>;
        private var _panelMagnet:Particle;
        private var _on:Boolean; //if on - then shield is protecting
        private var _alphaFadedIn:Boolean;
        private var _currentTick:int;

        private var _tweenStartTime:Number; //in UNIX milliseconds
        private var _lastUpdateTime:Number; //in UNIX milliseconds

        public function BouncyShield(balls:Vector.<BallModel>)
        {
            _ballsLink = balls;
        }

        public function start():void
        {
            if (!s)
            {
                createWorld();
            }

            _on = true;
            _alphaFadedIn = false;
            _currentTick = 0;
            _tweenStartTime = getTimer();
            Tweener.addTween(water, {alpha: 0.8, time: 0.78, transition: "easeOutSine", onComplete: function ():void
            {
                _alphaFadedIn = true;
            }});
        }

        private function createWorld():void
        {
            s = new ParticleSystem(new Vector3D(0, 0, 0), .2);
            sky = [];
            waterParticles = [];
            earth = [];
            points = [];

            var xStep:Number = WATER_WIDTH / PARTICLES_COUNT;

            for (var i:int = 0; i <= PARTICLES_COUNT; i++)
            {
                sky[i] = s.makeParticle(SKY_AND_EARTH_PARTICLE_MASS, new Vector3D(i * xStep, 100, 0));
                sky[i].makeFixed();
                waterParticles[i] = s.makeParticle(WATER_PARTICLE_MASS, new Vector3D(i * xStep, 200, 0));
                earth[i] = s.makeParticle(SKY_AND_EARTH_PARTICLE_MASS, new Vector3D(i * xStep, 300, 0));
                earth[i].makeFixed();
                if (i > 0)
                {
                    s.makeSpring(waterParticles[i - 1], waterParticles[i], 0.1, .05, 0);
                    s.makeSpring(sky[i], waterParticles[i], 0.05, .05, 0);
                    s.makeSpring(earth[i], waterParticles[i], 0.05, .05, 0);
                }
            }
            waterParticles[0].makeFixed();
            waterParticles[PARTICLES_COUNT].makeFixed();
            addChild(water);
            water.alpha = 0.8;

            _panelMagnet = s.makeParticle(MAGNET_PARTICLE_MASS, new Vector3D(0, 0, 0));
            for each (var waterParticle:Particle in waterParticles)
            {
                s.makeAttraction(_panelMagnet, waterParticle, ATTRACTION_STRENGTH, MIN_ATTRACTION_DISTANCE);
            }
            _panelMagnet.makeFixed();
            _panelMagnet.position.y = 120;//190;
        }

        /**
         * Called by BallsManager on game tick
         */
        public function update():void

        {
            if (_on) //on is being set to true when spell is executed
            {
                updateMagnets();

                s.tick(1);
                drawWater();

                _currentTick++;
                if (_alphaFadedIn)
                {
                    _lastUpdateTime = getTimer();
                    water.alpha = Tweener.transitionList["easeinexpo"](_currentTick, 1, -1, GameConfig.BOUNCY_SHIELD_LENGTH);
                }
                if (_currentTick == GameConfig.BOUNCY_SHIELD_LENGTH)
                {
                    _on = false;
                }
            }
        }

        private function updateMagnets():void
        {
            var ballExists:Boolean;
            for each (var b:BallModel in _ballsLink)
            {
                ballExists = false;
                for (var ma:* in _magnets)
                {
                    if ((ma as BouncyMagnet).ballLink == b) //no magnet for this ball
                    {
                        ballExists = true;
                        break;
                    }
                }

                if (!ballExists)
                {
                    createBallMagnet(b);
                }
            }

            var mag:BouncyMagnet;
            var total:int;
            for (var m:* in _magnets) //go through all magnets and delete dead balls
            {
                mag = m as BouncyMagnet;
                if (mag.ballLink.dead)
                {
                    total = mag.attractions.length;
                    for (var a:int = 0; a < total; a++)
                    {
                        s.removeAttractionByReference(mag.attractions[a]);
                    }
                    _magnets[m] = null; //nullify ball link
                    delete _magnets[m]; //delete "magnet" from dictionary
                }
                else
                {
                    mag.updatePosition();
                }
            }

            _panelMagnet.position.x = mouseX;
        }

        private function drawWater():void
        {
            water.graphics.clear();
            water.graphics.beginFill(WATER_COLOR);
            for (var i:String in waterParticles)
            {
                points[i] = new Point(waterParticles[i].position.x, waterParticles[i].position.y);
            }
            CubicBezier.curveThroughPoints(water.graphics, points);
            water.graphics.lineTo(points[0].x, stage.stageHeight - 50);
            water.graphics.lineTo(points[PARTICLES_COUNT].x, points[PARTICLES_COUNT].y);
            water.graphics.lineTo(points[PARTICLES_COUNT].x, stage.stageHeight - 50);
            water.graphics.lineTo(points[0].x, stage.stageHeight - 50);
        }

        public function createBallMagnet(ball:BallModel):void
        {
            var magnet:BouncyMagnet = new BouncyMagnet(ball, BALL_MASS, new Vector3D(0, 0, 0));
            s.particles.push(magnet); //that is instead of s.makeParticle(...)
            for each (var waterParticle:Particle in waterParticles)
            {
                magnet.attractions.push(s.makeAttraction(magnet, waterParticle, BALL_TO_WATER_ATTRACTION, 0));
            }
            magnet.makeFixed();
            _magnets[magnet] = ball;
        }

        public function get on():Boolean
        {
            return _on;
        }
    }
}
