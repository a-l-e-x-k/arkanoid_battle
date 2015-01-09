/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/28/12
 * Time: 7:01 PM
 * To change this template use File | Settings | File Templates.
 */
package view.topBar
{
    import events.RequestEvent;

    import flash.events.MouseEvent;
    import flash.events.TimerEvent;

    import model.constants.GameConfig;
    import model.shop.ShopItemsInfo;
    import model.timer.GlobalTimerOneSecond;
    import model.userData.UserData;

    import utils.EventHub;
    import utils.Misc;
    import utils.MovieClipContainer;

    public class EnergyUnit extends MovieClipContainer
    {
        private const ENERGY_MASK_MAX_SIZE:int = 110;
        private var _infinityState:Boolean = false;

        public function EnergyUnit()
        {
            super(new energyunit());
            addEventListener(MouseEvent.MOUSE_OVER, showTip);
            addEventListener(MouseEvent.MOUSE_OUT, hideTip);
            _mc.add_btn.addEventListener(MouseEvent.CLICK, dispatchAddEnergy);
            GlobalTimerOneSecond.addEventListener(TimerEvent.TIMER, updateText);
            update();
        }

        private static function dispatchAddEnergy(event:MouseEvent):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_SHOP_POPUP, {tab: ShopItemsInfo.TAB_ENERGY}));
        }

        private function updateText(event:TimerEvent):void
        {
            var timeLeft:Number = UserData.energyNextUpdate - Misc.currentUNIXSecs;
            if (_infinityState)
            {
                timeLeft = UserData.energyExpires - Misc.currentUNIXSecs;
            }

            var hoursLeft:int = Math.floor(timeLeft / (60 * 60));
            var minutesLeft:int = Math.floor((timeLeft - hoursLeft * 60 * 60) / 60);
            var secsLeft:int = timeLeft - hoursLeft * 60 * 60 - minutesLeft * 60;
            hoursLeft = Math.max(0, hoursLeft);
            minutesLeft = Math.max(0, minutesLeft); //may be the case that ENERGY_UPDATE message is delayed from server
            secsLeft = Math.max(0, secsLeft);
            var hoursStr:String = hoursLeft > 10 ? hoursLeft.toString() : ("0" + hoursLeft.toString());
            var minsStr:String = minutesLeft > 10 ? minutesLeft.toString() : ("0" + minutesLeft.toString());
            var secsStr:String = secsLeft > 10 ? secsLeft.toString() : ("0" + secsLeft.toString());

            if (_infinityState)
            {
                _mc.energy_tip.t_txt.text = "Infinite for " + hoursStr + ":" + minsStr + ":" + secsStr;
            }
            else
            {
                if (UserData.energy >= GameConfig.ENERGY_MAX)
                {
                    _mc.energy_tip.t_txt.text = "Full";
                }
                else
                {
                    _mc.energy_tip.t_txt.text = "More in " + minsStr + ":" + secsStr;
                }
            }
        }

        private function showTip(event:MouseEvent):void
        {
            if (UserData.energy < GameConfig.ENERGY_MAX || _infinityState)
            {
                _mc.energy_tip.alpha = 1;
            }
        }

        private function hideTip(event:MouseEvent):void
        {
            _mc.energy_tip.alpha = 0;
        }

        public function update():void
        {
            _infinityState = UserData.energyExpires >= Misc.currentUNIXSecs;
            _mc.mc.inf_mc.visible = _infinityState;

            var prevEnergy:int = int(_mc.mc.val_txt.text);
            if (prevEnergy > UserData.energy) //show energy consumption if there was a negative change
            {
                _mc.mc.sub_mc.mc.t_txt.text = UserData.energy - prevEnergy; //negative number
                _mc.mc.sub_mc.play();
                Misc.delayCallback(function ():void
                {
                    _mc.mc.val_txt.text = UserData.energy;
                }, 200); //wait or "-X" animation to appear
            }
            else
            {
                _mc.mc.val_txt.text = UserData.energy;
            }

            _mc.add_btn.visible = (UserData.energy / GameConfig.ENERGY_MAX) < 0.7;
            _mc.mc.mask_mc.width = ENERGY_MASK_MAX_SIZE * (UserData.energy / GameConfig.ENERGY_MAX);
        }
    }
}
