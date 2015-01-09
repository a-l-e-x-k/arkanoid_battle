/**
 * Author: Alexey
 * Date: 7/3/12
 * Time: 10:57 PM
 */
package view.game.playerInfo
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	import model.StarlingTextures;
	import model.game.playerInfo.PlayerData;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;

	import utils.snapshoter.Snapshoter;

	public class PlayerInfo extends Sprite
	{
		private var _points:int = 0;
		private var _uid:String;

		private var _flashyTexts:MovieClip; //all fonts contents are rendered from here to the GPU
		private var _starlingyTexts:Image;

		public function PlayerInfo()
		{
            //TODO: show rank

			var avatar:Image = new Image(StarlingTextures.getTexture(StarlingTextures.EXAMPLE_AVATAR));
			avatar.y = 4;
			addChild(avatar);

			var counterBg:Image = new Image(StarlingTextures.getTexture(StarlingTextures.POINTS_COUNTER_BG));
			counterBg.x = 61;
			counterBg.y = 23;
			addChild(counterBg);

			_flashyTexts = new plinfotexts();

			renderTexts();
			updateCounter();
		}

		private function renderTexts():void
		{
			var snap:Bitmap = Snapshoter.snapshot(_flashyTexts, _flashyTexts.width, _flashyTexts.height, true);

			if(_starlingyTexts)
				_starlingyTexts.removeFromParent(true);

			_starlingyTexts = Image.fromBitmap(snap);
			_starlingyTexts.x = 60;
			_starlingyTexts.y = -2;
			addChild(_starlingyTexts);

			snap.bitmapData.dispose();
		}

		public function fillFromPlayerData(playerData:PlayerData):void
		{
			_flashyTexts.dude_name.text = playerData.name;
			_uid = playerData.uid;
			renderTexts();
		}

		public function get points():int
		{
			return _points;
		}

		public function addPoints(amount:int):void
		{
			_points += amount;
			updateCounter();
		}

		private function updateCounter():void
		{
			var ones:int = _points % 10;
			var tens:int = Math.floor(_points / 10) % 10;
			var hundreds:int = Math.floor(_points / 100) % 10;
			var thousands:int = Math.floor(_points / 1000) % 10;
			var tensThousands:int = Math.floor(_points / 10000) % 10;
			var hundredsThousands:int = Math.floor(_points / 100000) % 10;

			_flashyTexts.ones_txt.text = ones.toString();
			_flashyTexts.tens_txt.text = tens.toString();
			_flashyTexts.hundreds_txt.text = hundreds.toString();
			_flashyTexts.thousands_txt.text = thousands.toString();
			_flashyTexts.tensThousands_txt.text = tensThousands.toString();
			_flashyTexts.hundredsThousands_txt.text = hundredsThousands.toString();

			renderTexts();
		}

		public function get uid():String
		{
			return _uid;
		}
	}
}
