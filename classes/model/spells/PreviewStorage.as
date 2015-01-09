/**
 * Author: Alexey
 * Date: 8/25/12
 * Time: 4:39 PM
 */
package model.spells
{
import view.popups.myspells.preview.*;

import flash.utils.Dictionary;

public class PreviewStorage
{
	private static var previews:Dictionary = new Dictionary();

	public static function hasPreview(spellName:String):Boolean
	{
	   return previews[spellName] != null;
	}

	public static function savePreview(preview:AnimatedPreview):void
	{
		previews[preview.spellName] = preview;
	}

	public static function getPreview(spellName:String):AnimatedPreview
	{
		return previews[spellName];
	}
}
}
