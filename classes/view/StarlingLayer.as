/**
 * Author: Alexey
 * Date: 8/31/12
 * Time: 11:26 PM
 */
package view
{
	import model.StarlingTextures;

	import starling.core.Starling;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import view.game.ball.ColoredBallsManager;
	import view.game.curveAnimations.CurveAnimations;
	import view.game.curveAnimations.PrefreezeEffectManager;

	/**
	 * Instance of this class is the first object added to the Starling stage
	 * This is the place to which game fields are added
	 */
	public class StarlingLayer extends Sprite
	{
		public var gameFieldLayer:Sprite;
		public var curveAnimations:CurveAnimations;
		public var prefreezeAnimationsLayer:Sprite;

		public function StarlingLayer()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event):void
		{
			//TODO: use it for stats.
			var isHW:Boolean = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
			trace("StarlingLayer : init : Hardware mode: " + isHW);

			StarlingTextures.init(); //will create all the textures needed for this game (from movieclips & shapes as well)
			ColoredBallsManager.init();

			var bg:Image = new Image(StarlingTextures.getTexture(StarlingTextures.GAME_BG));
			bg.blendMode = BlendMode.NONE;
			addChild(bg);

			gameFieldLayer = new Sprite();
			addChild(gameFieldLayer); //here field will be added

			curveAnimations = new CurveAnimations();
			addChild(curveAnimations);

			prefreezeAnimationsLayer = new Sprite();
			addChild(prefreezeAnimationsLayer);

			touchable = false;
		}
	}
}
