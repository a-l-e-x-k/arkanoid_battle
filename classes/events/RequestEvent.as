package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public final class RequestEvent extends Event
    {
        private var _stuff:Object;
        public static const ACTIVATE_BOUNCER:String = "activateBouncer";
        public static const ALBUMS_LOADED:String = "albumsLoaded";
        public static const ALBUM_ERROR:String = "albumsError";
        public static const ANIMATIONS_MANAGER_READY:String = "animationsManagerReady";
        public static const AVATARS_LINKS_LOADED:String = "avatarLinksLoaded";
        public static const AVATARS_WITH_SEX_LOADED:String = "avatarsWithSexLoaded";
        public static const AVATAR_WITH_NAME_LOADED:String = "avatarsWithNameLoaded";
        public static const BALL_DEAD:String = "ballDead";
        public static const BUY_ITEM:String = "buyItem";
        public static const CANCEL_BATTLE_REQUEST:String = "cancelBattleRequest";
        public static const CLIENT_ALLOWED_SPELL_USAGE:String = "clientAllowedSpellUsage";
        public static const CLIENT_GAME_TIMER_FINISHED:String = "clientGameTimerFinished";
        public static const COINS_ADDED:String = "coinsAdded";
        public static const EFFECT_FINISHED:String = "effectFinished";
        public static const ERROR_AT_ADDING_COINS:String = "errorAtAddingCoins";
        public static const FIREBALL_ANIM_FINISHED:String = "fireballAnimFinished";
        public static const GOTO_NEXT_PAGE:String = "gotoNextPage";
        public static const GOTO_PREV_PAGE:String = "gotoPrevPage";
        public static const GO_BATTLE:String = "goBattle";
        public static const GOTO_LOBBY:String = "gotoLobby";
        public static const GOTO_PAGE:String = "gotoPage";
        public static const IMREADY:String = "imReady";
        public static const LOGIN_GO_GUEST:String = "loginGoGuest";
        public static const LOGIN_GO_LOGIN:String = "loginGoLogin";
        public static const LOGIN_GO_REGISTER:String = "loginGoRegister";
        public static const LOGIN_GO_RESTORE:String = "loginGoRestore";
        public static const LOGIN_SHOW_LOGIN:String = "loginShowLogin";
        public static const LOGIN_SHOW_REGISTRATION:String = "loginShowRegistration";
        public static const LOGIN_SHOW_RESTORE:String = "loginShowRestore";
        public static const MAP_COMPLETED:String = "mapCompleted";
        public static const OPPONENT_SHOW_PRE_ROCKET_LAUNCH:String = "opponentShowPreRocketLaunch";
        public static const OPPONENT_TICK:String = "opponentTick";
        public static const PLAY_AGAIN:String = "playAgain";
        public static const PLAYER_CLEARED_CELL:String = "playerClearedCell";
        public static const PLAYER_CLEARED_FIELD:String = "playerClearedField";
        public static const PLAYER_FINISHED:String = "playerFinished";
        public static const PLAYER_LOST_BALL:String = "playerLostBall";
        public static const PLAYER_UPDATED:String = "playerUpdated"; //coins, maps, etc
		public static const POINTS_ANIM_FINISHED:String = "pointsAnimFinished";
        public static const REMOVE_ME:String = "removeMe";
        public static const REPORT_USER:String = "reportUser";
        public static const REQUEST_BATTLE:String = "requestBattle"; //"ask" other player for battle
		public static const SEND_CHAT_MESSAGE:String = "sendChatMessage";
        public static const SETTINGS_SUCCESSFULLY_CHANGED:String = "settingsChanged";
        public static const SPELL_SLOT_CHANGED:String = "spellSlotChanged";
        public static const SHOW_ADD_COINS_POPUP:String = "showAddCoins";
        public static const SHOW_CHARM_LIGHTNINGS_FROM_ME:String = "showCharmLightningsFromMe";
        public static const SHOW_PLAYER_NO_LONGER_ONLINE:String = "showPlayerNoLongerOnline";
        public static const SHOW_PLAYER_IS_PLAYING_ALREADY:String = "playerIsPlayingAlready";
        public static const SHOW_PLAYER_CANCELLED_BATTLE:String = "playerCanceledBattle";
        public static const SHOW_PREFREEZE_FROM_ME:String = "showPrefreezeFromMe";
        public static const SHOW_SKILLS_PANEL:String = "showSkillsPanel";
        public static const SHOW_SHOP_POPUP:String = "showShopPopup";
        public static const SHOP_TAB_CLICKED:String = "shopTabClicked";
        public static const SHOW_USER_PROFILE:String = "showUserProfile";
        public static const SPEED_UP:String = "speedUp";
        public static const SPELL_ACTIVATED_BY_CLIENT:String = "spellActivatedByClient";
        public static const SPELL_EXPIRED:String = "spellExpired";
        public static const SPELL_PREVIEW_LOADED:String = "spellPreviewLoaded";
        public static const SPELLS_PANEL_UPDATE:String = "spellsPanelUpdate";
        public static const USERS_INFO_LOADED:String = "usersInfoLoaded";

		public function RequestEvent(type:String, stuff:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_stuff = stuff ? stuff : {};
		}

		public function get stuff():Object {return _stuff;}

	}
}