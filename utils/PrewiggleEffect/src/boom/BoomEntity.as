/**
 * Author: Alexey
 * Date: 11/11/12
 * Time: 12:24 AM
 */
package boom
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class BoomEntity extends MovieClip
	{
		private var anim:MovieClip;

		//TODO: use recording
		public function BoomEntity(xx:int, yy:int):void
		{
            return;
			//anim = new wiggleSmoke();
			anim.em.particle = SL_SmokeHQParticle;
			anim.x = xx;
			anim.y = yy;
			addChild(anim);


			setTimeout(onAnimationFinished, 3000);
		}

		private function onAnimationFinished():void
		{
            return;
			anim.em.stop(false, true);
			anim.em.killParticles(); //This resets the emitter to the defaults and purges the pool
			removeChild(anim);
			dispatchEvent(new Event(Event.COMPLETE));  //TODO: substitute for RequestEvent
		}
	}
}
