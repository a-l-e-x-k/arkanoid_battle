package
{
import flash.events.Event;

/**
 * ...
 * @author Alexey Kuznetsov
 */
public final class RequestEvent extends Event
{
	private var _stuff:Object;

	public static const TOOL_UPDATED:String = "toolUpdated";
	public static const FIELD_UPDATED:String = "fieldUpdated";

	public function RequestEvent(type:String, stuff:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
		_stuff = stuff;
	}

	public function get stuff():Object
	{
		return _stuff;
	}
}
}