/**
 * Author: Alexey
 * Date: 12/14/12
 * Time: 2:20 AM
 */
package view.popups.myspells
{
    import flash.events.TimerEvent;

    import model.timer.GlobalTimerOneSecond;
    import model.userData.UserData;

    import utils.Misc;
    import utils.MovieClipContainer;

    public class ActivatedSpellLeftTime extends MovieClipContainer
    {
        private var _spellName:String;

        public function ActivatedSpellLeftTime(spellName:String)
        {
            super(new spelllefttime());
            _spellName = spellName;
            GlobalTimerOneSecond.addEventListener(TimerEvent.TIMER, updateTime);
            updateTime();
        }

        private function updateTime(event:TimerEvent = null):void
        {
            var spellExpiresAt:int = UserData.spellsConfiguration.getActivatedSpellLeftTime(_spellName); //UNIX seconds
            var secondsTotal:Number = spellExpiresAt - Misc.currentUNIXSecs;
            var hoursLeft:Number = Math.floor(secondsTotal / 3600);
            var minutesLeft:Number = Math.floor((secondsTotal - hoursLeft * 3600) / 60);
            var secondsLeft:Number = secondsTotal - hoursLeft * 3600 - minutesLeft * 60;

            var secondsStr:String = secondsLeft < 10 ? "0" + secondsLeft.toString() : secondsLeft.toString();
            var minutesStr:String = minutesLeft < 10 ? "0" + minutesLeft.toString() : minutesLeft.toString();
            _mc.t_txt.text = hoursLeft + ":" + minutesStr + ":" + secondsStr;

            if (secondsTotal <= 0 && minutesLeft <= 0 && hoursLeft <= 0)
            {
                clean();
            }
        }

        public function clean():void
        {
            GlobalTimerOneSecond.removeEventListener(TimerEvent.TIMER, updateTime);
        }
    }
}
