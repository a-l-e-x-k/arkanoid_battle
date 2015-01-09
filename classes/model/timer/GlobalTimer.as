/**
 * Author: Alexey
 * Date: 5/19/12
 * Time: 3:28 PM
 */
package model.timer
{
import flash.utils.Timer;

public class GlobalTimer
{
	private static var _instance:Timer;

	public static function start():void
	{
        _instance = new Timer(33.33);
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