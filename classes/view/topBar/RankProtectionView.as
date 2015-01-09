/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 1/5/13
 * Time: 6:23 PM
 * To change this template use File | Settings | File Templates.
 */
package view.topBar
{
    import external.caurina.transitions.Tweener;

    import utils.MovieClipContainer;

    public class RankProtectionView extends MovieClipContainer
    {
        private var _currentProtection:int;

        public function RankProtectionView(protectionCount:int)
        {
            super(new rankShield());
            _currentProtection = protectionCount;
            if (_currentProtection > 0)
            {
                updateText();
            }
            else
            {
                visible = false;
            }
        }

        /**
         * Called when rank is (or may be) consumed
         * Amount may only be decremented (when we buy more protection RankUnit is recreated completely)
         * @param amount
         */
        public function updateTo(amount:int):void
        {
            if (amount != _currentProtection)
            {
                _currentProtection = amount;
                if (amount > 0)
                {
                    updateText();
                }
                else if (amount == 0)
                {
                    Tweener.addTween(this, {alpha:0, time:1, transition:"easeOutExpo", onComplete:function():void
                    {
                        visible = false;
                    }});
                }
            }
        }

        private function updateText():void
        {
            _mc.t_txt.text = _currentProtection;
        }
    }
}
