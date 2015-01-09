/**
 * Author: Alexey
 * Date: 7/8/12
 * Time: 12:12 AM
 */
package view.friends
{
import fl.containers.UILoader;

import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import utils.MovieClipContainer;
import utils.PhotoLoaderResiser;

import networking.Networking;
import networking.special.SocialPerson;

public class FriendItem extends MovieClipContainer
{
	private var _avatar:UILoader = new UILoader();
	private var _friendData:SocialPerson;

	public function FriendItem(friendData:SocialPerson = null)
	{
		super(new friendItem());

		if (friendData && friendData.inAppFriend)
		{
			_friendData = friendData;

			_avatar = PhotoLoaderResiser.getPhotoContainer(friendData.photoURL, 50, 50);
			_mc.avatar_mc.buttonMode = true;
			_mc.avatar_mc.addEventListener(MouseEvent.CLICK, gotoDude);

			_mc.avatar_mc.ex_mc.removeChild(_mc.avatar_mc.ex_mc.tetka_mc);
			_mc.avatar_mc.ex_mc.addChild(_avatar);
			_mc.name_txt.text = friendData.firstName;
			_mc.level_mc.text_txt.htmlText = "<b>" + friendData.level + "</b>";
		}
		else
		{
			_mc.gotoAndStop(2);
			_mc.buttonMode = true;
			_mc.addEventListener(MouseEvent.CLICK, onInviteClick);
		}
	}

	private function gotoDude(event:MouseEvent):void
	{
		navigateToURL(new URLRequest(Networking.coreLink + _friendData.uid), "_blank");
	}

	private static function onInviteClick(event:MouseEvent):void
	{
		Networking.showSocialInvitePopup();
	}
}
}
