/**
 * Author: Alexey
 * Date: 5/7/12
 * Time: 5:23 PM
 */
package model.game.bricks {
import flash.display.MovieClip;

import utils.Misc;

/**
 * Created presets dictionary.
 */

public class BrickPresets
{
	//Tools
	public static const EMPTY_CELL:int = -1;

	public static const SIMPLE_BRICK_ORANGE:int = 0;
	public static const SIMPLE_BRICK_GREEN:int = 1;
	public static const SIMPLE_BRICK_YELLOW:int = 2;
	public static const SIMPLE_BRICK_RED:int = 3;
	public static const SIMPLE_BRICK_BLUE:int = 4;
	public static const SIMPLE_BRICK_PURPLE:int = 5;
	public static const SIMPLE_BRICK_PINK:int = 6;
	public static const SIMPLE_BRICK_WHITE:int = 7;
	public static const SIMPLE_BRICK_DARK_GREY:int = 8;

	public static const STRONG_BRICK:int = 9;
	public static const BOMB_BRICK:int = 10;
	public static const FIRE_BRICK:int = 11;

	public static const TOOL_DELETE:int = 111;


	//Colors for simple bricks
	public static const BRICK_COLOR_ORANGE:uint = 0xFF9900;
	public static const BRICK_COLOR_GREEN:uint = 0x33D900;
	public static const BRICK_COLOR_YELLOW:uint = 0xFFDB02;
	public static const BRICK_COLOR_RED:uint = 0xF50000;
	public static const BRICK_COLOR_BLUE:uint = 0x0099FF;
	public static const BRICK_COLOR_PURPLE:uint = 0x9900FF;
	public static const BRICK_COLOR_PINK:uint = 0xFF33FF;
	public static const BRICK_COLOR_WHITE:uint = 0xFFFFFF;
	public static const BRICK_COLOR_DARK_GREY:uint = 0x333333;
	public static const BRICK_COLORS:Array = [
		{color:BRICK_COLOR_ORANGE, name:"orange", toolID:SIMPLE_BRICK_ORANGE},
		{color:BRICK_COLOR_GREEN, name:"green", toolID:SIMPLE_BRICK_GREEN},
		{color:BRICK_COLOR_YELLOW, name:"yellow", toolID:SIMPLE_BRICK_YELLOW},
		{color:BRICK_COLOR_RED, name:"red", toolID:SIMPLE_BRICK_RED},
		{color:BRICK_COLOR_BLUE, name:"blue", toolID:SIMPLE_BRICK_BLUE},
		{color:BRICK_COLOR_PURPLE, name:"purple", toolID:SIMPLE_BRICK_PURPLE},
		{color:BRICK_COLOR_PINK, name:"pink", toolID:SIMPLE_BRICK_PINK},
		{color:BRICK_COLOR_WHITE, name:"white", toolID:SIMPLE_BRICK_WHITE},
		{color:BRICK_COLOR_DARK_GREY, name:"dark grey", toolID:SIMPLE_BRICK_DARK_GREY}
	];

	public static function getToolMCByID(toolID:int):MovieClip
	{
		var mc:MovieClip;
		switch (toolID)
		{
			case SIMPLE_BRICK_ORANGE:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_ORANGE);
				break;
			case SIMPLE_BRICK_GREEN:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_GREEN);
				break;
			case SIMPLE_BRICK_YELLOW:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_YELLOW);
				break;
			case SIMPLE_BRICK_RED:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_RED);
				break;
			case SIMPLE_BRICK_BLUE:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_BLUE);
				break;
			case SIMPLE_BRICK_PURPLE:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_PURPLE);
				break;
			case SIMPLE_BRICK_PINK:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_PINK);
				break;
			case SIMPLE_BRICK_WHITE:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_WHITE);
				break;
			case SIMPLE_BRICK_DARK_GREY:
				mc = new simplebrickmc();
				Misc.applyColorTransform(mc.ins_mc.color_mc, BRICK_COLOR_DARK_GREY);
				break;
			case STRONG_BRICK:
				mc = new strongbrick();
				break;
			case BOMB_BRICK:
				mc = new bombbrick();
				break;
			case FIRE_BRICK:
				mc = new firebrick();
				break;
		}
		mc.toolID = toolID;
		return mc;
	}
}
}
