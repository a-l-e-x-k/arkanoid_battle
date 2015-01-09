/**
 * Author: Alexey
 * Date: 10/14/12
 * Time: 1:13 AM
 */
package model
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import model.game.bricks.BrickPresets;
	import model.constants.GameConfig;

	import starling.dynamicTextureAtlasGenerator.src.com.emibap.textureAtlas.DynamicAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import utils.snapshoter.Snapshoter;

	/**
	 * Creates and stores textures, generated from flash MovieClip symbols
	 */
	public class StarlingTextures
	{
		public static const SIMPLE_BRICK_ORANGE:String = "0"; //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_GREEN:String = "1"; //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_YELLOW:String = "2"; //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_RED:String = "3";    //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_BLUE:String = "4";   //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_PURPLE:String = "5";  //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_PINK:String = "6";    //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_WHITE:String = "7";   //matches id of brick (from BrickPresets)
		public static const SIMPLE_BRICK_DARK_GREY:String = "8";//matches id of brick (from BrickPresets)

		public static const STRONG_BRICK:String = "9";  //matches id of brick (from BrickPresets)
		public static const BOMB_BRICK:String = "10";  //matches id of brick (from BrickPresets)
		public static const FIRE_BRICK:String = "11"; //matches id of brick (from BrickPresets)

		public static const BALL:String = "ball";
		public static const POINTS_CELL_CLEARED:String = "pointsCellCleared";
		public static const POINTS_LOST_BALL:String = "pointsLostBall";
		public static const POINTS_MEGA:String = "pointsMega";
		public static const FIELD_BLACK_BG:String = "fieldBlackBg";
		public static const GAME_BG:String = "gamebg";
		public static const BALL_HITTEST_AREA:String = "ballHittestArea";
		public static const MISS_POPUP:String = "missPopup";
		public static const OPPONENT_LOST_POPUP:String = "opponentLostPopup";
		public static const OPPONENT_WON_POPUP:String = "opponentWonPopup";
		public static const PANEL_HITTEST_AREA:String = "panelHittestArea";
		public static const BRICK_HITTEST_AREA_RED:String = "panelHittestAreaRed";
		public static const BRICK_HITTEST_AREA_GREY:String = "panelHittestAreaGrey";
		public static const FIREBALL:String = "fireball";
		public static const FIELD_SURROUND_BG:String = "fieldSurroundBg";
		public static const EXAMPLE_AVATAR:String = "example";
		public static const POINTS_COUNTER_BG:String = "pointsCounterBg";
		public static const FREEEZE_OVERLAY:String = "freezeOverlay";
		public static const LASER_BULLET:String = "laserBullet";

        public static const BOUNCER_STANDART_RED:String = "bouncerStandartRed";
        public static const BOUNCER_STANDART_BLUE:String = "bouncerStandartBlue";
        public static const BOUNCER_STANDART_GREEN:String = "bouncerStandartGreen";
        public static const BOUNCER_STANDART_PURPLE:String = "bouncerStandartPurple";

        public static const BOUNCER_CHECKED_RED:String = "bouncerCheckedRed";
        public static const BOUNCER_CHECKED_BLUE:String = "bouncerCheckedBlue";
        public static const BOUNCER_CHECKED_PURPLE:String = "bouncerCheckedPurple";
        public static const BOUNCER_CHECKED_BLACK:String = "bouncerCheckedBlack";

        public static const BOUNCER_ZAPPER_RED:String = "bouncerZapperRed";
        public static const BOUNCER_ZAPPER_BLUE:String = "bouncerZappeBlue";
        public static const BOUNCER_ZAPPER_PURPLE:String = "bouncerZapperPurple";
        public static const BOUNCER_ZAPPER_BLACK:String = "bouncerZapperBlack";

        public static const BOUNCER_ELECTRO_RED:String = "bouncerElectroRed";
        public static const BOUNCER_ELECTRO_BLUE:String = "bouncerElectroBlue";
        public static const BOUNCER_ELECTRO_PURPLE:String = "bouncerElectroPurple";
        public static const BOUNCER_ELECTRO_BLACK:String = "bouncerElectroBlack";

        public static const BOUNCER_PERFETTO_RED:String = "bouncerPerfettoRed";
        public static const BOUNCER_PERFETTO_BLUE:String = "bouncerPerfettoBlue";
        public static const BOUNCER_PERFETTO_PURPLE:String = "bouncerPerfettoPurple";
        public static const BOUNCER_PERFETTO_BLACK:String = "bouncerPerfettoBlack";

		private static var textures:Dictionary = new Dictionary();

		public static function init():void
		{
			var ta:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new starli());
			textures[GAME_BG] = ta.getTextures("bg")[0];

			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0x040404);
			spr.graphics.drawRect(0, 0, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);
			spr.graphics.endFill();
			snapshotAndAdd(spr, FIELD_BLACK_BG);

			spr = new Sprite();
			spr.graphics.beginFill(0xff0000, 0.7);
			spr.graphics.drawCircle(GameConfig.BALL_RADIUS, GameConfig.BALL_RADIUS, GameConfig.BALL_RADIUS);
			spr.graphics.endFill();
			snapshotAndAdd(spr, BALL_HITTEST_AREA);

			spr = new Sprite();
			spr.graphics.clear();
			spr.graphics.lineStyle(3, 0xff0000, Config.UGLY_LOOK ? 1 : 0);
			spr.graphics.lineTo(0, 0);
			spr.graphics.lineTo(GameConfig.BOUNCER_WIDTH, 0);
			snapshotAndAdd(spr, PANEL_HITTEST_AREA);

			spr = new Sprite();
			spr.graphics.beginFill(0xCCCCCC, 0); //so mouse clicks are triggereed
			spr.graphics.lineStyle(1, 0x000000, 0);
			spr.graphics.lineTo(GameConfig.BRICK_WIDTH, 0);
			spr.graphics.lineTo(GameConfig.BRICK_WIDTH, GameConfig.BRICK_HEIGHT);
			spr.graphics.lineTo(0, GameConfig.BRICK_HEIGHT);
			spr.graphics.lineTo(0, 0);
			spr.graphics.endFill();
			snapshotAndAdd(spr, BRICK_HITTEST_AREA_GREY);

			spr = new Sprite();
			spr.graphics.beginFill(0x990000, 0); //so mouse clicks are triggereed
			spr.graphics.lineStyle(1, 0x000000, 0);
			spr.graphics.lineTo(GameConfig.BRICK_WIDTH, 0);
			spr.graphics.lineTo(GameConfig.BRICK_WIDTH, GameConfig.BRICK_HEIGHT);
			spr.graphics.lineTo(0, GameConfig.BRICK_HEIGHT);
			spr.graphics.lineTo(0, 0);
			spr.graphics.endFill();
			snapshotAndAdd(spr, BRICK_HITTEST_AREA_RED);

			var mc:MovieClip = new ballmc();
			mc.gotoAndStop(2);
			snapshotAndAdd(mc, BALL);
			snapshotAndAdd(new flyCellCleared(), POINTS_CELL_CLEARED);
			snapshotAndAdd(new flyLostBall(), POINTS_LOST_BALL);
			snapshotAndAdd(new flyMega(), POINTS_MEGA);
			snapshotAndAdd(new miss(), MISS_POPUP);
			snapshotAndAdd(new userlostpop(), OPPONENT_LOST_POPUP);
			snapshotAndAdd(new userwonpop(), OPPONENT_WON_POPUP);
			snapshotAndAdd(new fireball(), FIREBALL);
            snapshotAndAdd(new fieldbg(), FIELD_SURROUND_BG);
            snapshotAndAdd(new ptscounter(), POINTS_COUNTER_BG);
            snapshotAndAdd(new exampleAvatar(), EXAMPLE_AVATAR);
            snapshotAndAdd(new freezeOverlay(), FREEEZE_OVERLAY);
            snapshotAndAdd(new laserBullet(), LASER_BULLET);

            snapshotAndAdd(new panelstartb(), BOUNCER_STANDART_BLUE);
            snapshotAndAdd(new starpanelg(), BOUNCER_STANDART_GREEN);
            snapshotAndAdd(new starpanelp(), BOUNCER_STANDART_PURPLE);
            snapshotAndAdd(new starpanelr(), BOUNCER_STANDART_RED);

            snapshotAndAdd(new checkedoutbl(), BOUNCER_CHECKED_BLACK);
            snapshotAndAdd(new checkedoutp(), BOUNCER_CHECKED_PURPLE);
            snapshotAndAdd(new checkedoutb(), BOUNCER_CHECKED_BLUE);
            snapshotAndAdd(new chedoutr(), BOUNCER_CHECKED_RED);

            snapshotAndAdd(new zapperbl(), BOUNCER_ZAPPER_BLACK);
            snapshotAndAdd(new zapperb(), BOUNCER_ZAPPER_BLUE);
            snapshotAndAdd(new zapperp(), BOUNCER_ZAPPER_PURPLE);
            snapshotAndAdd(new zapperr(), BOUNCER_ZAPPER_RED);

            snapshotAndAdd(new electroblack(), BOUNCER_ELECTRO_BLACK);
            snapshotAndAdd(new electroblue(), BOUNCER_ELECTRO_BLUE);
            snapshotAndAdd(new electropurple(), BOUNCER_ELECTRO_PURPLE);
            snapshotAndAdd(new electrored(), BOUNCER_ELECTRO_RED);

            snapshotAndAdd(new perfettoblack(), BOUNCER_PERFETTO_BLACK);
            snapshotAndAdd(new perfettoblue(), BOUNCER_PERFETTO_BLUE);
            snapshotAndAdd(new perfettopur(), BOUNCER_PERFETTO_PURPLE);
            snapshotAndAdd(new perfettored(), BOUNCER_PERFETTO_RED);

            snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.BOMB_BRICK), BOMB_BRICK);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_ORANGE), SIMPLE_BRICK_ORANGE);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_GREEN), SIMPLE_BRICK_GREEN);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_YELLOW), SIMPLE_BRICK_YELLOW);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_RED), SIMPLE_BRICK_RED);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_BLUE), SIMPLE_BRICK_BLUE);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_PURPLE), SIMPLE_BRICK_PURPLE);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_PINK), SIMPLE_BRICK_PINK);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_WHITE), SIMPLE_BRICK_WHITE);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.SIMPLE_BRICK_DARK_GREY), SIMPLE_BRICK_DARK_GREY);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.STRONG_BRICK), STRONG_BRICK);
			snapshotAndAdd(BrickPresets.getToolMCByID(BrickPresets.FIRE_BRICK), FIRE_BRICK);
		}

		private static function snapshotAndAdd(whatToSnapshot:IBitmapDrawable, type:String):void
		{
			var width:Number = whatToSnapshot is DisplayObject ? (whatToSnapshot as DisplayObject).width : (whatToSnapshot as BitmapData).width;
			var height:Number = whatToSnapshot is DisplayObject ? (whatToSnapshot as DisplayObject).height : (whatToSnapshot as BitmapData).height;
			var bmp:Bitmap = Snapshoter.snapshot(whatToSnapshot, width, height, true, 0xFFF000);
			textures[type] = Texture.fromBitmap(bmp);
			bmp.bitmapData.dispose();
		}

		public static function getTexture(textureType:String):Texture
		{
			return textures[textureType];
		}
	}
}
