/**
 * Author: Alexey
 * Date: 12/7/12
 * Time: 10:53 PM
 */
package model.lobby
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import model.constants.GameConfig;

	import model.constants.Maps;

	import flash.display.Sprite;

	import utils.snapshoter.Snapshoter;

	import view.game.field.cells.PreviewFieldCells;

	public class MapsPreviewsCache
	{
		public static const MAX_WIDTH:int = 175;
		public static const MAX_HEIGHT_FOR_SCALE:int = 180;
		public static const MAX_HEIGHT_FOR_CENTERING:int = 150;
		private static const BONUS_SPACE:int = 5; //for glows to be snapshoted
		private static var _storage:Dictionary = new Dictionary();

		/**
		 * Creates images of maps
		 */
		public static function init():void
		{
			for (var i:int = 0; i < Maps.count; i++)
			{
				_storage[i] = getPreview(i);
			}
		}

		public static function getPreview(mapID:int, copy:Boolean = false):Bitmap
		{
			var b:Bitmap;

			if (_storage[mapID])
				b = _storage[mapID];
			else
			{
				var mapCode:String = Maps.getMapCode(mapID);
				var preview:PreviewFieldCells = new PreviewFieldCells(mapCode);
				var cellsStartPoint:Point = preview.startPoint; //left-top-most point where there are visible cells
				var cellsEndPoint:Point = preview.endPoint;   //right-bottom-most point where there are visible cells
				var snapWidth:Number = cellsEndPoint.x - cellsStartPoint.x + BONUS_SPACE;
				var snapHeight:Number = cellsEndPoint.y - cellsStartPoint.y + BONUS_SPACE;
				b = Snapshoter.snapshot(preview, snapWidth, snapHeight, true, 0, cellsStartPoint.x - BONUS_SPACE, cellsStartPoint.y - BONUS_SPACE);
				var resizeRatio:Number = MAX_HEIGHT_FOR_SCALE / GameConfig.FIELD_HEIGHT_PX; //usually number < 1. Kinda reduction % (means how much % will be left)
				b.scaleX *= resizeRatio;
				b.scaleY *= resizeRatio;
				b.smoothing = true;
			}

			if (copy)
			{
				b = new Bitmap(b.bitmapData.clone());
			}

			return b;
		}
	}
}
