/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 2/3/13
 * Time: 11:22 PM
 * To change this template use File | Settings | File Templates.
 */
package view.popups
{
    import utils.Popup;

    public class AwaitingOverlay extends Popup
    {
        public function AwaitingOverlay()
        {
            super(new awaover(), true, 0, 0, 0.8);
        }
    }
}
