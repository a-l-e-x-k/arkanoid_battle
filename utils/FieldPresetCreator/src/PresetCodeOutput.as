/**
 * Author: Alexey
 * Date: 5/9/12
 * Time: 12:04 AM
 */
package
{
import flash.display.MovieClip;
import flash.display.Sprite;

public class PresetCodeOutput extends Sprite
{
	private var _mc:MovieClip;

	public function PresetCodeOutput()
	{
		x = 15;
		y = 517;

		_mc = new presetcodeoutput();
		addChild(_mc);

		setText("");
	}

	private function setText(text:String):void
	{
		_mc.output_txt.text = text;
	}

	public function updateText(event:RequestEvent):void
	{
		setText(event.stuff.code);
	}
}
}
