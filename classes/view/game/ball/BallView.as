/**
 * Author: Alexey
 * Date: 8/31/12
 * Time: 9:31 PM
 */
package view.game.ball
{
	import external.caurina.transitions.Tweener;

	import model.StarlingTextures;
    import model.constants.GameConfig;

    import starling.display.Image;
	import starling.display.Sprite;

	public class BallView extends Sprite
	{
		private var _path:BallPath;

		public function BallView()
		{
			this.name = (Math.random() * 1000000000).toString(); //for SmartLightningGroup (dictionary of balls)

			_path = new BallPath(BallPath.TYPE_SIMPLE);
			_path.y = 4.5; //artificial shift
			addChild(_path);

			if (Config.UGLY_LOOK)
			{
                var i:Image = new Image(StarlingTextures.getTexture(StarlingTextures.BALL_HITTEST_AREA));
                i.x -= GameConfig.BALL_RADIUS;
				addChild(i);
			}
		}

		public function showPath():void
		{
			_path.alpha = 1;
		}

		public function hidePath():void
		{
			_path.alpha = 0;
		}

		public function updateAngle(angle:Number):void
		{
			_path.updateAngle(angle);
		}

		public function cleanUp():void
		{
			_path.cleanUp();
		}

		public function updateCoordinates(x:Number, y:Number, slowdownCoefficient:Number):void
		{
			this.x = x;
			this.y = y;
			_path.update(slowdownCoefficient);
		}

		public function goStealth():void
		{
			Tweener.addTween(_path, {alpha:0.2, time:1, transition:"easeOutSine"});
		}

		public function goOutOfStealth():void
		{
			Tweener.addTween(_path, {alpha:1, time:1, transition:"easeOutSine"});
		}

		public function get path():BallPath
		{
			return _path;
		}
	}
}
