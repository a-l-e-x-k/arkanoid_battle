/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 2:49 AM
 */
package model.requests
{
public class GameRequestData
{
	public var requestID:int = -1;
	public var data:String = "";

	public function GameRequestData(requestID:int, data:String)
	{
		this.requestID = requestID;
		this.data = data;
	}
}
}
