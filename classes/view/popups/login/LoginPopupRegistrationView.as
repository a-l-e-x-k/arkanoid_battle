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

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.EventHub;
    import utils.MovieClipContainer;

    public class LoginPopupRegistrationView extends MovieClipContainer
    {
        private static var allowedChars:Array = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "a", "b", "c", "d", "e",
            "f", "g", "h", "i", "j",
            "k", "l", "m", "n", "o",
            "p", "q", "r", "s", "t",
            "u", "v", "w", "x", "y", "z", " "];

        public function LoginPopupRegistrationView()
        {
            super(new loginregister());
            _mc.create_btn.addEventListener(MouseEvent.CLICK, goCreate);
            _mc.msg_txt.text = "";
            _mc.login_mc.mc.text_txt.text = "Username";
            _mc.pass_mc.mc.text_txt.text = "Password";
            _mc.pass_rep_mc.mc.text_txt.text = "Repeat password";
            _mc.email_mc.mc.text_txt.text = "E-mail";
            _mc.login_mc.addEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            _mc.pass_mc.addEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            _mc.pass_rep_mc.addEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            _mc.email_mc.addEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            _mc.login_mc.mc.text_txt.addEventListener(Event.CHANGE, onLoginTFChanged);
            _mc.back_btn.addEventListener(MouseEvent.CLICK, goToLogin);

            _mc.login_mc.mc.text_txt.tabIndex = 1;
            _mc.pass_mc.mc.text_txt.tabIndex = 2;
            _mc.pass_rep_mc.mc.text_txt.tabIndex = 3;
            _mc.email_mc.mc.text_txt.tabIndex = 4;
            _mc.create_btn.tabIndex = 5;
        }

        private function goToLogin(event:MouseEvent):void
        {
            dispatchEvent(new RequestEvent(RequestEvent.LOGIN_SHOW_LOGIN));
        }

        private function onLoginTFChanged(event:Event):void
        {
            for (var i:int = 0; i < login.length; i++)
            {
                if (allowedChars.indexOf(login.charAt(i).toLowerCase()) == -1) //found char which is not allowed
                {
                    trace("LoginPopupRegistrationView: allFine: found wrong char in login: " + login.charAt(i));
                    _mc.login_mc.mc.text_txt.text = _mc.login_mc.mc.text_txt.text.replace(login.charAt(i), "");
                }
            }
        }

        private static function initialTFClean(event:FocusEvent):void
        {
            (event.currentTarget as MovieClip).removeEventListener(FocusEvent.FOCUS_IN, initialTFClean);
            if ((event.currentTarget as MovieClip).mc.text_txt.text.indexOf("assword") != -1)
            {
                (event.currentTarget as MovieClip).mc.text_txt.displayAsPassword = true;
            }
            (event.currentTarget as MovieClip).mc.text_txt.text = "";
            ((event.currentTarget as MovieClip).mc.text_txt as TextField).textColor = 0x666666;
        }

        private function goCreate(event:MouseEvent):void
        {
            if (!allFine())
            {
                return;
            }

            EventHub.dispatch(new RequestEvent(RequestEvent.LOGIN_GO_REGISTER,
                    {
                        login: login,
                        password: pass,
                        email: email
                    }));
        }

        private function allFine():Boolean
        {
            for (var i:int = 0; i < login.length; i++)
            {
                if (allowedChars.indexOf(login.charAt(i).toLowerCase()) == -1) //found char which is not allowed
                {
                    _mc.msg_txt.text = "Username may contain only A-z, 0-9 or space";
                    trace("LoginPopupRegistrationView: allFine: found wrong char in login: " + login.charAt(i));
                    return false;
                }
            }

            if (login.length < 4)
            {
                _mc.msg_txt.text = "Username must be at least 4 chars long";
                return false;
            }

            if (login.length > 13)
            {
                _mc.msg_txt.text = "Username must be less than 13 chars long";
                return false;
            }

            if (login == "Username")
            {
                _mc.msg_txt.text = "Invalid Username";
                return false;
            }

            if (passRepeated != pass)
            {
                _mc.msg_txt.text = "Passwords do not match";
                return false;
            }

            return true;
        }

        private function get login():String
        {
            return _mc.login_mc.mc.text_txt.text;
        }

        private function get pass():String
        {
            return _mc.pass_mc.mc.text_txt.text;
        }

        private function get passRepeated():String
        {
            return _mc.pass_rep_mc.mc.text_txt.text;
        }

        private function get email():String
        {
            return _mc.email_mc.mc.text_txt.text;
        }
    }
}