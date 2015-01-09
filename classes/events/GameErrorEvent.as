/**
 * Author: Alexey
 * Date: 10/6/12
 * Time: 8:51 PM
 */
package events
{
import flash.events.Event;

public class GameErrorEvent extends Event
{
	public static const STREAM_ERROR:String = "streamError";
	public static const TRYING_TO_SEND_MESSAGE_WHEN_DISCONNECTED:String = "tryingToSendMEssageWhenDisconnected";

	public function GameErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}
}
}
