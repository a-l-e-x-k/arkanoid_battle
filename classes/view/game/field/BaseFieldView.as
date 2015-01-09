/**
 * Author: Alexey
 * Date: 9/1/12
 * Time: 1:26 AM
 */
package view.game.field
{
	import flash.geom.Rectangle;

	import model.StarlingTextures;
	import model.constants.GameConfig;

	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ClippedSprite;
	import starling.textures.Texture;

	import view.game.fire.FireThings;
	import view.game.playerInfo.PlayerInfo;

	/**
	 * Used for adding visual representation of player field to starling layer
	 * All the stuff added here will be rendered by starling
	 */
	public class BaseFieldView extends Sprite
	{
		private var _fireThings:FireThings;
		private var _playerInfo:PlayerInfo;
		private var _wiggleImagesContainer:ClippedSprite;
		private var _fieldCellsLayer:Sprite;
		private var _bouncerLayer:Sprite;
		private var _ballsLayer:ClippedSprite;
		private var _laserBulletsLayer:ClippedSprite;
		private var _freezeOverlay:FreezeOverlay;

		public function BaseFieldView()
		{
			var surroundings:Image = new Image(StarlingTextures.getTexture(StarlingTextures.FIELD_SURROUND_BG));
			surroundings.x = - 16;
			surroundings.y = - 74;
			addChild(surroundings);

			var img:Image = new Image(StarlingTextures.getTexture(StarlingTextures.FIELD_BLACK_BG));
			img.blendMode = BlendMode.NONE;
			addChild(img);

			_playerInfo = new PlayerInfo();
			_playerInfo.x = 76;
			_playerInfo.y = -64;
			addChild(_playerInfo);

			//	_view.clipRect = new Rectangle(_view.x, _view.y, BaseFieldView.VIEW_WIDTH, BaseFieldView.VIEW_HEIGHT);
			// when clipRect is setm filters are not being rendered

			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			_fireThings = new FireThings();
			_fireThings.clipRect = new Rectangle(x, y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);  // masks flames' excesses, view.popups excesses
			addChild(_fireThings);

			_wiggleImagesContainer = new ClippedSprite();
			_wiggleImagesContainer.clipRect = new Rectangle(x, y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);
			addChild(_wiggleImagesContainer);

			_fieldCellsLayer = new Sprite();
			addChild(_fieldCellsLayer);

			_bouncerLayer = new Sprite();
			addChild(_bouncerLayer);

			_ballsLayer = new ClippedSprite();
			_ballsLayer.clipRect = new Rectangle(x, y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);
			addChild(_ballsLayer);

            _laserBulletsLayer = new ClippedSprite();
            _laserBulletsLayer.clipRect = new Rectangle(x, y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX - 35); //don't show bullets which are yet below bouncer
            addChild(_laserBulletsLayer);

			_freezeOverlay = new FreezeOverlay();
			_freezeOverlay.clipRect = new Rectangle(x, y, GameConfig.FIELD_WIDTH_PX, GameConfig.FIELD_HEIGHT_PX);
			_freezeOverlay.alpha = 0;
			addChild(_freezeOverlay);
		}

		public function showSpeedUpFires():void
		{
			_fireThings.showFire();
		}

		public function showSmoke():void
		{
			_fireThings.showSmoke();
		}

		public function cleanUp():void
		{
			_fireThings.cleanUp();
		}

		public function get playerInfo():PlayerInfo
		{
			return _playerInfo;
		}

		public function get wiggleImagesContainer():ClippedSprite
		{
			return _wiggleImagesContainer;
		}

		public function get freezeOverlay():FreezeOverlay
		{
			return _freezeOverlay;
		}

		public function get fieldCellsLayer():Sprite
		{
			return _fieldCellsLayer;
		}

		public function get bouncerLayer():Sprite
		{
			return _bouncerLayer;
		}

		public function get ballsLayer():ClippedSprite
		{
			return _ballsLayer;
		}

        public function get laserBulletsLayer():ClippedSprite
        {
            return _laserBulletsLayer;
        }
    }
}
