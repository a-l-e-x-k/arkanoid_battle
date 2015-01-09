/**
 * Author: Alexey
 * Date: 11/11/12
 * Time: 12:24 AM
 */
package view.prewiggleEffect.boom
{
	import events.RequestEventStarling;

	import flash.utils.setTimeout;

	import model.animations.AnimationsManager;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class BoomEntity extends Sprite
	{
		private var mc:MovieClip;

		public function BoomEntity(xx:int, yy:int):void
		{
			this.x = xx - 18;
			this.y = yy - 18;
			mc = AnimationsManager.getAnimation(AnimationsManager.BOOM_SMOKE);
			mc.addEventListener(Event.ENTER_FRAME, checkForFinish);
			mc.stop();
			mc.play();
			addChild(mc);
			Starling.juggler.add(mc);
		}

		private function checkForFinish(event:Event):void
		{
			if (mc.currentFrame == mc.numFrames - 5)
			{
				trace("BoomEntity : checkForFinish :  around finish. Left: " + (mc.numFrames - mc.currentFrame).toString());
				Starling.juggler.remove(mc);
				mc.stop();
				mc.removeEventListener(Event.ENTER_FRAME, checkForFinish);
				mc.removeFromParent(true);
				dispatchEvent(new RequestEventStarling(RequestEventStarling.IMREADY));
			}
		}
	}
}
