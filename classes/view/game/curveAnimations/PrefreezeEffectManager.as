/**
 * Author: Alexey
 * Date: 11/24/12
 * Time: 11:21 PM
 */
package view.game.curveAnimations
{
	import events.RequestEventStarling;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	import model.constants.GameConfig;

	import starling.display.DisplayObjectContainer;

	import view.game.field.BaseField;

	public class PrefreezeEffectManager
	{
		[Embed(source="../../../../assets/snowflakeParticle/particle.pex", mimeType="application/octet-stream")]
		private static var snowflakeParticleXML:Class;

		[Embed(source="../../../../assets/snowflakeParticle/texture.png")]
		private static var snowflakeParticleTexture:Class;

		private static var _animations:Dictionary = new Dictionary();
		private static var _placeToRender:DisplayObjectContainer;

		public static function init(placeToRender:DisplayObjectContainer):void
		{
			_placeToRender = placeToRender;
		}

		public static function createAnimation(fromField:BaseField, targetField:BaseField):void
		{
			var fromPoint:Point = new Point(fromField.x, fromField.y);
			var toPoint:Point = new Point(targetField.x + (GameConfig.FIELD_WIDTH_PX / 2), targetField.y + (GameConfig.FIELD_HEIGHT_PX / 2));
			var anim:PrefreezeAnimation = new PrefreezeAnimation(snowflakeParticleXML, snowflakeParticleTexture, fromPoint, toPoint, targetField);
			anim.setEmitterPosition(fromField.x, fromField.y);
			anim.addEventListener(RequestEventStarling.IMREADY, removeAnimation); //dispatched when anim may be not updated anymore
			_placeToRender.addChild(anim);
			_animations[fromField] = anim;
		}

		private static function removeAnimation(event:RequestEventStarling):void
		{
			for (var fromField:Object in _animations)
			{
				if (_animations[fromField] == event.currentTarget)
				{
					delete _animations[fromField];
					_animations[fromField] = null;
				}
			}
		}

		public static function update():void
		{
			for (var fromField:Object in _animations)
			{
				if (_animations[fromField] is PrefreezeAnimation)
				{
					var fromX:int = (fromField as BaseField).x + (fromField as BaseField).bouncer.x + GameConfig.BOUNCER_WIDTH / 2;
					var fromY:int = (fromField as BaseField).y + (fromField as BaseField).bouncer.y + GameConfig.BOUNCER_WIDTH / 2;
					(_animations[fromField] as PrefreezeAnimation).setEmitterPosition(fromX, fromY);
				}
			}
		}

		public static function tryStopAnimation(targetField:BaseField):void
		{
			for (var fromField:Object in _animations)
			{
				if (_animations[fromField] is PrefreezeAnimation)
				{
					if ((_animations[fromField] as PrefreezeAnimation).targetField == targetField)
					{
						(_animations[fromField] as PrefreezeAnimation).stop();
					}
				}
			}
		}

		public static function clear():void
		{
			for (var fromField:Object in _animations)
			{
				if (_animations[fromField] is PrefreezeAnimation)
				{
					(_animations[fromField] as PrefreezeAnimation).stop();
					(_animations[fromField] as PrefreezeAnimation).removeEventListener(RequestEventStarling.IMREADY, removeAnimation);
					delete _animations[fromField];
					_animations[fromField] = null;
				}
			}

			while (_placeToRender.numChildren > 0)
			{
				_placeToRender.removeChildAt(0);
			}

			_animations = new Dictionary();
		}
	}
}
