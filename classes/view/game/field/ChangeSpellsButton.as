/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/28/12
 * Time: 11:25 PM
 * To change this template use File | Settings | File Templates.
 */
package view.game.field
{
    import flash.events.MouseEvent;

    import model.PopupsManager;

    import utils.Misc;

    import utils.MovieClipContainer;

    public class ChangeSpellsButton extends MovieClipContainer
    {
        public function ChangeSpellsButton()
        {
            super(new changespellsthing());
            _mc.ch_btn.addEventListener(MouseEvent.CLICK, dispatchSpellChange);
        }

        private static function dispatchSpellChange(event:MouseEvent):void
        {
            PopupsManager.showSpellsPopup();
        }
    }
}
