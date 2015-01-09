/**
 * Author: Alexey
 * Date: 7/16/12
 * Time: 1:05 AM
 */
package view.game.spells
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import model.requests.GameRequest;
    import model.spells.SpellsAvailabilityChecker;

    import view.game.field.BaseField;
    import view.game.field.PlayerField;

    public class SpellsPanel extends Sprite
	{
        public static const ITEM_SIZE:int = 57;
		private var _powerupIcons:Vector.<SpellPanelItem> = new Vector.<SpellPanelItem>();
		private var _fieldLink:BaseField;

		public function SpellsPanel(configurationObject:Object, fieldLink:BaseField)
		{
			_fieldLink = fieldLink;

			x = 2;
			y = 399;

			for (var i:int = 0; i < 5; i++)
			{
				var powerupIcon:SpellPanelItem = new SpellPanelItem();
				powerupIcon.x = 20 + i * (ITEM_SIZE + 6);
				addChild(powerupIcon);
				_powerupIcons.push(powerupIcon);
			}

			for (var prop:String in configurationObject)
			{
				_powerupIcons[configurationObject[prop] - 1].setSpellItem(prop, fieldLink is PlayerField);
				if (fieldLink is PlayerField)
				{
					_powerupIcons[configurationObject[prop] - 1].buttonMode = true;
					_powerupIcons[configurationObject[prop] - 1].addEventListener(MouseEvent.CLICK, useSpellViaMouse);
				}
			}
		}

		public function tryUsePowerup(gameRequestID:int):void
		{
            var spellName:String = GameRequest.getSpellNameByRequest(gameRequestID);
            for each (var spellItem:SpellPanelItem in _powerupIcons)
            {
                if (spellItem.spellName == spellName)
                {
                    spellItem.useMe();
                }
            }
		}

		public function tick():void
		{
			for each (var spellPanelItem:SpellPanelItem in _powerupIcons)
			{
				spellPanelItem.tick();
			}
		}

		public function onGameFinish():void
		{
			for each (var spellPanelItem:SpellPanelItem in _powerupIcons)
			{
				spellPanelItem.onGameFinish();
				spellPanelItem.buttonMode = false;
				if (spellPanelItem.hasEventListener(MouseEvent.CLICK))
					spellPanelItem.removeEventListener(MouseEvent.CLICK, useSpellViaMouse);
			}
		}

		private function useSpellViaMouse(event:MouseEvent):void
		{
			var spellName:String = (event.currentTarget as SpellPanelItem).spellName;
			SpellsAvailabilityChecker.tryUseSpell(spellName, _fieldLink.gameLink.lastsFor, _fieldLink.gameLink.gameLength);
		}

        public function onSpellExpired(spellName:String):void
        {
            for each (var spellPanelItem:SpellPanelItem in _powerupIcons)
            {
                if (spellPanelItem.spellName == spellName)
                {
                    spellPanelItem.showExpired();
                    break;
                }
            }
        }

        public function onSpellActivated(spellName:String):void
        {
            for each (var spellPanelItem:SpellPanelItem in _powerupIcons)
            {
                if (spellPanelItem.spellName == spellName)
                {
                    spellPanelItem.hideExpired();
                    spellPanelItem.buttonMode = true;
                    break;
                }
            }
        }

        public function get powerupIcons():Vector.<SpellPanelItem>
        {
            return _powerupIcons;
        }
    }
}
