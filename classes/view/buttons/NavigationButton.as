package view.buttons
{
	import external.caurina.transitions.Tweener;
	import events.RequestEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class NavigationButton extends MovieClipContainer 
	{
		public static const HEIGHT:int = 37;
		public var shown:Boolean = true;
		private static const PASSIVE_ALPHA:Number = 0.3;
		private static const ACTIVE_ALPHA:Number = 0.8;
		
		public function NavigationButton(child:MovieClip, xx:Number, yy:Number) 
		{
			super(child, xx, yy);			
			addListeners();			
			_mc.alpha = PASSIVE_ALPHA;			
			buttonMode = true;
		}
		
		private function onRollOut(e:MouseEvent = null):void 
		{
			Tweener.addTween(_mc, { alpha:PASSIVE_ALPHA, time:0.5, transition:"easeOutSine" } );
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			Tweener.addTween(_mc, { alpha:ACTIVE_ALPHA, time:0.5, transition:"easeOutSine" } );
		}		
		
		public function show():void 
		{
			shown = true;
			Tweener.addTween(_mc, { alpha:PASSIVE_ALPHA, time:0.3, transition:"easeOutSine" } );
			addListeners();
		}
		
		public function hide():void 
		{
			shown = false;
			Tweener.addTween(_mc, { alpha:0, time:0.3, transition:"easeOutSine" } );
			removeListeners();
		}		
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.CLICK, dispachClick);
		}		
		
		protected function removeListeners():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			removeEventListener(MouseEvent.CLICK, dispachClick);
		}
		
		private function dispachClick(e:MouseEvent):void 
		{
			dispatchEvent(new RequestEvent(RequestEvent.IMREADY));
		}		
	}
}