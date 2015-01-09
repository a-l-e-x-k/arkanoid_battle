/**
 * Author: Alexey
 * Date: 5/9/12
 * Time: 12:51 PM
 */
package
{
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;

public class Cell extends Sprite
{
	public var i:int;
	public var j:int;
	public var _brick:MovieClip;

	public function Cell(i:int, j:int)
	{
		this.i = i;
		this.j = j;

		var cell:Shape = new Shape();
		cell.graphics.beginFill(0, 0); //so mouse clicks are triggereed
		cell.graphics.lineStyle(1, 0xCCCCCC, 0.4);
		cell.graphics.lineTo(Field.BRICK_WIDTH, 0);
		cell.graphics.lineTo(Field.BRICK_WIDTH, Field.BRICK_HEIGHT);
		cell.graphics.lineTo(0, Field.BRICK_HEIGHT);
		cell.graphics.lineTo(0, 0);
		cell.graphics.endFill();
		addChild(cell);

		x = j * Field.BRICK_WIDTH;
		y = i * Field.BRICK_HEIGHT;
	}

	public function attachBrick(mc:MovieClip):void
	{
		if (_brick && contains(_brick))
			removeChild(_brick);

		_brick = mc;
		addChild(_brick);
	}

	public function clearBrick():void
	{
		if (_brick && contains(_brick))
			removeChild(_brick);
		_brick = null;
	}
}
}
