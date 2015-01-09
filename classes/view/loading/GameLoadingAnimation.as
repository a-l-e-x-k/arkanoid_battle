package view.loading
{
	import utils.*;

	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class GameLoadingAnimation extends MovieClipContainer
	{
		public function GameLoadingAnimation(xx:int = 0, yy:int = 0, atScreeenCenter:Boolean = false)
		{
			super(new loadingAnim(), xx, xx);

			if (atScreeenCenter)
			{
				x = (Config.APP_WIDTH - _mc.width) / 2;
				y = (Config.APP_HEIGHT - _mc.height) / 2;
			}
		}

	}

}