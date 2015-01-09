/**
 * Author: Alexey
 * Date: 7/6/12
 * Time: 11:58 PM
 */
package model
{
    import events.ServerMessageEvent;

    import flash.utils.ByteArray;

    import networking.GameStartHelper;

    import playerio.Client;
    import playerio.Connection;
    import playerio.Message;

    import utils.*;

    public class ServerTalker
    {
        private static var _serviceConnection:Connection;
        private static var _gameConnection:Connection; //when connected to some other room (not playing in room which was created by this player)
        private static var _client:Client;

        public static function setClient(client:Client):void
        {
            _client = client;
        }

        public static function setServiceConnection(connection:Connection):void
        {
            _serviceConnection = connection;
            _serviceConnection.addMessageHandler(MessageTypes.ACTIVATE_SPELL_OK, handleMessage);
            _serviceConnection.addMessageHandler(MessageTypes.BATTLE_REQUESTED, handleMessage);
            _serviceConnection.addMessageHandler(MessageTypes.CANCEL_BATTLE_REQUEST, handleMessage);
            _serviceConnection.addMessageHandler(MessageTypes.GAME_UPDATED, handleMessage);
            _serviceConnection.addMessageHandler(MessageTypes.ENERGY_UPDATE, handleMessage);
            _serviceConnection.addMessageHandler(MessageTypes.PURCHASE_FAILED, handleMessage);
        }

        public static function setGameConnection(targetConnection:Connection):void
        {
            if (_gameConnection)
            {
                removeGameConnectionListeners(_gameConnection);
            }

            _gameConnection = targetConnection;
            addGameConnectionListeners(_gameConnection);
        }

        private static function addGameConnectionListeners(c:Connection):void
        {
            c.addMessageHandler(MessageTypes.TICK, handleMessage);
            c.addMessageHandler(MessageTypes.ACTIVATE_SPELL_OPPONENT, handleMessage);
            c.addMessageHandler(MessageTypes.SPEED_UP, handleMessage);
            c.addMessageHandler(MessageTypes.FINISH_GAME, handleMessage);
            c.addMessageHandler(MessageTypes.CHARM_BALLS, handleMessage);
            c.addMessageHandler(MessageTypes.FREEZE, handleMessage);
            c.addMessageHandler(MessageTypes.ROCKET, handleMessage);
        }

        private static function removeGameConnectionListeners(c:Connection):void
        {
            c.removeMessageHandler(MessageTypes.TICK, handleMessage);
            c.removeMessageHandler(MessageTypes.ACTIVATE_SPELL_OPPONENT, handleMessage);
            c.removeMessageHandler(MessageTypes.SPEED_UP, handleMessage);
            c.removeMessageHandler(MessageTypes.FINISH_GAME, handleMessage);
            c.removeMessageHandler(MessageTypes.CHARM_BALLS, handleMessage);
            c.removeMessageHandler(MessageTypes.FREEZE, handleMessage);
            c.removeMessageHandler(MessageTypes.ROCKET, handleMessage);
        }

        private static function handleMessage(message:Message):void
        {
            switch (message.type)
            {
                case MessageTypes.TICK: //sync data of opponent's bouncer
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.PROCESS_PANEL_SYNC, message));
                    break;
                case MessageTypes.ACTIVATE_SPELL_OPPONENT: //opponent activated spell
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.OPPONENT_ACTIVATED_SPELL, message));
                    break;
                case MessageTypes.SPEED_UP: //server tells client that he ought to speed up because other player cleared the field
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.SPEED_UP, message));
                    break;
                case MessageTypes.CHARM_BALLS: //server tells client that he ought to charm balls because other opp used powerup
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.CHARM_BALLS, message));
                    break;
                case MessageTypes.FREEZE: //server tells client that he ought to freeze itself because other opp used powerup
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.FREEZE, message));
                    break;
                case MessageTypes.ROCKET: //server tells client that he ought to launch rocket because other opp used powerup
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.ROCKET, message));
                    break;
                case MessageTypes.FINISH_GAME:
                    trace(message);
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.GAME_FINISH_MESSAGE, message));
                    break;
                case MessageTypes.ACTIVATE_SPELL_OK:
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.SPELL_ACTIVATION_ALLOWED, message));
                    break;
                case MessageTypes.PURCHASE_FAILED:
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.PURCHASE_FAILED, message));
                    break;
                case MessageTypes.BATTLE_REQUESTED:
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.BATTLE_REQUESTED, message));
                    break;
                case MessageTypes.CANCEL_BATTLE_REQUEST:
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.BATTLE_REQUEST_CANCELLED, message));
                    break;
                case MessageTypes.ENERGY_UPDATE:
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.ENERGY_UPDATE, message));
                    break;
                case MessageTypes.GAME_UPDATED:
                    EventHub.dispatch(new ServerMessageEvent(ServerMessageEvent.GAME_VERSION_UPDATED, message));
                    break;
            }
        }

        public static function leaveGame():void
        {
            if (_gameConnection && _gameConnection.connected) //may be disconnected already (Room Owner kicked player out)
            {
                sendGameMessage(MessageTypes.LEAVE_GAME);
            }
        }

        public static function playAgain(gameType:String, mapID:String):void
        {
            sendGameMessage(MessageTypes.PLAY_AGAIN, gameType, mapID);
        }

        public static function sendPanelSyncWithCriticalHits(bouncerX:Number, hitsData:String, executedRequestsData:String):void
        {
            trace("[SEND SYNC]: bouncerX: " + bouncerX + " hitsData: " + hitsData + " executedRequestsData: " + executedRequestsData);
            sendGameMessage(MessageTypes.TICK, bouncerX, hitsData, executedRequestsData);
        }

        /**
         * ID 1-5
         * Most likely powerup will be allowed because SpellsAvailabilityChecker has made check already
         * @param slotID
         */
        public static function wannaUse(slotID:int):void
        {
            sendGameMessage(MessageTypes.TRY_USE, slotID);
        }

        public static function changeSpellSlot(spellName:String, slotNumber:int):void
        {
            sendServiceMessage(MessageTypes.CHANGE_SPELL_SLOT, spellName, slotNumber);
        }

        public static function activateSpell(spellName:String):void
        {
            sendServiceMessage(MessageTypes.ACTIVATE_SPELL, spellName);
        }

        public static function startSnapshotRecording(previewName:String, areaWidth:int, areaHeight:int):void
        {
            sendServiceMessage(MessageTypes.START_SNAPSHOT_RECORDING, previewName, areaWidth, areaHeight);
        }

        public static function saveSnapshotFrame(byteAr:ByteArray):void
        {
            sendServiceMessage(MessageTypes.SAVE_SNAPSHOT, byteAr);
        }

        public static function finishSnapshotRecording():void
        {
            sendServiceMessage(MessageTypes.FINISH_SNAPSHOT_RECORDING);
        }

        public static function acceptBattleRequest():void
        {
            GameStartHelper.setGameConnection(serviceConnection); //it will listen for START_GAME message
            sendServiceMessage(MessageTypes.BATTLE_REQUEST_ACCEPTED);
        }

        public static function cancelBattleRequest():void
        {
            sendServiceMessage(MessageTypes.BATTLE_REQUEST_DENIED);
        }

        public static function sendChatMessage(text:String):void
        {
            sendServiceMessage(MessageTypes.CHAT_MESSAGE, text)
        }

        public static function buyBouncer(bouncerID:String):void
        {
            sendServiceMessage(MessageTypes.BUY_BOUNCER, bouncerID);
        }

        public static function buyArmor(itemkey:String):void
        {
            sendServiceMessage(MessageTypes.BUY_ARMOR, itemkey);
        }

        public static function buyEnergy(itemkey:String):void
        {
            sendServiceMessage(MessageTypes.BUY_ENERGY, itemkey);
        }

        /**
         * Player-related messages, like buying powerups, rearranging them
         * @param args
         */
        private static function sendServiceMessage(...args:Array):void
        {
           // trace("[Sending]: " + args);
            _serviceConnection.send.apply(null, args);
        }

        private static function sendGameMessage(...args:Array):void
        {
          //  trace("[Sending]: " + args, Relations.MESSAGES);
            _gameConnection.send.apply(null, args);
        }

        public static function get client():Client
        {
            return _client;
        }

        public static function get serviceConnection():Connection
        {
            return _serviceConnection;
        }

        public static function turnSoundsOnoff(b:Boolean):void
        {
            sendServiceMessage(MessageTypes.TURN_SOUNDS_ONOFF, b);
        }

        public static function turnMusicOnoff(b:Boolean):void
        {
            sendServiceMessage(MessageTypes.TURN_MUSIC_ONOFF, b);
        }
    }
}