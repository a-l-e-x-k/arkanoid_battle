/**
 * Author: Alexey
 * Date: 9/6/12
 * Time: 11:14 PM
 */
package model.game
{
    import events.RequestEvent;

    import flash.events.TimerEvent;

    import model.timer.GlobalTimerOneSecond;

    import utils.EventHub;
    import utils.MovieClipContainer;

    public class TimerPanel extends MovieClipContainer
    {
        private var _gameLength:int;
        private var _globalTimerStartCount:int;

        public function TimerPanel(length:int)
        {
            _gameLength = length;
            _globalTimerStartCount = GlobalTimerOneSecond.currentCount;
            super(new timer_panel(), 318, 38);
            _mc.mc.time_txt.selectable = false;
            GlobalTimerOneSecond.addEventListener(TimerEvent.TIMER, updateTime);
            updateTime();
        }

        private function updateTime(event:TimerEvent = null):void
        {
            var left:int = _gameLength - (GlobalTimerOneSecond.currentCount - _globalTimerStartCount);
            var secsLeft:int = left % 60;
            var minsLeft:int = Math.floor(left / 60);

            if (secsLeft >= 0 || minsLeft >= 0) //if "finishGame" message was not yet received, don't update timer
            {
                _mc.mc.time_txt.text = minsLeft + ":" + (secsLeft < 10 ? "0" + secsLeft : secsLeft.toString());

                if (secsLeft == 1 && minsLeft == 0)
                {
                    EventHub.dispatch(new RequestEvent(RequestEvent.CLIENT_GAME_TIMER_FINISHED));
                } //prohibit powerups & balls hitting
            }
            else
            {
                die();
            }
        }

        public function die():void
        {
           GlobalTimerOneSecond.removeEventListener(TimerEvent.TIMER, updateTime);
        }
    }
}
