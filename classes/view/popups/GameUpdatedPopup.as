/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/17/13
 * Time: 8:08 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    /**
     * This class is used only to destinguish between Message Popup & this one.
     * This one is cleaned by class by PopupManager before showing again
     * (because it might be shown every 15 sec, until player updates the game)
     */
    public class GameUpdatedPopup extends MessagePopup
    {
        public function GameUpdatedPopup(text:String, canClose:Boolean = false)
        {
            super(text, canClose);
        }
    }
}
