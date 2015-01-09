/**
 * Author: Alexey
 * Date: 7/6/12
 * Time: 10:26 PM
 */
package view.game.textPopups
{
    import events.RequestEvent;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import model.ServerTalker;

    import utils.EventHub;

    public class PostGameDecisionPopup extends Sprite
    {
        private var clickedAgain:Boolean; //preventing sending same messages to server
        private var clickedLeave:Boolean; //preventing sending same messages to server

        public function PostGameDecisionPopup()
        {
            var decisionButtons:MovieClip = new postpop();
            decisionButtons.x = 47;
            decisionButtons.y = 148;
            addChild(decisionButtons);
            decisionButtons.again_btn.addEventListener(MouseEvent.CLICK, onAgainClick);
            decisionButtons.leave_mc.addEventListener(MouseEvent.CLICK, onLeaveClick);
        }

        private function onAgainClick(event:MouseEvent):void
        {
            if (!clickedAgain)
            {
                EventHub.dispatch(new RequestEvent(RequestEvent.PLAY_AGAIN));
                clickedAgain = true;
            }
        }

        private function onLeaveClick(event:MouseEvent):void
        {
            if (!clickedLeave)
            {
                ServerTalker.leaveGame();
                EventHub.dispatch(new RequestEvent(RequestEvent.GOTO_LOBBY));
                clickedLeave = true;
            }
        }
    }
}
