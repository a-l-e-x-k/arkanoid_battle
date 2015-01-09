package utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Trying to remove event dispatching duties from application.
	 * TODO: try to refactor from statics to regular instance
	 */
	public class EventHub extends EventDispatcher
	{
		private static var _instance:EventHub = new EventHub();


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

		public static function dispatch(event:Event):Boolean
		{
			return _instance.dispatchEvent(event);
		}


	}
}
