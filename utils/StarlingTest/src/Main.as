/**
 * Author: Alexey
 * Date: 10/13/12
 * Time: 2:42 PM
 */
package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import starling.core.Starling;

	import starling.core.Starling;
	import starling.events.Event;

	[SWF(width="774", height="605", backgroundColor="#000000", frameRate="60")]
	public class Main  extends Sprite
	{
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			Starling.handleLostContext = true;
			var starling:Starling = new Starling(TestLayer, stage);
			starling.addEventListener(Event.ROOT_CREATED, createMainView);
			starling.showStats = true;
			starling.start();
		}

		private function createMainView(event:Event):void
		{
			(Starling.current.root as TestLayer).createItems();
		}
	}
}
