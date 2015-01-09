/**
 * Author: Alexey
 * Date: 5/16/12
 * Time: 11:46 PM
 */
package model.game.panel
{
import view.game.bouncer.*;
import view.game.field.*;

public class ChunkData
{
	private var _targetX:Number;
	private var _stepsData:Vector.<StepData> = new Vector.<StepData>(); //contains amount added to velocity on each frame during chunk for each step

	/**
	 * Processes parameters from message.
	 * @param targetX
	 */
	public function ChunkData(targetX:Number)
	{
		_targetX = targetX;
	}

	/**
	 * Calculates & sets sync points based on target data & current data.
	 * Kinda fills stuff in detween those two.	 *
	 * @param currentX
	 */
	public function setSteps(currentX:Number):void
	{
		for (var i:int = 0; i < OpponentField.SYNC_FREQUENCY; i++)
		{
			var sd:StepData = new StepData();
			_stepsData.push(sd);
		}

		//now when stepData is filled we can calculate realTargetX & make adjustments
		var xDiff:Number = _targetX - currentX;
		for (i = 0; i < OpponentField.SYNC_FREQUENCY; i++) //distribute all difference via parabola
		{
			_stepsData[i].xToAdd = getXOffsetByIndex(i, OpponentField.SYNC_FREQUENCY, xDiff);
		}
	}

	/**
	 * Simply returns velocity which must be added at certain sync point (without calculating it).
	 * @param index
	 * @return
	 */
	public function getVelocityChangeByIndex(index:int):StepData
	{
		return _stepsData[index];
	}

	/**
	 * Gets amount of X which will be added to bouncer.x for fixing async.
	 * @param index
	 * @param amountOfItems
	 * @param totalAmountToBeDistributed
	 * @return
	 */
	private static function getXOffsetByIndex(index:int, amountOfItems:int, totalAmountToBeDistributed:Number):Number
	{
		return getXOffsetPercentByIndex(index, amountOfItems) * totalAmountToBeDistributed;
	}

	/**
	 * Returns offset percent (0...1) which is 0 for start & end sync points, low for those closer to center, highest for middle point.
	 * Uses upside down wide parabola function.
	 * @param index
	 * @return
	 */
	private static function getXOffsetPercentByIndex(index:int, amountOfItems:int):Number
	{
		var sum:Number = 0;
		for (var i:int = 0; i < amountOfItems; i++)
		{
			sum += upwardParabola(i);
		}
		return upwardParabola(index) / sum;
	}

	private static function upwardParabola(x:Number):Number
	{
		return - Math.pow((x - 4), 2) * 0.05 + 0.8;
	}
}
}
