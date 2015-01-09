/**
 * Author: Alexey
 * Date: 11/3/12
 * Time: 5:11 PM
 */
package model.game
{
	import events.RequestEvent;
	import events.ServerMessageEvent;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;

	import model.spells.SpellsAvailabilityChecker;
    import model.timer.GlobalTimer;

    import utils.EventHub;

	import view.game.field.BaseField;

	/**
	 * Helper for Game class
	 * Adds / removes listeners, calls Game's methods when events are fired
	 * Kinda "Controller" in MVC pattern
	 */
	public class GameEventsHandler
	{
		private var _gameLink:Game;
		private var _keyboardPanelMoveDirection:int = 0; //0 - nowhere, 1 -> right, -1 -> left

		public function GameEventsHandler(gameLink:Game)
		{
			GlobalTimer.addEventListener(TimerEvent.TIMER, onGameTick);
			_gameLink = gameLink;
			_gameLink.view.stage.focus = _gameLink.view.stage; //fix for stage not receiving mouse down events
			_gameLink.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameLink.view.stage.addEventListener(KeyboardEvent.KEY_DOWN, tryLaunchPowerup);
			_gameLink.view.stage.addEventListener(KeyboardEvent.KEY_UP, stopPanelMoveViaKeyboard);
			_gameLink.view.stage.addEventListener(Event.ENTER_FRAME, tryMovePanelViaKeyboard);
			EventHub.addEventListener(RequestEvent.POINTS_ANIM_FINISHED, onPointsAnimFinished);
			EventHub.addEventListener(ServerMessageEvent.PROCESS_PANEL_SYNC, processPanelSync);
			EventHub.addEventListener(ServerMessageEvent.SPEED_UP, onSpeedUp);
			EventHub.addEventListener(ServerMessageEvent.CHARM_BALLS, goCharmBalls);
			EventHub.addEventListener(ServerMessageEvent.FREEZE, goFreeze);
			EventHub.addEventListener(ServerMessageEvent.ROCKET, goLaunchRocket);
			EventHub.addEventListener(ServerMessageEvent.GAME_FINISH_MESSAGE, onGameFinishMessageReceived);
			EventHub.addEventListener(ServerMessageEvent.OPPONENT_ACTIVATED_SPELL, onOpponentActivatedSpell);
			EventHub.addEventListener(RequestEvent.OPPONENT_TICK, oppTicked); //for speed up things
			EventHub.addEventListener(RequestEvent.FIREBALL_ANIM_FINISHED, fireballAnimFinished);
			EventHub.addEventListener(RequestEvent.SPELLS_PANEL_UPDATE, updateUserPanel);
			EventHub.addEventListener(RequestEvent.PLAYER_LOST_BALL, onPlayerLostBall);
			EventHub.addEventListener(RequestEvent.CLIENT_GAME_TIMER_FINISHED, onClientGameTimerFinished);
			EventHub.addEventListener(RequestEvent.PLAYER_FINISHED, onPlayerFinished);
			EventHub.addEventListener(RequestEvent.PLAYER_CLEARED_CELL, onPlayerClearedCell);
			EventHub.addEventListener(RequestEvent.SHOW_CHARM_LIGHTNINGS_FROM_ME, onShowCharmLightningsFromMe);
			EventHub.addEventListener(RequestEvent.SHOW_PREFREEZE_FROM_ME, onShowPrefreezeFromMe);
			EventHub.addEventListener(RequestEvent.CLIENT_ALLOWED_SPELL_USAGE, onClientAllowedSpellUsage);
            EventHub.addEventListener(RequestEvent.SPELL_EXPIRED, onSpellExpired);
            EventHub.addEventListener(RequestEvent.SPELL_ACTIVATED_BY_CLIENT, onSpellActivated);
            EventHub.addEventListener(RequestEvent.PLAYER_CLEARED_FIELD, onPlayerClearedField);
            EventHub.addEventListener(RequestEvent.OPPONENT_SHOW_PRE_ROCKET_LAUNCH, showOpponentPreRocketLaunch);
        }

        private function showOpponentPreRocketLaunch(event:RequestEvent):void
        {
            _gameLink.showOpponentPreRocketLaunch();
        }

        private function onPlayerClearedField(event:RequestEvent):void
        {
            _gameLink.onPlayerClearedField(event.stuff.fieldName);
        }

        private function onOpponentActivatedSpell(event:ServerMessageEvent):void
        {
            _gameLink.onOpponentActivatedSpell(event.message.getString(0), event.message.getString(1));
        }

        private function onSpellActivated(event:RequestEvent):void
        {
            _gameLink.onSpellActivated(event.stuff.spellName);
        }

        private function onSpellExpired(event:RequestEvent):void
        {
             _gameLink.onSpellExpired(event.stuff.spellName);
        }

		private function onClientAllowedSpellUsage(event:RequestEvent):void
		{
			_gameLink.onClientAllowedSpell(event.stuff.requestID); //client checked powerup availability.
		}

		private function onShowCharmLightningsFromMe(event:RequestEvent):void
		{
			 _gameLink.showCharmLightnings(event.stuff.fromField)
		}

		private function onShowPrefreezeFromMe(event:RequestEvent):void
		{
			_gameLink.showPrefreeze(event.stuff.fromField)
		}

		private function tryMovePanelViaKeyboard(event:Event):void
		{
			if (_keyboardPanelMoveDirection != 0)
				_gameLink.movePanelViaKeyboard(_keyboardPanelMoveDirection);
		}

		private function stopPanelMoveViaKeyboard(event:KeyboardEvent):void
		{
			if ((_keyboardPanelMoveDirection == 1 && event.keyCode == Keyboard.RIGHT) || //protect from stopping movement when: KEY_DOWN -> another KEY_DOWN -> 1st KEY_UP
					(_keyboardPanelMoveDirection == -1 && event.keyCode == Keyboard.LEFT))
				_keyboardPanelMoveDirection = 0;
		}

		private static function onPointsAnimFinished(event:RequestEvent):void
		{
			Game.onPointsAnimFinished(event.stuff.targetField as BaseField, event.stuff.pointsAmount);
		}

		private function processPanelSync(event:ServerMessageEvent):void
		{
			_gameLink.processPanelSync(event.message.getNumber(0), event.message.getString(1), event.message.getString(2));
		}

		private function onSpeedUp(event:ServerMessageEvent):void
		{
			_gameLink.onSpeedUp(event.message.getInt(0), event.message.getString(1), event.message.getInt(2));
		}

		private function goCharmBalls(event:ServerMessageEvent):void
		{
			_gameLink.goCharmBalls();
		}

		private function goFreeze(event:ServerMessageEvent):void
		{
			_gameLink.goFreeze();
		}

        private function goLaunchRocket(event:ServerMessageEvent):void
        {
           _gameLink.goLaunchRocket();
        }

		private function onGameFinishMessageReceived(event:ServerMessageEvent):void
		{
			_gameLink.onGameFinishMessageReceived(event.message);
		}

		private function oppTicked(event:RequestEvent):void
		{
			_gameLink.oppTicked(event.stuff.oppID, event.stuff.tickNumber);
		}

		/**
		 * This function is called twice. But this is not really important
		 * (There are two fireballs animation)
		 * @param event
		 */
		private static function fireballAnimFinished(event:RequestEvent):void
		{
			(event.stuff.targetField as BaseField).showSmoke();
		}

		private function updateUserPanel(event:RequestEvent):void
		{
			_gameLink.updateUserPanel();
		}

		private function onPlayerLostBall(event:RequestEvent):void
		{
			_gameLink.onPlayerLostBall(event.stuff.name, event.stuff.fromX, event.stuff.fromY);
		}

		private function onClientGameTimerFinished(event:RequestEvent):void
		{
			_gameLink.onClientGameTimerFinished();
		}

		private function onPlayerFinished(event:RequestEvent):void
		{
			_gameLink.onPlayerFinished(event.stuff as String);
		}

		private function onPlayerClearedCell(event:RequestEvent):void
		{
			_gameLink.onPlayerClearedCell(event.stuff.fieldName, event.stuff.x, event.stuff.y, event.stuff.cellType);
		}

		private function onGameTick(event:TimerEvent):void
		{
			_gameLink.tick();
		}

		private function onMouseMove(event:MouseEvent):void
		{
			_keyboardPanelMoveDirection = 0; //just in case bouncer was moved with keyboard before
			_gameLink.updatePanelPosition(event.stageX);
		}

		private function tryLaunchPowerup(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT)
				_keyboardPanelMoveDirection = -1;
			else if (event.keyCode == Keyboard.RIGHT)
				_keyboardPanelMoveDirection = 1;
			else if (event.keyCode == Keyboard.NUMBER_1 || event.keyCode == Keyboard.NUMPAD_1)
				SpellsAvailabilityChecker.tryUseSpellBySlot(1, _gameLink.lastsFor, _gameLink.gameLength);
			else if (event.keyCode == Keyboard.NUMBER_2 || event.keyCode == Keyboard.NUMPAD_2)
				SpellsAvailabilityChecker.tryUseSpellBySlot(2, _gameLink.lastsFor, _gameLink.gameLength);
			else if (event.keyCode == Keyboard.NUMBER_3 || event.keyCode == Keyboard.NUMPAD_3)
				SpellsAvailabilityChecker.tryUseSpellBySlot(3, _gameLink.lastsFor, _gameLink.gameLength);
			else if (event.keyCode == Keyboard.NUMBER_4 || event.keyCode == Keyboard.NUMPAD_4)
				SpellsAvailabilityChecker.tryUseSpellBySlot(4, _gameLink.lastsFor, _gameLink.gameLength);
			else if (event.keyCode == Keyboard.NUMBER_5 || event.keyCode == Keyboard.NUMPAD_5)
				SpellsAvailabilityChecker.tryUseSpellBySlot(5, _gameLink.lastsFor, _gameLink.gameLength);
		}

		public function removeListeners():void
		{
			GlobalTimer.removeEventListener(TimerEvent.TIMER, onGameTick);
			_gameLink.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_gameLink.view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, tryLaunchPowerup);
			_gameLink.view.stage.removeEventListener(KeyboardEvent.KEY_UP, stopPanelMoveViaKeyboard);
			_gameLink.view.stage.removeEventListener(Event.ENTER_FRAME, tryMovePanelViaKeyboard);
			EventHub.removeEventListener(RequestEvent.POINTS_ANIM_FINISHED, onPointsAnimFinished);
			EventHub.removeEventListener(ServerMessageEvent.PROCESS_PANEL_SYNC, processPanelSync);
			EventHub.removeEventListener(ServerMessageEvent.SPEED_UP, onSpeedUp);
			EventHub.removeEventListener(ServerMessageEvent.CHARM_BALLS, goCharmBalls);
			EventHub.removeEventListener(ServerMessageEvent.FREEZE, goFreeze);
            EventHub.removeEventListener(ServerMessageEvent.ROCKET, goLaunchRocket);
			EventHub.removeEventListener(ServerMessageEvent.GAME_FINISH_MESSAGE, onGameFinishMessageReceived);
            EventHub.removeEventListener(ServerMessageEvent.OPPONENT_ACTIVATED_SPELL, onOpponentActivatedSpell);
			EventHub.removeEventListener(RequestEvent.SPELLS_PANEL_UPDATE, updateUserPanel);
			EventHub.removeEventListener(RequestEvent.OPPONENT_TICK, oppTicked);
			EventHub.removeEventListener(RequestEvent.FIREBALL_ANIM_FINISHED, fireballAnimFinished);
			EventHub.removeEventListener(RequestEvent.PLAYER_LOST_BALL, onPlayerLostBall);
			EventHub.removeEventListener(RequestEvent.CLIENT_GAME_TIMER_FINISHED, onClientGameTimerFinished);
			EventHub.removeEventListener(RequestEvent.PLAYER_FINISHED, onPlayerFinished);
			EventHub.removeEventListener(RequestEvent.PLAYER_CLEARED_CELL, onPlayerClearedCell);
			EventHub.removeEventListener(RequestEvent.SHOW_CHARM_LIGHTNINGS_FROM_ME, onShowCharmLightningsFromMe);
			EventHub.removeEventListener(RequestEvent.SHOW_PREFREEZE_FROM_ME, onShowPrefreezeFromMe);
			EventHub.removeEventListener(RequestEvent.CLIENT_ALLOWED_SPELL_USAGE, onClientAllowedSpellUsage);
            EventHub.removeEventListener(RequestEvent.SPELL_EXPIRED, onSpellExpired);
            EventHub.removeEventListener(RequestEvent.SPELL_ACTIVATED_BY_CLIENT, onSpellActivated);
            EventHub.removeEventListener(RequestEvent.PLAYER_CLEARED_FIELD, onPlayerClearedField);
            EventHub.removeEventListener(RequestEvent.OPPONENT_SHOW_PRE_ROCKET_LAUNCH, showOpponentPreRocketLaunch);
		}
	}
}
