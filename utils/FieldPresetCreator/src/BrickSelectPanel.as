/**
 * Author: Alexey
 * Date: 5/8/12
 * Time: 11:42 PM
 */
package
{
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

public class BrickSelectPanel extends Sprite
{
	public var currentTool:int = 0;
	private var tf:TextFormat = new TextFormat("Arial", 12, 0xCCCCCC, true);
	private var _allBricks:Array = [];

	public function BrickSelectPanel()
	{
		x = 455;
		y = 41;

		//creating simplebricks of all colors
		for (var i:int = 0; i < BrickPresets.BRICK_COLORS.length; i++)
		{
			createBrickTool(BrickPresets.getToolMCByID(BrickPresets.BRICK_COLORS[i].toolID), "Simple brick (" + BrickPresets.BRICK_COLORS[i].name + ")", i * ((new simplebrickmc()).height + 8));
		}

		var strongBrick:MovieClip = createBrickTool(BrickPresets.getToolMCByID(BrickPresets.STRONG_BRICK), "Strong brick (requires 2 shots)", _allBricks[_allBricks.length - 1].y + 50);
		var bombBrick:MovieClip = createBrickTool(BrickPresets.getToolMCByID(BrickPresets.BOMB_BRICK), "Bomb brick (destroys all nearby bricks\nwhen being hit)", strongBrick.y + 40);
		var firerick:MovieClip = createBrickTool(BrickPresets.getToolMCByID(BrickPresets.FIRE_BRICK), "Fire brick (speeds opp up + bunch of points)", bombBrick.y + 40);
		var toolDelete:MovieClip = createBrickTool(new tooldelete(), "Delete brick", firerick.y + 40);
		toolDelete.toolID = 111;
	}

	private function createBrickTool(mc:MovieClip, textstr:String, yy:int):MovieClip
	{
		mc.y = yy;
		mc.buttonMode = true;
		mc.addEventListener(MouseEvent.CLICK, selectTool);
		_allBricks.push(mc);
		addChild(mc);

		var text:TextField = new TextField();
		text.multiline = true;
		text.setTextFormat(tf);
		text.width = 400;
		text.text = textstr;
		text.selectable = false;
		text.x = mc.x + mc.width + 6;
		text.y = mc.y;
		addChild(text);
		text.setTextFormat(tf);
		return mc;
	}

	private function selectTool(event:MouseEvent):void
	{
		for each (var brick:MovieClip in _allBricks)
		{
			brick.filters = [];
		}

		currentTool = (event.currentTarget as MovieClip).toolID;
		trace("currentTool: " + currentTool);

		var glowFilet:GlowFilter = new GlowFilter(0x000000, 1, 5, 5, 3);
		(event.currentTarget as MovieClip).filters = [glowFilet];

		dispatchEvent(new RequestEvent(RequestEvent.TOOL_UPDATED, {toolID:currentTool}));
	}
}
}
