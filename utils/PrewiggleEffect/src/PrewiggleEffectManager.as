/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:02 AM
 */
package
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class PrewiggleEffectManager
	{
		private static var _counter:int = 0; //anti-high FPS.
		private static var _dictionary:Dictionary = new Dictionary();
		private static var _placeToRender:DisplayObjectContainer;

		public static function setFields(fields:Array, placeToRender:DisplayObjectContainer):void
		{
			_placeToRender = placeToRender;

			for each (var f:BaseField in fields)
			{
				_dictionary[f] = true; //simply fill dictionary in
			}
		}

		public static function showWiggle(field:BaseField, panelCoords:Point):void
		{
			if (!(_dictionary[field] is PrewiggleEffect)) //if not currently running effect
			{
				var effect:PrewiggleEffect = new PrewiggleEffect();
				effect.update(field.balls, panelCoords);
				effect.addEventListener(Event.COMPLETE, onEffectComplete);
				_placeToRender.addChild(effect);
				_dictionary[field] = effect;
			}
			else
				trace("This field is currently under effect!");
		}

		private static function onEffectComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onEffectComplete);
			trace("Effect comp;leted");
		}

		public static function showBoom(field:BaseField, balls:Vector.<BallModel>):void
		{
			_counter++;                                  //so wont show again
			if (_dictionary[field] is PrewiggleEffect)
				(_dictionary[field] as PrewiggleEffect).showBoom(balls);
		}

		public static function update(balls:Vector.<BallModel>, panelCoords:Point):void
		{
			_counter++;
			if (_counter % 3 != 0) //simulate 20 FPS (assuming game runs at 60 FPS)
				return;

			for each (var prewiggleEffect:PrewiggleEffect in _dictionary)
			{
				prewiggleEffect.update(balls, panelCoords)
			}
		}

		public static function clear():void
		{
			while (_placeToRender.numChildren > 0)
				_placeToRender.removeChildAt(0);

			_dictionary = new Dictionary();
		}

		public static function get counter():int
		{
			return _counter;
		}
	}
}
