/**
 * Created with IntelliJ IDEA.
 * User: aleksejkuznecov
 * Date: 12/22/12
 * Time: 11:22 PM
 * To change this template use File | Settings | File Templates.
 */
package view.lobby
{
    import events.RequestEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;

    import model.constants.Maps;
    import model.userData.UserData;

    import utils.EventHub;
    import utils.Misc;
    import utils.MovieClipContainer;

    public class MapsButton extends MovieClipContainer
    {
        public function MapsButton()
        {
            super(new mapsbtnout());
            updateStars();
            addEventListener(MouseEvent.MOUSE_DOWN, updateStars);
            addEventListener(MouseEvent.MOUSE_OVER, updateStars);
            addEventListener(MouseEvent.MOUSE_OUT, updateStars);
            addEventListener(MouseEvent.ROLL_OVER, updateStars);
            addEventListener(MouseEvent.ROLL_OVER, updateStars);
            addEventListener(MouseEvent.MOUSE_UP, updateStars);
            EventHub.addEventListener(RequestEvent.PLAYER_UPDATED, updateStars);
            Misc.addSimpleButtonListeners(_mc);
            buttonMode = true;
        }

        private function updateStars(e:Event = null):void
        {
            _mc.mc.st_txt.text = UserData.mapsConfiguration.getUserStarsCount() + "/" + (Maps.count * 3).toString();
        }

        public function cleanUp():void
        {
            EventHub.removeEventListener(RequestEvent.PLAYER_UPDATED, updateStars);
        }
    }
}
