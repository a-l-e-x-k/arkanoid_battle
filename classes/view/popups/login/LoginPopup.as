/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/2/13
 * Time: 4:24 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.login
{
    import events.RequestEvent;

    import flash.display.Sprite;

    import utils.Popup;

    public class LoginPopup extends Popup
    {
        private var _view:Sprite;

        public function LoginPopup($showRegistration:Boolean)
        {
            super(new loginpop(), true);
            if ($showRegistration)
            {
                showRegistration();
            }
            else
            {
                showLogin();
            }
        }

        public function showLogin(e:RequestEvent = null):void
        {
            cleanUp();

            _view = new LoginPopupLoginView();
            //TODO: dispatch goGuestMode, goLogin events via EventHub.
            _view.addEventListener(RequestEvent.LOGIN_SHOW_REGISTRATION, showRegistration);
            _view.addEventListener(RequestEvent.LOGIN_SHOW_RESTORE, showRestore);
            _view.x = 58;
            _view.y = 124;
            addChild(_view);
        }

        private function showRegistration(e:RequestEvent = null):void
        {
            cleanUp();

            _view = new LoginPopupRegistrationView();
            _view.addEventListener(RequestEvent.LOGIN_SHOW_LOGIN, showLogin);
            _view.x = 112;
            _view.y = 154;
            addChild(_view);
        }

        private function showRestore(e:RequestEvent = null):void
        {
            cleanUp();

            _view = new LoginPopupRestoreView();
            _view.addEventListener(RequestEvent.LOGIN_SHOW_LOGIN, showLogin);
            _view.x = 123;
            _view.y = 150;
            addChild(_view);
        }

        private function cleanUp():void
        {
            if (_view)
            {
                if (_view is LoginPopupLoginView)
                {
                    (_view as LoginPopupLoginView).cleanUp();
                }
                else if (_view is LoginPopupRestoreView)
                {
                    (_view as LoginPopupRestoreView).cleanUp();
                }
                _mc.removeChild(_view);
            }

            _view = null;
        }
    }
}
