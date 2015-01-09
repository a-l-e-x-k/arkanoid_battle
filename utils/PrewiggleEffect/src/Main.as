/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:13 AM
 */
package
{
	import com.demonsters.debugger.MonsterDebugger;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	[SWF(width="774", height="605", backgroundColor="#000000", frameRate="60")]
	public class Main extends Sprite
	{
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			MonsterDebugger.initialize(this);
		}

		private function onAdded(event:Event):void
		{
			PrewiggleEffectManager.setFields([], this);

			var testField:BaseField = new BaseField();
			var panel:Point = new Point(150, 550);
			PrewiggleEffectManager.showWiggle(testField, panel);

			addEventListener(Event.ENTER_FRAME, function(e:Event):void  //update
			{
				if (PrewiggleEffectManager.counter == 300) //5 sec
				{
					PrewiggleEffectManager.showBoom(testField, testField.balls);
				}
				else if (PrewiggleEffectManager.counter < 300)
				{
					testField.moveBalls();
					PrewiggleEffectManager.update(testField.balls, panel);
				}
			});
		}
	}
}
