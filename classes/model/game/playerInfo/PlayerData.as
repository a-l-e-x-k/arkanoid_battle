/**
 * Author: Alexey
 * Date: 7/3/12
 * Time: 11:13 PM
 */
package model.game.playerInfo
{
    import model.userData.UserData;

    public class PlayerData
{
	public var uid:String = "";
	public var name:String = "";
	public var photoURL:String = "";
	public var panelConfiguration:Object;
	public var bouncerID:String;

	public function PlayerData(uid:String, panelConfiguration:Object, bouncerID:String)
	{
		this.uid = uid;
		this.panelConfiguration = panelConfiguration;
        this.bouncerID = bouncerID;
		//name = "George Washington"; //TODO: get from FB
        var trimmedName:String = UserData.nameFromUid(uid);
        name = trimmedName.length == 0 ? "Lucy" : trimmedName; //it is of 0 length when playing with NPC, which had id as a landom number < 99999
		photoURL = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/275922_100001090908017_1910079956_q.jpg"; //TODO: get from FB
	}
}
}
