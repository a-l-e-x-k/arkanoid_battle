package events
{
import flash.events.Event;

import playerio.Message;

/**
 * ...
 * @author Alexey Kuznetsov
 */
public final class ServerMessageEvent extends Event
{
	private var _message:Message;

	public static const BATTLE_REQUESTED:String = "battleRequested";
	public static const BATTLE_REQUEST_CANCELLED:String = "battleRequestCancelled";
	public static const CHARM_BALLS:String = "charmBalls";
	public static const GAME_FINISH_MESSAGE:String = "gameFinish";
    public static const GAME_VERSION_UPDATED:String = "gameVersionUpdated";
    public static const ENERGY_UPDATE:String = "energyUpdate";
    public static const FREEZE:String = "freeze";
    public static const OPPONENT_ACTIVATED_SPELL:String = "opponentActivatedSpell";
    public static const PROCESS_PANEL_SYNC:String = "processPanelSync";
    public static const PURCHASE_FAILED:String = "spellActivationFailed";
    public static const ROCKET:String = "rocketfromserv";
    public static const SPEED_UP:String = "speedUp";
    public static const SPELL_ACTIVATION_ALLOWED:String = "unlockAllowed";
    public static const START_GAME:String = "startGameServer";

	public function ServerMessageEvent(type:String, message:Message, bubbles:Boolean = false, cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
		_message = message;
	}

	public function get message():Message {return _message;}
}
}