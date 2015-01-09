/**
 * Author: Alexey
 * Date: 12/7/12
 * Time: 6:49 PM
 */
package view.game.field.cells
{
	import flash.display.Sprite;
	import flash.geom.Point;

	import model.game.bricks.BrickPresets;

	import model.constants.GameConfig;

	public class PreviewFieldCells extends Sprite
	{
		public var rowsCount:int = 0;
		public var columnsCount:int = 0;
		public var startPoint:Point;
		public var endPoint:Point;

		/**
		 * Model class, which creates layer (Sprite) for cells and add cells there
		 * @param presetCode
		 */
		public function PreviewFieldCells(presetCode:String)
		{
			createGrid(presetCode);
		}

		private function createGrid(presetCode:String):void
		{
			rowsCount = GameConfig.FIELD_HEIGHT_PX / GameConfig.BRICK_HEIGHT;
			columnsCount = GameConfig.FIELD_WIDTH_PX / GameConfig.BRICK_WIDTH;

			var cells:Array = [];
			//creating empty field
			for (var i:int = 0; i < rowsCount; i++)
			{
				cells[i] = [];
				for (var j:int = 0; j < columnsCount; j++)
				{
					cells[i][j] = new PreviewCell(i, j);
				}
			}

			//fill it with cells
			var presetData:Array = presetCode.split("|");
			var cellI:int = 0;
			var cellJ:int = 0;
			var brickID:int = 0;
			var cell:PreviewCell;
			startPoint = new Point(666, 666);
			endPoint = new Point(0, 0);
			for (i = 0; i < presetData.length; i++)
			{
				var cellData:Array = presetData[i].split(",");
				cellJ = int(cellData[0]);
				cellI = int(cellData[1]);
				brickID = int(cellData[2]);
				cell = cells[cellI][cellJ] as PreviewCell;
				cell.attachBrick(brickID);
				if (brickID != BrickPresets.EMPTY_CELL)
				{
					if (startPoint.x > cell.x)
						startPoint.x = cell.x;
					if (startPoint.y > cell.y)
						startPoint.y = cell.y;
					if (endPoint.x < cell.x + GameConfig.BRICK_WIDTH)
						endPoint.x = cell.x + (GameConfig.BRICK_WIDTH);
					if (endPoint.y < cell.y + (GameConfig.BRICK_HEIGHT))
						endPoint.y = cell.y + GameConfig.BRICK_HEIGHT;
					addChild(cell);
				}
			}
		}
	}
}
