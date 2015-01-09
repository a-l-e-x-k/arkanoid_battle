/**
 * Author: Alexey
 * Date: 5/8/12
 * Time: 10:34 PM
 */
package
{
	import com.demonsters.debugger.MonsterDebugger;

	import flash.display.MovieClip;
import flash.events.MouseEvent;

[SWF(width="753", height="908", backgroundColor="#000000", frameRate="30")]
public class Main extends MovieClip
{
	private var _presetCodeOutput:PresetCodeOutput;
	private var _brickSelectPanel:BrickSelectPanel;
	private var _field:Field;

	public function Main()
	{
		MonsterDebugger.initialize(this);

		_brickSelectPanel = new BrickSelectPanel();
		addChild(_brickSelectPanel);

		_presetCodeOutput = new PresetCodeOutput();
		addChild(_presetCodeOutput);

		var clrBtn:MovieClip = new clrbtn();
		clrBtn.x = 630;
		clrBtn.y = 500;
		clrBtn.buttonMode = true;
		clrBtn.addEventListener(MouseEvent.CLICK, clearField);
		addChild(clrBtn);

		_field = new Field();
		_field.addEventListener(RequestEvent.FIELD_UPDATED, _presetCodeOutput.updateText);
		_brickSelectPanel.addEventListener(RequestEvent.TOOL_UPDATED, _field.updateTool);
		addChild(_field);
	}

	private function clearField(event:MouseEvent):void
	{
		_field.clear();
	}
}
}

