/**
 * Author: Alexey
 * Date: 5/17/12
 * Time: 10:50 PM
 */
package view.game.bouncer
{
	import model.StarlingTextures;
	import model.constants.GameConfig;
    import model.userData.UserData;

    import starling.display.Image;
	import starling.display.Sprite;

	import utils.Misc;

	/**
	 * Basic bouncer. Velocity may be changed from outside (Opponent's field) only.
	 */
	public class Bouncer extends Sprite
	{
		private var _preciseX:Number = 0;
		private var _preciseY:Number = 0;

		public function Bouncer(bouncerID:String)
		{
			addChild(new Image(StarlingTextures.getTexture(bouncerID)));
			addChild(new Image(StarlingTextures.getTexture(StarlingTextures.PANEL_HITTEST_AREA)));
		}

		override public function get x():Number
		{
			return _preciseX;
		}

		override public function get y():Number
		{
			return _preciseY;
		}

		override public function set x(value:Number):void
		{
			_preciseX = Misc.floorWithPrecision(value, 3);
			super.x = value; //for visual stuff
		}

		override public function set y(value:Number):void
		{
			_preciseY = Misc.floorWithPrecision(value, 3);
			super.y = value; //for visual stuff
		}
	}
}
