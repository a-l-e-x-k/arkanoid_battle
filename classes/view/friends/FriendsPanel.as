/**
 * Author: Alexey
 * Date: 5/7/12
 * Time: 4:32 PM
 */
package view.friends
{
import flash.display.Sprite;

import model.userData.UserData;

import networking.special.SocialPerson;

public class FriendsPanel extends Sprite
{
	private const ITEMS_COUNT:int = 10;
	private const FRIEND_ITEM_WIDTH:int = 76;
	private var _items:Array = [];

	public function FriendsPanel()
	{
		update();
	}

	public function update():void
	{
		var count:int = _items.length;
		if (count > 0)
		{
			for (var i:int = 0; i < count; i++)
			{
				removeChild(_items[0]);
				_items.splice(0, 1);
			}
		}

		var newStuff:Array = UserData.friends.slice(); //so we won't be pushing in UserData.friends below

		var me:SocialPerson = new SocialPerson();
		me.firstName = UserData.name;
		me.photoURL = UserData.photoURL;
		me.inAppFriend = true;
		newStuff.push(me);

		newStuff.sortOn(["inAppFriend", "level"], [Array.DESCENDING, Array.DESCENDING | Array.NUMERIC]);

		for (i = 0; i < ITEMS_COUNT; i++)
		{
			var friendItem:FriendItem = new FriendItem(i < newStuff.length ? newStuff[i] : null);
			friendItem.x = 12 + (FRIEND_ITEM_WIDTH * i);
			friendItem.y = 596;
			_items.push(friendItem);
			addChild(friendItem);
		}
	}
}
}
