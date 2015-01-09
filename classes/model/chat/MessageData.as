/**
 * Author: Alexey
 * Date: 11/5/12
 * Time: 3:07 AM
 */
package model.chat
{
	public class MessageData
	{
		public var text:String;
		public var userID:String;
		public var senderRank:int;

		public function MessageData(t:String, uid:String, ssenderRank:int)
		{
			text = t;
			userID = uid;
            senderRank = ssenderRank;
		}
	}
}
