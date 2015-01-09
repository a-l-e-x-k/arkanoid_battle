/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/21/13
 * Time: 8:43 PM
 * To change this template use File | Settings | File Templates.
 */
package model.game.laser
{
    import model.StarlingTextures;

    import starling.display.Image;
    import starling.display.Sprite;

    public class LaserBullet
    {
        private var _x:Number;
        private var _y:Number;
        public var view:Image;
        public var dead:Boolean = false;

        public function LaserBullet(viewParent:Sprite)
        {
            view = new Image(StarlingTextures.getTexture(StarlingTextures.LASER_BULLET));
            viewParent.addChild(view);
        }

        public function upateCoordinates(xx:Number, yy:Number):void
        {
            _x = xx;
            _y = yy;
            view.x = _x;
            view.y = _y;
        }

        public function die():void
        {
            removeView();
            dead = true;
        }

        public function get x():Number
        {
            return _x;
        }

        public function get y():Number
        {
            return _y;
        }

        private function removeView():void
        {
            if (view.parent != null && view.parent.contains(view))
                view.removeFromParent(true);
        }
    }
}
