/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/3/13
 * Time: 10:41 PM
 * To change this template use File | Settings | File Templates.
 */
package model
{
    import events.RequestEvent;

    import flash.display.DisplayObjectContainer;
    import flash.events.Event;

    import networking.init.PlayerioInteractions;

    import starling.core.Starling;

    import utils.EventHub;

    import view.popups.login.LoginPopup;

    public class LoginModel
    {
        private var _view:LoginPopup;

        public function LoginModel(parent:DisplayObjectContainer, showRegistration:Boolean)
        {
            EventHub.addEventListener(RequestEvent.LOGIN_GO_RESTORE, processRestoreRequest);
            EventHub.addEventListener(RequestEvent.LOGIN_GO_LOGIN, processLoginRequest);
            EventHub.addEventListener(RequestEvent.LOGIN_GO_REGISTER, processRegisterRequest);
            EventHub.addEventListener(RequestEvent.LOGIN_GO_GUEST, processGuestRequest);

            _view = new LoginPopup(showRegistration);
            _view.addEventListener(Event.REMOVED_FROM_STAGE, removeListeners);
            parent.addChild(_view);
        }

        private function removeListeners(event:Event):void
        {
            EventHub.removeEventListener(RequestEvent.LOGIN_GO_RESTORE, processRestoreRequest);
            EventHub.removeEventListener(RequestEvent.LOGIN_GO_LOGIN, processLoginRequest);
            EventHub.removeEventListener(RequestEvent.LOGIN_GO_REGISTER, processRegisterRequest);
            EventHub.removeEventListener(RequestEvent.LOGIN_GO_GUEST, processGuestRequest);
        }

        private function processGuestRequest(event:RequestEvent):void
        {
            PlayerioInteractions.login(Starling.current.nativeStage, "guest", "pass"); //simply connect with login "guest" and password "pass" (one login for all guests)
            PopupsManager.showAwaitingOverlay();
        }

        private function processRegisterRequest(event:RequestEvent):void
        {
            PlayerioInteractions.register(Starling.current.nativeStage, event.stuff.login, event.stuff.password, event.stuff.email);
            PopupsManager.showAwaitingOverlay();
        }

        private function processLoginRequest(event:RequestEvent):void
        {
            PlayerioInteractions.login(Starling.current.nativeStage, event.stuff.login, event.stuff.password);
            PopupsManager.showAwaitingOverlay();
        }

        private function processRestoreRequest(event:RequestEvent):void
        {
            _view.showLogin();
            PlayerioInteractions.restorePassword(event.stuff.loginmail);
            PopupsManager.showAwaitingOverlay();
        }
    }
}
