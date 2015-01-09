/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 1/9/13
 * Time: 5:16 PM
 * To change this template use File | Settings | File Templates.
 */
package view.game.field
{
    import external.bouncyShield.physics.Particle;

    import flash.geom.Vector3D;

    import model.constants.GameConfig;

    import model.game.ball.BallModel;

    /**
     * Magnet attached to ball model
     */
    public class BouncyMagnet extends Particle
    {
        private var _ballLink:BallModel;
        public var attractions:Array = []; //array of links to attractions between this magnet and other water particles

        public function BouncyMagnet(ball:BallModel, mass:Number, position:Vector3D = null)
        {
            super(mass, position);
            _ballLink = ball;
        }

        public function get ballLink():BallModel
        {
            return _ballLink;
        }

        public function updatePosition():void
        {
            position.x = _ballLink.x;
            position.y = _ballLink.y - _ballLink.fieldLink.ballsManager.bouncyShield.y - 55 + GameConfig.BOUNCER_WATER_DEPTH;
        }
    }
}
