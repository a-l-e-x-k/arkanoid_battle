/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 3/2/13
 * Time: 7:45 PM
 * To change this template use File | Settings | File Templates.
 */
package model.sound
{
    public class SoundAsset
    {
        public static const BOUNCER_HIT:String = "bouncerHit/button-3.mp3";
        public static const BOUNCER_HIT_1:String = "bouncerHit/button-9.mp3";
        public static const BRICK_HIT:String = "brickHit/pop finger.mp3";
        public static const BRICK_HIT_1:String = "brickHit/pop.mp3";
        public static const FREEZE:String = "freeze/Ice crackling 02 thin ice louder.mp3";
        public static const LASER:String = "laser/Laser 04.mp3";
        public static const LASER_1:String = "laser/Shoot 1.wav";
        public static const LASER_2:String = "laser/Shoot.wav";
        public static const LIGHTNING:String = "lightning/Spark 1.mp3";
        public static const LIGHTNING_1:String = "lightning/Spark.mp3";
        public static const MUSIC_LOOP:String = "Funk Game Loop.mp3";
        public static const MISSED_BOUNCER:String = "missedBouncer/blorp.mp3";
        public static const SPLIT:String = "split/Sword hit.mp3";
        public static const SPEED_UP:String = "speedUp/Jump.mp3";
        public static const WATER:String = "water/wet splat.mp3";
        public static const WIGGLE:String = "wiggle/crazy.mp3";

        public static const BOUNCER_SOUNDS:Array = [BOUNCER_HIT, BOUNCER_HIT_1];
        public static const BRICK_SOUNDS:Array = [BRICK_HIT, BRICK_HIT_1];
        public static const FREEZE_SOUNDS:Array = [FREEZE];
        public static const LASER_SOUNDS:Array = [LASER, LASER_1, LASER_2];
        public static const LIGHTNING_SOUNDS:Array = [LIGHTNING, LIGHTNING_1];

        /**
         * For asset loading
         * @return
         */
        public static function getAllSoundsNames():Array
        {
            var r:Array = [];
            r = r.concat(BOUNCER_SOUNDS, BRICK_SOUNDS, FREEZE_SOUNDS, LASER_SOUNDS, LIGHTNING_SOUNDS);
            r.push(BOUNCER_HIT, SPLIT, WATER, WIGGLE, MISSED_BOUNCER, SPEED_UP);
            return r;
        }
    }
}
