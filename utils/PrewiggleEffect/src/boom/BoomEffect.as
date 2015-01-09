/**
 * Author: Alexey
 * Date: 11/11/12
 * Time: 12:21 AM
 */
package boom
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class BoomEffect extends MovieClip
	{
		private var _boomThingies:Array = [];
		private var _completedCount:int = 0;

		public function BoomEffect(ballsCoords:Vector.<BallModel>)
		{
			for each (var ball:BallModel in ballsCoords)
			{
				var boomThingy:BoomEntity = new BoomEntity(ball.x, ball.y);
				boomThingy.addEventListener(Event.COMPLETE, onThingyComplete); //TODO: substitute for RequestEvent
				addChild(boomThingy);
				_boomThingies.push(boomThingy);
			}
		}

		private function onThingyComplete(event:Event):void
		{
			_completedCount++;
			if (_completedCount == _boomThingies.length)
				onComplete();
		}

		private function onComplete():void
		{
			for (var i:int = 0; i < _boomThingies.length; i++)
			{
				removeChild(_boomThingies[i]);
				_boomThingies.splice(i, 1);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}
