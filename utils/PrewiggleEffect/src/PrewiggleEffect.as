/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:06 AM
 */
package
{
    import boom.BoomEffect;

    import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class PrewiggleEffect extends Sprite
	{
		private const STATE_NONE:int = -1;
		private const STATE_LIGHTNINGS:int = 0;
		private const STATE_BOOM:int = 1;

		private var _state:int = STATE_NONE;
		private var _lightningsGroup:SmartLightningGroup;
		private var _boomEffect:BoomEffect;

		public function PrewiggleEffect()
		{
		}

		public function showBoom(ballsCoords:Vector.<BallModel>):void
		{
			if (_state == STATE_LIGHTNINGS)
			{
				_state = STATE_BOOM;
				_lightningsGroup.cleanUp();
				removeChild(_lightningsGroup);
				_boomEffect = new BoomEffect(ballsCoords);
				_boomEffect.addEventListener(Event.COMPLETE, onBoomComplete);
				addChild(_boomEffect);
			}
			else
				trace("PrewiggleEffect : showBoom : Can't show. Wrong state: " + _state);
		}

		private function onBoomComplete(event:Event):void
		{
			_boomEffect.removeEventListener(Event.COMPLETE, onBoomComplete);
			removeChild(_boomEffect);
			dispatchEvent(new Event(Event.COMPLETE)); //TODO: substitute for RequestEvent
		}

		public function update(balls:Vector.<BallModel>, panelCoordinates:Point):void
		{
			if (_state == STATE_NONE)
			{
				createLightningsGroup();
				_state = STATE_LIGHTNINGS; //play lightnings effect at first
			}

			if (_state == STATE_LIGHTNINGS) //it is the only time update is needed. BOOM is played by itself
				updateLightnings(balls, panelCoordinates);
		}

		private function createLightningsGroup():void
		{
			_lightningsGroup = new SmartLightningGroup();
			addChild(_lightningsGroup);
		}

		private function updateLightnings(balls:Vector.<BallModel>, panelCoordinates:Point):void
		{
			_lightningsGroup.update(balls, panelCoordinates);
		}
	}
}
