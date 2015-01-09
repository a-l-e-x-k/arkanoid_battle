/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:02 AM
 */
package view.prewiggleEffect
{
	import events.RequestEvent;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	import view.game.field.BaseField;

	public class PrewiggleEffectManager
	{
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

		public static function showLightnings(toField:BaseField, fromField:BaseField):void
		{
			if (!(_dictionary[toField] is PrewiggleEffect)) //if not currently running effect
			{
				var effect:PrewiggleEffect = new PrewiggleEffect(toField, fromField);
				effect.update();
				effect.addEventListener(RequestEvent.EFFECT_FINISHED, onEffectComplete);
				_placeToRender.addChild(effect);
				_dictionary[toField] = effect;
			}
			else
				trace("This toField is currently under effect!");
		}

		private static function onEffectComplete(event:RequestEvent):void
		{
			event.currentTarget.removeEventListener(RequestEvent.EFFECT_FINISHED, onEffectComplete);
			for (var field:Object in _dictionary)
			{
				if (_dictionary[field] == event.currentTarget)
				{
					_dictionary[field] = true; //"delete" effect
				}
			}
			trace("Effect comp;leted");
		}

		public static function showBoom(field:BaseField):void
		{
			if (_dictionary[field] is PrewiggleEffect)
				(_dictionary[field] as PrewiggleEffect).showBoom();
		}

		public static function update():void
		{
			for (var field:Object in _dictionary) //update all fields under effects
			{
				if (_dictionary[field] is PrewiggleEffect) //IOW, if there is an effect for this field currently playing
				{
					(_dictionary[field] as PrewiggleEffect).update();
				}
			}
		}

		public static function clear():void
		{
			while (_placeToRender.numChildren > 0)
			{
				_placeToRender.removeChildAt(0);
			}

			_dictionary = new Dictionary();
		}
	}
}
