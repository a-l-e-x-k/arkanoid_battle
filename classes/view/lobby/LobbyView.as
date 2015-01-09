/**
 * Author: Alexey
 * Date: 5/6/12
 * Time: 9:20 PM
 */
package view.lobby
{
	import events.RequestEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import model.PopupsManager;
    import model.constants.GameTypes;

    import utils.EventHub;
    import utils.Misc;

    import view.lobby.MapsButton;

    import view.lobby.gameSelect.GameSelector;

	public class LobbyView extends Sprite
	{
		private var _gameSelector:GameSelector;
        private var _mapsButton:MapsButton;

		public function LobbyView()
		{
			_gameSelector = new GameSelector();
			addChild(_gameSelector);

			var playButton:MovieClip = new playbtn();
			playButton.x = 438;
			playButton.y = 411;
			playButton.buttonMode = true;
			playButton.mouseChildren = false;
			playButton.addEventListener(MouseEvent.CLICK, dispatchGoPlay);
			addChild(playButton);

			var shopBtn:MovieClip = new shopbtnout();
			shopBtn.buttonMode = true;
			shopBtn.addEventListener(MouseEvent.CLICK, goToShop);
			shopBtn.x = 413;
			shopBtn.y = 509;
			addChild(shopBtn);

            _mapsButton = new MapsButton();
            _mapsButton.addEventListener(MouseEvent.CLICK, goToMaps);
            _mapsButton.x = 533;
            _mapsButton.y = 508;
			addChild(_mapsButton);

			var infoBtn:MovieClip = new informationbuttonout();
			infoBtn.buttonMode = true;
			infoBtn.addEventListener(MouseEvent.CLICK, goToInfo);
			infoBtn.x = 655;
			infoBtn.y = 509;
			addChild(infoBtn);
		}

		private static function goToShop(event:MouseEvent):void
		{
			PopupsManager.showShop();
		}

		private static function goToMaps(event:MouseEvent):void
		{
		   PopupsManager.showMaps();
		}

		private static function goToInfo(event:MouseEvent):void
		{
            PopupsManager.showComingSoonPopup();
		}

		private function dispatchGoPlay(event:MouseEvent):void
		{
            if (_gameSelector.currentGameType == GameTypes.FAST_SPRINT_PRIVATE)
            {
                PopupsManager.showEnterOpponentNicknamePopup();
            }
            else
            {
                EventHub.dispatch(new RequestEvent(RequestEvent.GO_BATTLE, {type:_gameSelector.currentGameType}));
            }
		}

        public function cleanUp():void
        {
            _mapsButton.cleanUp();
            _gameSelector.clean();
        }
    }
}
