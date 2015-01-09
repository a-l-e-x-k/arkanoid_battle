/**
 * Author: Alexey
 * Date: 9/8/12
 * Time: 3:40 PM
 */
package model
{
public class MessageTypes
{
	public static const AUTH_DATA:String = "ad";
	public static const ACTIVATE_SPELL:String = "as";
	public static const ACTIVATE_SPELL_OK:String = "asok";
	public static const ACTIVATE_SPELL_OPPONENT:String = "asop";
    public static const BATTLE_REQUEST_ACCEPTED:String = "ba";
    public static const BATTLE_REQUEST_DENIED:String = "bd";
    public static const BATTLE_REQUESTED:String = "br";
    public static const BUY_ARMOR:String = "bar";
    public static const BUY_BOUNCER:String = "bb";
    public static const BUY_ENERGY:String = "be";
    public static const CANCEL_BATTLE_REQUEST:String = "cbr"; //user has connected to another guy's room and decided not to play at this point (maybe other guy was too long with deciding whether accept or decline offer)
	public static const CHANGE_SPELL_SLOT:String = "sc";
    public static const CHARM_BALLS:String = "cb";
    public static const CHAT_MESSAGE:String = "cm";
    public static const ENERGY_UPDATE:String = "eu";
    public static const FINISH_GAME:String = "fg";
    public static const FREEZE:String = "fr";
    public static const GAME_UPDATED:String = "gu";
    public static const IM_READY:String = "ir";
    public static const LEAVE_GAME:String = "leaveGame";
    public static const OPEN_DOORS:String = "od";
    public static const PLAY_AGAIN:String = "plag";
    public static const PLAYER_PLAYING_ALREADY:String = "pa";
    public static const PURCHASE_FAILED:String = "pf";
    public static const ROCKET:String = "ro";
    public static const SPEED_UP:String = "su";
    public static const START_GAME:String = "sg";
    public static const TICK:String = "s";
    public static const TURN_MUSIC_ONOFF:String = "tm";
    public static const TURN_SOUNDS_ONOFF:String = "ts";
    public static const TRY_USE:String = "tu";
    public static const USER_LEFT:String = "ul";
    //service messages (sent by admin when doing special stuff)
	public static const START_SNAPSHOT_RECORDING:String = "startSnapshotRecording";
    public static const SAVE_SNAPSHOT:String = "saveSnapshot";
    public static const FINISH_SNAPSHOT_RECORDING:String = "finishSnapshotRecording";
}
}
