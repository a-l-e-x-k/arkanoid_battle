/**
 * Author: Alexey
 * Date: 5/9/12
 * Time: 12:08 AM
 */
package
{
import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
import flash.events.MouseEvent;

public class Field extends Sprite
{
	public static const FIELD_WIDTH_PX:int = 351; //in pixels
	public static const FIELD_HEIGHT_PX:int = 390; //in pixels
	public static const BRICK_WIDTH:int = 39;
	public static const BRICK_HEIGHT:int = 15;

	private var _fieldBg:MovieClip;
	private var _currentTool:int;
	private var _cells:Array = [];

	public function Field()
	{
		x = 75;
		y = 41;

		_fieldBg = new fieldbg();
		_fieldBg.x = -19;
		_fieldBg.y = -74;
		addChild(_fieldBg);

		var blackBg:Shape = new Shape();
		blackBg.graphics.beginFill(0x00000, 1);
		blackBg.graphics.drawRect(0, 0, FIELD_WIDTH_PX, FIELD_HEIGHT_PX);
		addChild(blackBg);

		createGrid();
	}

	public function updateTool(e:RequestEvent):void
	{
		trace("new tool ID : " + e.stuff.toolID);
		_currentTool = e.stuff.toolID;
	}

	private function createGrid():void
	{
		var rowCount:int = Math.floor(FIELD_HEIGHT_PX / BRICK_HEIGHT);
		var columnCount:int = Math.floor(FIELD_WIDTH_PX / BRICK_WIDTH);

		for (var i:int = 0; i < rowCount; i++)
		{
			_cells[i] = [];
			for (var j:int = 0; j < columnCount; j++)
			{
				var cell:Cell = new Cell(i, j);
				cell.addEventListener(MouseEvent.CLICK, onCellClicked);
				cell.buttonMode = true;
				_cells[i][j] = cell;
				addChild(cell);
			}
		}
	}

	private function onCellClicked(event:MouseEvent):void
	{
		if (_currentTool == BrickPresets.TOOL_DELETE)
			(event.currentTarget as Cell).clearBrick();
		else
			(event.currentTarget as Cell).attachBrick(BrickPresets.getToolMCByID(_currentTool));

		dispatchEvent(new RequestEvent(RequestEvent.FIELD_UPDATED, {code:getPresetCode()}));
	}

	private function getPresetCode():String
	{
		var result:String = "";
		var beginning:String = "";
		for (var i:int = 0; i < _cells.length; i++)
		{
			for (var j:int = 0; j < _cells[i].length; j++)
			{
				beginning = result.length == 0 ? "" : "|";

				if ((_cells[i][j] as Cell)._brick)
					result += beginning + j + "," + i + "," + _cells[i][j]._brick.toolID;   //"X-Y-ID" format
			}
		}
		trace("PRESET CODE: " + result)
		return result;
	}

	public function clear():void
	{
		for (var i:int = 0; i < _cells.length; i++)
		{
			for (var j:int = 0; j < _cells[i].length; j++)
			{
				(_cells[i][j] as Cell).clearBrick();
			}
		}
	}
}
}
