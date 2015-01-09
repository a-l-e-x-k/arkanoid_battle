namespace ServerSide
{
    public class MessageTypes
    {
        public const string AUTH_DATA = "ad";
        public const string ACTIVATE_SPELL = "as";
        public const string ACTIVATE_SPELL_OK = "asok";
        public const string ACTIVATE_SPELL_OPPONENT = "asop";
        public const string BATTLE_REQUEST_ACCEPTED = "ba";
        public const string BATTLE_REQUEST_DENIED = "bd";
        public const string BATTLE_REQUESTED = "br";
        public const string BUY_ARMOR = "bar";
        public const string BUY_BOUNCER = "bb";
        public const string BUY_ENERGY = "be";

        public const string CANCEL_BATTLE_REQUEST = "cbr";
            //user has connected to another guy's room and decided not to play at this point (maybe other guy was too long with deciding whether accept or decline offer)

        public const string CHANGE_SPELL_SLOT = "sc";
        public const string CHARM_BALLS = "cb";
        public const string CHAT_MESSAGE = "cm";
        public const string ENERGY_UPDATE = "eu";
        public const string FINISH_GAME = "fg";
        public const string FREEZE = "fr";
        public const string GAME_UPDATED = "gu";
        public const string IM_READY = "ir";
        public const string LEAVE_GAME = "leaveGame";
        public const string OPEN_DOORS = "od";
        public const string PLAY_AGAIN = "plag";
        public const string PLAYER_PLAYING_ALREADY = "pa";
        public const string PURCHASE_FAILED = "pf";
        public const string ROCKET = "ro";
        public const string SPEED_UP = "su";
        public const string START_GAME = "sg";
        public const string TRY_USE = "tu";
        public const string TURN_MUSIC_ONOFF = "tm";
        public const string TURN_SOUNDS_ONOFF = "ts";
        public const string TICK = "s";
        public const string USER_LEFT = "ul";

        //service messages (sent by admin when doing special stuff)
        public const string START_SNAPSHOT_RECORDING = "startSnapshotRecording";
        public const string SAVE_SNAPSHOT = "saveSnapshot";
        public const string FINISH_SNAPSHOT_RECORDING = "finishSnapshotRecording";
    }
}