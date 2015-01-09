/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 2:51 AM
 */
package model.requests
{
import flash.utils.Dictionary;

public class OutstandingRequests
{
	private var _requests:Dictionary = new Dictionary();

	public function OutstandingRequests()
	{
	}

	public function add(requestID:int, nextTickNumber:int, requestData:String = ""):void
	{
		var inserted:Boolean = false;
		var i:int = 0;

		while (!inserted)
		{
			if(_requests[nextTickNumber + i])
			{
				i++;
			}
			else //found empty slot (tick, at which there is no request planned at the moment)
			{
				_requests[nextTickNumber + i] = new GameRequestData(requestID, requestData);
				inserted = true;
			}
		}
	}

	public function addFromString(dataString:String):void
	{
		var inStrings:Array = dataString.split("$"); //sometines adding several items at once
		var powerupData:Array;

		for each (var string:String in inStrings)
		{
			powerupData = string.split(":");
			trace("OutstandingRequests : addFromString : " + int(powerupData[1]) + " : " + int(powerupData[0]));
			_requests[int(powerupData[1])] = new GameRequestData(int(powerupData[0]), powerupData[2]);
		}
	}

	public function get requests():Dictionary
	{
		return _requests;
	}
}
}
