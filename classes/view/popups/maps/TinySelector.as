package view.popups.maps
{
	import utils.MovieClipContainer;

	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class TinySelector extends MovieClipContainer 
	{
		private var _id:int;
		
		public function TinySelector(i:int) 
		{
			super(new tinySelector());
			_id = i;			
		}
		
		public function goActive():void
		{
			_mc.gotoAndStop(1);
		}
		
		public function goPassive():void
		{
			_mc.gotoAndStop(2);
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}