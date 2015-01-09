/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/2/13
 * Time: 6:15 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups.login
{
    import events.RequestEvent;

    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.ui.Keyboard;

    import utils.EventHub;
    import utils.Misc;
    import utils.MovieClipContainer;

    public class LoginPopupLoginView extends MovieClipContainer
    {
        private var _loginFilled:Boolean = false;
        private var _passFilled:Boolean = false;
        private var _wentLoggin:Boolean = false; //right after pressing "login" you can't login again

        public function LoginPopupLoginView()
        {
            super(new loginlogin());
            _mc.guest_btn.addEventListener(MouseEvent.CLICK, goGuest);
            _mc.login_btn.addEventListener(MouseEvent.CLICK, goLogin);
            _mc.create_btn.addEventListener(MouseEvent.CLICK, goRegister);
            _mc.forgot_btn.addEventListener(MouseEvent.CLICK, goRestore);
            _mc.login_mc.mc.text_txt.text = "login";
            _mc.pass_mc.mc.text_txt.text = "password";
            _mc.login_mc.mc.text_txt.addEventListener(FocusEvent.FOCUS_IN, onTFFocusIn);
            _mc.pass_mc.mc.text_txt.addEventListener(FocusEvent.FOCUS_IN, onTFFocusIn);

            _mc.login_mc.mc.text_txt.tabIndex = 1;
            _mc.pass_mc.mc.text_txt.tabIndex = 2;

            addEventListener(Event.ADDED_TO_STAGE, addKeyboardListener);
        }

        private function addKeyboardListener(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, tryGoLogin);
        }

        private function tryGoLogin(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER && _passFilled && _loginFilled)
            {
                goLogin();
            }
        }

        private function goRestore(event:MouseEvent):void
        {
            dispatchEvent(new RequestEvent(RequestEvent.LOGIN_SHOW_RESTORE));
        }

        private function onTFFocusIn(event:FocusEvent):void
        {
            if ((event.currentTarget as TextField).text.indexOf("pass") != -1)
            {
                (event.currentTarget as TextField).displayAsPassword = true;
                _passFilled = true;
            }
            else
            {
                _loginFilled = true;
            }

            (event.currentTarget as TextField).text = "";
            (event.currentTarget as TextField).removeEventListener(FocusEvent.FOCUS_IN, onTFFocusIn);
            (event.currentTarget as TextField).textColor = 0x666666;
        }

        private static function goGuest(event:MouseEvent):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.LOGIN_GO_GUEST));
        }

        private function goLogin(event:MouseEvent = null):void
        {
            if (!_wentLoggin)
            {
                EventHub.dispatch(new RequestEvent(RequestEvent.LOGIN_GO_LOGIN,
                        {
                            login: _mc.login_mc.mc.text_txt.text,
                            password: _mc.pass_mc.mc.text_txt.text
                        }));

                _wentLoggin = true;
                Misc.delayCallback(function():void
                {
                    _wentLoggin = false;
                }, 3000); //you can't login right after loggin in (preventing double-ENTER; awesome hack)
            }
        }

        private function goRegister(event:MouseEvent):void
        {
            dispatchEvent(new RequestEvent(RequestEvent.LOGIN_SHOW_REGISTRATION));
        }

        public function cleanUp():void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, tryGoLogin);
        }
    }
}
