/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/19/12
 * Time: 10:14 PM
 * To change this template use File | Settings | File Templates.
 */
package model.timer
{
    import flash.utils.Timer;

    public class GlobalTimerOneSecond extends GlobalTimer
    {
        private static var _instance:Timer;

        public static function start():void
        {
            _instance = new Timer(1000);
            _instance.start();
        }

        public static function stop():void
        {
            _instance.reset();
        }

        public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            _instance.addEventListener(type, listener,useCapture,priority, useWeakReference);
        }

        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            _instance.removeEventListener(type, listener, useCapture);
        }

        public static function hasEventListener(type:String):Boolean
        {
            return _instance.hasEventListener(type);
        }

        public static function get currentCount():int
        {
            return _instance.currentCount;
        }
    }
}
