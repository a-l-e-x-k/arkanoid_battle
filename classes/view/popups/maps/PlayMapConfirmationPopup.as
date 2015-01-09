/**
 * Author: Alexey
 * Date: 12/7/12
 * Time: 6:26 PM
 */
package view.popups.maps
{
    import events.RequestEvent;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;

    import model.PopupsManager;
    import model.constants.GameTypes;
    import model.lobby.MapsPreviewsCache;

    import utils.EventHub;
    import utils.Popup;

    public class PlayMapConfirmationPopup extends Popup
    {
        private var _mapID:int;
        private var _preview:Bitmap;
        private const MAX_WIDTH:int = 250;
        private const MAX_HEIGHT:int = 140;

        public function PlayMapConfirmationPopup(mapID:int, force:Boolean):void
        {
            trace("PlayMapConfirmationPopup: PlayMapConfirmationPopup: mapID: " + mapID);
            _mapID = mapID;

            super(new mapconfirm(), force);

            _mc.cancel_btn.addEventListener(MouseEvent.CLICK, die);
            _mc.ok_btn.addEventListener(MouseEvent.CLICK, goPlay);

            _preview = MapsPreviewsCache.getPreview(mapID, true);
            var widthBigger:Boolean = _preview.height < _preview.width;
            var dimension:Number = widthBigger ? _preview.width : _preview.height;
            var targetDim:Number = widthBigger ? MAX_WIDTH : MAX_HEIGHT;
            var resizeRatio:Number = targetDim / dimension; //usually number < 1. Kinda reduction % (means how much % will be left)
            _preview.width *= resizeRatio;
            _preview.height *= resizeRatio;

            if (_preview.height > MAX_HEIGHT || _preview.width > MAX_WIDTH) //resize again if after 1st resize image did not fit
            {
                widthBigger = _preview.width > MAX_WIDTH;
                dimension = widthBigger ? _preview.width : _preview.height;
                targetDim = widthBigger ? MAX_WIDTH : MAX_HEIGHT;
                resizeRatio = targetDim / dimension; //usually number < 1.
                _preview.width *= resizeRatio;
                _preview.height *= resizeRatio;
            }

            _preview.x = (_mc.width - _preview.width) / 2;
            _preview.y = (_mc.height - _preview.height) / 2 - 18;
            _mc.addChild(_preview);
        }

        override protected function clearListeners():void
        {
            _preview.bitmapData.dispose();
        }

        private function goPlay(event:MouseEvent):void
        {
            trace("PlayMapConfirmationPopup: goPlay: map: " + _mapID);
            EventHub.dispatch(new RequestEvent(RequestEvent.GO_BATTLE, {type: GameTypes.FAST_SPRINT, map: _mapID}));
            die();
            PopupsManager.removeMapsPopup();
        }
    }
}
