/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/2/13
 * Time: 6:16 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.login
{
    import events.RequestEvent;
    import events.RequestEvent;

    import flash.display.MovieClip;
    import flash.events.Event;

    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;

    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.ui.Keyboard;

    import utils.EventHub;

    import utils.MovieClipContainer;

    public class LoginPopupRestoreView extends MovieClipContainer
    {
        private var _loginFilled:Boolean = false;

        public function LoginPopupRestoreView()
        {
            super(new loginrestore());
            _mc.login_mc.addEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            _mc.restore_btn.addEventListener(MouseEvent.CLICK, goRestore);
            _mc.back_btn.addEventListener(MouseEvent.CLICK, goToLogin);
            _mc.login_mc.mc.text_txt.text = "E-mail or login";

            addEventListener(Event.ADDED_TO_STAGE, addKeyboardListener);
        }

        private function addKeyboardListener(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, tryGoRestore);
        }

        private function initialTFClean(event:FocusEvent):void
        {
            (event.currentTarget as MovieClip).removeEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            (event.currentTarget as MovieClip).mc.text_txt.text = "";
            ((event.currentTarget as MovieClip).mc.text_txt as TextField).textColor = 0x666666;
            _loginFilled = true;
        }

        private function goToLogin(event:MouseEvent):void
        {
            dispatchEvent(new RequestEvent(RequestEvent.LOGIN_SHOW_LOGIN));
        }

        private function goRestore(event:MouseEvent = null):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.LOGIN_GO_RESTORE, {loginmail: _mc.login_mc.mc.text_txt.text}));
        }

        private function tryGoRestore(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER && _loginFilled)
            {
                goRestore();
            }
        }

        public function cleanUp():void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, tryGoRestore);
        }
    }
}
