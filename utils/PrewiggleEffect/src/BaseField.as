/**
 * Author: Alexey
 * Date: 5/16/12
 * Time: 10:59 PM
 */
package
{
	import flash.display.Sprite;

	/**
	 * Contains logic which is same for both OpponentField & PlayerField.
	 */
	public class BaseField extends Sprite
	{
		public var balls:Vector.<BallModel> = new Vector.<BallModel>() //all balls (from BallsManager)

		public function BaseField()
		{
			for (var i:int = 0; i < 5; i++)
			{
				var b:BallModel = new BallModel();
				balls.push(b);
			}
		}

		public function moveBalls():void
		{
			for each (var ballModel:BallModel in balls)
			{
				ballModel.move();
			}
		}
	}
}