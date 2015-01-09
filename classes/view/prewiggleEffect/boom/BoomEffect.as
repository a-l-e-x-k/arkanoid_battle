/**
 * Author: Alexey
 * Date: 11/11/12
 * Time: 12:21 AM
 */
package view.prewiggleEffect.boom
{
	import events.RequestEventStarling;

	import model.game.ball.BallModel;
	import model.constants.GameConfig;

	import starling.extensions.ClippedSprite;

	public class BoomEffect extends ClippedSprite
	{
		private var _boomThingies:Array = [];
		private var _completedCount:int = 0;

		public function BoomEffect(balls:Vector.<BallModel>)
		{
			for each (var ball:BallModel in balls)
			{
				var boomThingy:BoomEntity = new BoomEntity(ball.x + GameConfig.BALL_RADIUS, ball.y + GameConfig.BALL_RADIUS);
				boomThingy.addEventListener(RequestEventStarling.IMREADY, onThingyComplete);
				addChild(boomThingy);
				_boomThingies.push(boomThingy);
			}
		}

		private function onThingyComplete(e:RequestEventStarling):void
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
			dispatchEvent(new RequestEventStarling(RequestEventStarling.IMREADY));
		}
	}
}
