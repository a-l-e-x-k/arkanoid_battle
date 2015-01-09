/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:06 AM
 */
package view.prewiggleEffect
{
	import events.RequestEvent;
	import events.RequestEventStarling;

	import flash.display.Sprite;
	import flash.geom.Rectangle;

	import model.constants.GameConfig;

	import view.game.field.BaseField;
	import view.prewiggleEffect.boom.BoomEffect;

	public class PrewiggleEffect extends Sprite
	{
		private const STATE_NONE:int = -1;
		private const STATE_LIGHTNINGS:int = 0;
		private const STATE_BOOM:int = 1;

		private var _state:int = STATE_NONE;
		private var _lightningsGroup:SmartLightningGroup;
		private var _boomEffect:BoomEffect;

		private var _toField:BaseField;
		private var _fromField:BaseField;

		public function PrewiggleEffect(toField:BaseField, fromField:BaseField)
		{
			_toField = toField;
			_fromField = fromField;
		}

		public function showBoom():void
		{
			if (_state == STATE_LIGHTNINGS)
			{
				_state = STATE_BOOM;
				_lightningsGroup.cleanUp();
				removeChild(_lightningsGroup);
				_boomEffect = new BoomEffect(_toField.balls);
				_boomEffect.clipRect = new Rectangle(_toField.view.x, _toField.view.y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);  // masks boom clouds' excesses
				_boomEffect.addEventListener(RequestEventStarling.IMREADY, onBoomComplete);
				_toField.view.addChild(_boomEffect);
			}
			else
				trace("PrewiggleEffect : showBoom : Can't show. Wrong state: " + _state);
		}

		private function onBoomComplete(event:RequestEventStarling):void
		{
			trace("PrewiggleEffect : onBoomComplete : ");
			_boomEffect.removeEventListener(RequestEventStarling.IMREADY, onBoomComplete);
			_toField.view.removeChild(_boomEffect);
			dispatchEvent(new RequestEvent(RequestEvent.EFFECT_FINISHED));
		}

		public function update():void
		{
			if (_state == STATE_NONE)
			{
				createLightningsGroup();
				_state = STATE_LIGHTNINGS; //play lightnings effect at first
			}

			if (_state == STATE_LIGHTNINGS) //it is the only time update is needed. BOOM is played by itself
				updateLightnings();
		}

		private function createLightningsGroup():void
		{
			_lightningsGroup = new SmartLightningGroup();
			addChild(_lightningsGroup);
		}

		private function updateLightnings():void
		{
			_lightningsGroup.update(_toField, _fromField);
		}
	}
}
