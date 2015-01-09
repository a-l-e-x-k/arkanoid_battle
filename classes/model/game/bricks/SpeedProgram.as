/**
 * Author: Alexey
 * Date: 7/14/12
 * Time: 6:59 PM
 */
package model.game.bricks
{
import flash.utils.Dictionary;

public class SpeedProgram
{
	private var _data:Dictionary = new Dictionary();

	public function SpeedProgram(dataString:String)
	{
		var steps:Array = dataString.split(",");

		var chunkSpeed:int;
		var chunkNumber:int;
		var chunkDataArr:Array;
		for each (var chunkData:String in steps)
		{
			chunkDataArr = chunkData.split(":");
			chunkNumber = int(chunkDataArr[0]);
			chunkSpeed = int(chunkDataArr[1]);
			_data[chunkNumber] = chunkSpeed;
		}
	}

	public function get data():Dictionary
	{
		return _data;
	}
}
}
