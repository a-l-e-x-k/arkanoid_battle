/**
 * Author: Alexey
 * Date: 7/7/12
 * Time: 1:44 AM
 */
package view.topBar
{
    import events.RequestEvent;

    import caurina.transitions.properties.SoundShortcuts;

    import flash.events.MouseEvent;

    import model.PopupsManager;

    import model.shop.ShopItemsInfo;
    import model.sound.SoundAssetManager;
    import model.userData.UserData;

    import utils.EventHub;
    import utils.MovieClipContainer;

    public class TopBar extends MovieClipContainer
	{
        private var _rankUnit:RankUnit;
        private var _energyUnit:EnergyUnit;

		public function TopBar()
		{
			super(new topbar(), 9, 6);

			_mc.spells_btn.addEventListener(MouseEvent.CLICK, dispatchSkillsClick);
            _mc.shop_btn.addEventListener(MouseEvent.CLICK, dispatchShopClick);
            _mc.coins_mc.add_btn.addEventListener(MouseEvent.CLICK, dispatchAddCoins);
            _mc.sound_btn.addEventListener(MouseEvent.CLICK, switchSound);
            _mc.music_btn.addEventListener(MouseEvent.CLICK, switchMusic);

            _energyUnit = new EnergyUnit();
            _energyUnit.x = 161;
            _energyUnit.y = 2;
            _mc.addChild(_energyUnit);

            _mc.sound_btn.mcc.no_mc.visible = !UserData.soundsOn;
            _mc.music_btn.mcc.no_mc.visible = !UserData.musicOn;

            EventHub.addEventListener(RequestEvent.SPELL_ACTIVATED_BY_CLIENT, update);
            EventHub.addEventListener(RequestEvent.PLAYER_UPDATED, update);

            update();
        }

        private function switchMusic(event:MouseEvent):void
        {
            if (UserData.musicOn)
            {
                SoundAssetManager.setMusicOff();
                _mc.music_btn.mcc.no_mc.visible = true;
            }
            else
            {
                SoundAssetManager.setMusicOn();
                _mc.music_btn.mcc.no_mc.visible = false;
            }
        }

        private function switchSound(event:MouseEvent):void
        {
            if (UserData.soundsOn)
            {
                SoundAssetManager.setSoundsOff();
                _mc.sound_btn.mcc.no_mc.visible = true;
            }
            else
            {
                SoundAssetManager.setSoundsOn();
                _mc.sound_btn.mcc.no_mc.visible = false;
            }
        }

        private static function dispatchAddCoins(event:MouseEvent):void
        {
            EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_ADD_COINS_POPUP));
        }

        private function update(e:RequestEvent = null):void
        {
            _energyUnit.update();
            _mc.coins_mc.coins_txt.text = UserData.coins;

            if (_rankUnit)
                _mc.removeChild(_rankUnit);
            _rankUnit = new RankUnit(UserData.rankNumber, UserData.rankProgress, UserData.rankProtectionCount);
            _rankUnit.x = 317;
            _rankUnit.y = 5;
            _mc.addChild(_rankUnit);
        }

		private static function dispatchShopClick(event:MouseEvent):void
		{
			EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_SHOP_POPUP));
		}

		private static function dispatchSkillsClick(event:MouseEvent):void
		{
			EventHub.dispatch(new RequestEvent(RequestEvent.SHOW_SKILLS_PANEL));
		}
	}
}
