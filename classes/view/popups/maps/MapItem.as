/**
 * Author: Alexey
 * Date: 12/5/12
 * Time: 12:47 AM
 */
package view.popups.maps
{
	import caurina.transitions.Tweener;

	import flash.display.Bitmap;

	import flash.events.MouseEvent;

	import model.PopupsManager;
	import model.lobby.MapsPreviewsCache;
    import model.userData.MapsConfiguration;
    import model.userData.UserData;

    import utils.MovieClipContainer;

	public class MapItem extends MovieClipContainer
	{
		private const OVER_RESISE:Number = 1.1; //by what number item resizes on mouse over
		private const RESIZE_TIME:Number = 0.2; //length of tween
		private var resultWidth:Number; //saved for using tweens
		private var resultHeight:Number;
		private var _id:int;

		private const TWEEN_STATE_NONE:int = 0;
		private const TWEEN_STATE_OVER:int = 1;
		private const TWEEN_STATE_OUT:int = 2;
		private var _awaitingOutTween:Boolean;
		private var _awaitingOverTween:Boolean;
		private var _tweenState:int;

		public function MapItem(id:int)
		{
            trace("MapItem: MapItem: " + id);
			_id = id;

			super(new listitem());

			var preview:Bitmap = MapsPreviewsCache.getPreview(id);
			preview.x = (MapsPreviewsCache.MAX_WIDTH - preview.width) / 2;    //center image inside container (image is cropped)
			preview.y = (MapsPreviewsCache.MAX_HEIGHT_FOR_CENTERING - preview.height) / 2;  //center image inside container (image is cropped)
			_mc.pic_mc.addChild(preview);

			addEventListener(MouseEvent.MOUSE_OVER, playOver);
			addEventListener(MouseEvent.MOUSE_OUT, playOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);

			resultWidth = width;
			resultHeight = height;

			buttonMode = true;

            var starsCount:int = UserData.mapsConfiguration.getStars(id);
            _mc.star1.visible = starsCount > 0;
            _mc.star2.visible = starsCount > 1;
            _mc.star3.visible = starsCount > 2;
		}

		private function onMouseClick(event:MouseEvent):void
		{
            trace("MapItem: onMouseClick: id: " + _id);
			PopupsManager.showPlayMapConfirmation(_id);
		}

		private function playOver(e:MouseEvent = null):void
		{
			if (_tweenState != TWEEN_STATE_OVER) //playing tween only once
			{
				Tweener.addTween(this, { width:resultWidth * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine", onComplete:onOverComplete });
				Tweener.addTween(this, { height:resultHeight * OVER_RESISE, time:RESIZE_TIME, transition:"easeOutSine" });
				_tweenState = TWEEN_STATE_OVER;
				_awaitingOverTween = false;
			}
			else
				_awaitingOverTween = true;
		}

		private function playOut(e:MouseEvent = null):void
		{
			if (_tweenState != TWEEN_STATE_OUT) //playing tween only once
			{
				Tweener.addTween(this, { width:resultWidth, time:RESIZE_TIME, transition:"easeOutSine", onComplete:onOutComplete });
				Tweener.addTween(this, { height:resultHeight, time:RESIZE_TIME, transition:"easeOutSine" });
				_tweenState = TWEEN_STATE_OUT;
				_awaitingOutTween = false;
			}
			else
				_awaitingOutTween = true;
		}

		private function onOutComplete():void
		{
			_tweenState = TWEEN_STATE_NONE;
			if (_awaitingOverTween)
				 playOver();
		}

		private function onOverComplete():void
		{
			_tweenState = TWEEN_STATE_NONE;
			if (_awaitingOutTween)
				playOut();
		}
	}
}
