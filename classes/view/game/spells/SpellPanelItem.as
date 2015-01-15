/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 1:06 AM
 */
package view.game.spells
{
	import caurina.transitions.Tweener;

	import flash.display.MovieClip;
    import flash.events.MouseEvent;

    import model.PopupsManager;

    import model.constants.GameConfig;
	import model.requests.GameRequest;
    import model.userData.UserData;

    import utils.MovieClipContainer;
	import utils.TimeMask;

	import view.popups.myspells.SpellItem;

	public class SpellPanelItem extends MovieClipContainer
	{
		public var spellName:String = "somename";
		private var _timeMask:TimeMask;
		private var _lastUse:Date;
		private var _cooldownTime:int;
		private var _cooledDown:Boolean = true;

		public function SpellPanelItem()
		{
			super(new powerupitem());
            _mc.exp.visible = false;
		}

		public function setSpellItem(spellName:String, forPlayerField:Boolean):void
		{
			_cooldownTime = GameConfig.getCooldownTimeByRequest(GameRequest.getRequestBySpellName(spellName));

			this.spellName = spellName;
			var si:MovieClip = new skillIcon();
			si.gotoAndStop(SpellItem.getFrameNumberForSpell(spellName));
			_mc.bg_mc.addChild(si);
			_mc.em_txt.visible = false;

			_timeMask = new TimeMask(30, 30, 45);
			_timeMask.rotation = 270;
			_timeMask.alpha = 0.7;
			si.cool_mc.addChild(_timeMask);

            if (forPlayerField && UserData.spellsConfiguration.spellIsExpired(spellName))
                showExpired();
		}

		public function useMe():void
		{
			_lastUse = new Date();
			_cooledDown = false;
			_mc.usage_mc.play();
		}

		public function tick():void
		{
			if (!_cooledDown && _cooldownTime > 0) //_cooldownTime > 0 <--- that is paranoid a little bit :)
			{
				var span:int = new Date().time - _lastUse.time;
				if (span < _cooldownTime) //not cooled down yet
				{
					_timeMask.updatePicture(360 - 360 * (span / _cooldownTime), 0xFFFFFF);
				}
				else
				{
					_cooledDown = true;
					_timeMask.updatePicture(0);
				}
			}
		}

		public function onGameFinish():void
		{
			if (!_cooledDown && _timeMask)
			    Tweener.addTween(_timeMask, {alpha:0, time:1, transition:"easeOutSine"});
		}

        public function showExpired():void
        {
            _mc.exp.visible = true;
            buttonMode = true;
            addEventListener(MouseEvent.CLICK, dispatchActivate);
        }

        private function dispatchActivate(event:MouseEvent):void
        {
            PopupsManager.showActivateSpellPopop(spellName);
        }

        public function hideExpired():void
        {
            _mc.exp.visible = false;
            buttonMode = false;
            removeEventListener(MouseEvent.CLICK, dispatchActivate);
        }
    }
}
