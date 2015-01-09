/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/21/13
 * Time: 2:53 AM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import events.RequestEvent;

    import flash.events.FocusEvent;

    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.EventHub;

    import utils.Popup;

    public class EnterOpponentNicknamePopup extends Popup
    {
        public function EnterOpponentNicknamePopup()
        {
            super(new eneropnick());

            _mc.nick_mc.mc.text_txt.text = "Nickname";
            _mc.nick_mc.mc.text_txt.tabIndex = 1;
            _mc.nick_mc.mc.text_txt.addEventListener(FocusEvent.FOCUS_IN, onTFFocusIn);
            _mc.ok_btn.addEventListener(MouseEvent.CLICK, goFindOpponent);

            _mc.close_btn.buttonMode = true;
            _mc.close_btn.addEventListener(MouseEvent.CLICK, die);
        }

        private function onTFFocusIn(event:FocusEvent):void
        {
            (event.currentTarget as TextField).text = "";
            (event.currentTarget as TextField).removeEventListener(FocusEvent.FOCUS_IN, onTFFocusIn);
            (event.currentTarget as TextField).textColor = 0x666666;
        }

        private function goFindOpponent(event:MouseEvent):void
        {
            trace("EnterOpponentNicknamePopup: goFindOpponent: simple" + _mc.nick_mc.mc.text_txt.text);
            EventHub.dispatch(new RequestEvent(RequestEvent.REQUEST_BATTLE, {uid: "simple" + _mc.nick_mc.mc.text_txt.text}));
            die();
        }
    }
}
