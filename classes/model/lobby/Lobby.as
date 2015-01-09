/**
 * Author: Alexey
 * Date: 11/5/12
 * Time: 11:04 PM
 */
package model.lobby
{
	import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;

    import model.IGameState;
    import model.PopupsManager;
    import model.chat.Chat;

    import utils.Misc;

    import view.lobby.LobbyView;
    import view.popups.finishGame.FinishGamePopup;

    public class Lobby implements IGameState
	{
		private var _chat:Chat;
		private var _view:LobbyView;

		public function Lobby(parent:DisplayObjectContainer)
		{
			_view = new LobbyView();
			parent.addChild(_view);
			_chat = new Chat(_view, 11, 57);
		}

		public function cleanUp():void
		{
			_chat.cleanUp();
            _view.cleanUp();
			_view.parent.removeChild(_view);
		}
	}
}
