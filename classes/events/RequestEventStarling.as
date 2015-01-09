package events
{
import starling.events.Event;
/**
 * ...
 * @author Alexey Kuznetsov
 */
public final class RequestEventStarling extends Event
{
	private var _stuff:Object;

	public static const CELL_CLEARED:String = "cellCleared";
	public static const IMREADY:String = "imraedy";

	public function RequestEventStarling(type:String, stuff:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
		_stuff = stuff;
	}

	public function get stuff():Object {return _stuff;}
}
}