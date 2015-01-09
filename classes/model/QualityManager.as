/**
 * Author: Alexey
 * Date: 9/21/12
 * Time: 7:33 PM
 */
package model
{
import flash.display.Stage;
import flash.display.StageQuality;

public class QualityManager
{
	public static const MAX_QUALITY:int = 0;
	public static const BAD_QUALITY:int = 1;
	public static var currentQuality:int;

	private static var stageLink:Stage;

	public static function init(stage:Stage):void
	{
		stageLink = stage;
		goBest();
	}

	/**
	 * Switches quality and returns current quality
	 * @return
	 */
	public static function switchQuality():int
	{
		if (currentQuality == MAX_QUALITY)
		{
			goWorst();
		}
		else if (currentQuality == BAD_QUALITY)
		{
			goBest();
		}
		return currentQuality;
	}

	private static function goBest():void
	{
		currentQuality = MAX_QUALITY;
		stageLink.quality = StageQuality.BEST;
	}

	private static function goWorst():void
	{
		currentQuality = BAD_QUALITY;
		stageLink.quality = StageQuality.LOW;
	}
}
}
