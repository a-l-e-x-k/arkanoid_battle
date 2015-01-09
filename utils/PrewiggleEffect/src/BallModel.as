/**
 * Author: Alexey
 * Date: 11/10/12
 * Time: 1:44 AM
 */
package
{
	public class BallModel
	{
		public var x:Number;
		public var y:Number;
		public var name:String;

		private var _xVel:Number;
		private var _yVel:Number;

		public function BallModel()
		{
			x = 450 + Math.random() * 200;
			y = 50 + Math.random() * 400;
			name = (Math.random() * 1000000000).toString();

			_xVel = Math.random() - 0.5;
			_yVel = Math.random() - 0.5;
		}

		public function move():void
		{
		   x += _xVel;
		   y += _yVel;
		}
	}
}
