package view
{
    import events.RequestEvent;
    import events.ServerMessageEvent;

    import flash.display.Sprite;

    import model.IGameState;
    import model.PopupsManager;
    import model.game.Game;
    import model.game.gameStart.GameStartData;
    import model.lobby.ChatPopupEventsHandler;
    import model.lobby.Lobby;

    import utils.EventHub;

    import view.loading.GameLoadingAnimation;
    import view.tooltips.SpellTooltip;
    import view.topBar.TopBar;

    /**
	 * Screen creates views (e.g. lobby, game)
	 * @author Alexey Kuznetsov
	 */
	public class MainView extends Sprite
	{
		private var _topBar:TopBar;    //it'll have exp, energy, etc
		private var _loadingAnim:GameLoadingAnimation;
		private var _state:IGameState;
		private var _stateLayer:Sprite;
		private var _popupLayer:Sprite;
		private var _tooltipLayer:Sprite;

		public function MainView()
		{
			_loadingAnim = new GameLoadingAnimation(0, 0, true);
			addChild(_loadingAnim);

			EventHub.addEventListener(RequestEvent.GOTO_LOBBY, createLobby);
			EventHub.addEventListener(RequestEvent.SHOW_SKILLS_PANEL, showSpellsPanel);
			EventHub.addEventListener(RequestEvent.SHOW_SHOP_POPUP, showShopPopup);
			EventHub.addEventListener(RequestEvent.SHOW_ADD_COINS_POPUP, showAddCoinsPopup);
			EventHub.addEventListener(ServerMessageEvent.START_GAME, createGame);

			_stateLayer = new Sprite();
			addChild(_stateLayer);

			_popupLayer = new Sprite();
			addChild(_popupLayer);

			_tooltipLayer = new Sprite();
			_tooltipLayer.addChild(SpellTooltip.getInstance());
			addChild(_tooltipLayer);

			PopupsManager.init(_popupLayer);
			ChatPopupEventsHandler.init();
		}

        private function showAddCoinsPopup(event:RequestEvent):void
        {
            if (!(_state is Game && (_state as Game).isPlaying))
                PopupsManager.showAddCoinsPopup();
        }

		private function showSpellsPanel(event:RequestEvent):void
		{
			if (!(_state is Game && (_state as Game).isPlaying))
				PopupsManager.showSpellsPopup();
		}

		private function showShopPopup(event:RequestEvent):void
		{
			if (!(_state is Game && (_state as Game).isPlaying))
				PopupsManager.showShop(event.stuff.tab);
		}

		public function init():void
		{
			if (_loadingAnim && contains(_loadingAnim))
				removeChild(_loadingAnim);

            if (_topBar && _popupLayer.contains(_topBar)) //it happens when user sees "Feature unavaiable" popup & clicks "Create Account" (registration from Guest Mode)

            {
                trace("MainView: init: removing top bar");
                _popupLayer.removeChild(_topBar);
            }

            PopupsManager.removeAwaitingOverlay(); //left from login
            PopupsManager.removeLoginWindow();

			_topBar = new TopBar();
			_popupLayer.addChild(_topBar); //add it higher than "state"
             trace("MainView: init: adding top bar");
			createLobby();
		}

		public function createLobby(e:RequestEvent = null):void
		{
			clearState();
			_state = new Lobby(_stateLayer);
		}

		private function createGame(e:ServerMessageEvent):void
		{
			PopupsManager.removeAwatingGamePopups();
			clearState();
			_state = new Game(new GameStartData(e.message), _stateLayer);
		}

		private function clearState():void
		{
			if (_state != null)
			{
				_state.cleanUp();
				_state = null;
			}
		}

        public function get state():IGameState
        {
            return _state;
        }
    }
}