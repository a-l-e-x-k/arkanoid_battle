/**
 * Author: Alexey
 * Date: 8/19/12
 * Time: 4:11 PM
 */
package view.tooltips
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import model.constants.GameConfig;
	import model.requests.GameRequest;
	import model.userData.Spells;

	import utils.Misc;
	import utils.MovieClipContainer;

	public class SpellTooltip extends MovieClipContainer
	{
		private const TOOLTIP_MARGIN:int = 8; //px
		private const TOOLTIP_DELAY:int = 500; //in ms

		private static var instance:SpellTooltip;

		private var _gottaShowTooltip:Boolean;
		private var _xShift:int;
		private var _yShift:int;

		public static function getInstance():SpellTooltip
		{
			if (instance == null)
				instance = new SpellTooltip(new SingletonEnforcer());
			return instance;
		}

		public function SpellTooltip(singletonEnforcer:SingletonEnforcer)
		{
			super(new spetooltip());
			hide();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function onAdded(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			if (visible)
				updatePosition();
		}

		public function setSpell(spellName:String, xShift:int = 0, yShift:int = 0):void
		{
			_xShift = xShift;
			_yShift = yShift;

			var defensive:Boolean = Spells.isSpellDefensive(spellName);
			if (defensive)
			{
				_mc.name_txt.text = Spells.getFullSpellName(spellName);
				_mc.name_agr_txt.visible = false;
				_mc.name_txt.visible = true;
			}
			else
			{
				_mc.name_agr_txt.text = Spells.getFullSpellName(spellName);
				_mc.name_txt.visible = false;
				_mc.name_agr_txt.visible = true;
			}

			_mc.description_txt.text = Spells.getSpellDescription(spellName);
			var ct:int = GameConfig.getCooldownTimeByRequest(GameRequest.getRequestBySpellName(spellName));
			_mc.cooldown_txt.text = (ct / 1000) + " sec";
		}

		public function wannaShow():void
		{
			_gottaShowTooltip = true;
			Misc.delayCallback(tryShowToolTip, TOOLTIP_DELAY);
		}

		private function tryShowToolTip():void
		{
			if (_gottaShowTooltip)
			{
				show();
				_gottaShowTooltip = false;
			}
		}

		private function show():void
		{
			visible = true;
			updatePosition();
		}

		public function updatePosition():void
		{
			x = stage.mouseX + TOOLTIP_MARGIN + _xShift;
			y = stage.mouseY - TOOLTIP_MARGIN + _yShift - this.height;
		}

		public function hide():void
		{
			visible = false;
			_gottaShowTooltip = false;
		}
	}
}

class SingletonEnforcer
{
}
