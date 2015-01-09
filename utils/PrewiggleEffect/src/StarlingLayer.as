/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:16 AM
 */
package
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class StarlingLayer extends Sprite
	{
		public function StarlingLayer()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(event:Event):void
		{

		}
	}
}
