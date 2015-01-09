package view.buttons
{
	import events.RequestEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public class BasicButton extends Sprite
	{
		private var TEXT_OUT_COLOR:uint = 0x999999;
		private var TEXT_OVER_COLOR:uint = 0xCCCCCC;
		private const BG_ALPHA:Number = 0.36;
		private const TEXT_PADDING:int = 8; //10px
		
		private var _bg:Sprite = new Sprite();
		private var _textField:TextField = new TextField();
		private var _savesState:Boolean = false;
		private var _stateSet:Boolean = false;
		
		public function BasicButton(x:Number, y:Number, text:String, savesState:Boolean = false) 
		{
			this.x = x;
			this.y = y;			
			
			_savesState = savesState;
			
			var textFormat:TextFormat = new TextFormat("Verdana", 11, TEXT_OVER_COLOR, true);
			_textField.text = text;
			_textField.selectable = false;
			_textField.width = _textField.textWidth + TEXT_PADDING * 4;
			_textField.height = _textField.textHeight + TEXT_PADDING * 4;
			_textField.setTextFormat(textFormat);
			_textField.x = TEXT_PADDING - 1;
			_textField.y = TEXT_PADDING - 3;
			
			var bgWidth:Number = _textField.textWidth + TEXT_PADDING * 2;
			var bgHeight:Number = _textField.textHeight + TEXT_PADDING * 2;
			
			_bg.graphics.beginFill(TEXT_OVER_COLOR, BG_ALPHA);
			_bg.graphics.drawRoundRect(0, 0, bgWidth, bgHeight, 18);
			_bg.graphics.endFill();
			
			addChild(_bg);
			addChild(_textField);
			
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.CLICK, onClick);
			
			setOutState();
		}
		
		private function onOver(e:MouseEvent):void 
		{
			setOverState();
		}
		
		private function onOut(e:MouseEvent):void 
		{
			if(!(_savesState && _stateSet)) setOutState();
		}
		
		public function setOverState():void
		{
			_bg.alpha = BG_ALPHA;
			_textField.textColor = TEXT_OVER_COLOR;
		}
		
		public function setOutState():void
		{
			_bg.alpha = 0;
			_textField.textColor = TEXT_OUT_COLOR;
			_stateSet = false;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (_savesState) _stateSet = true;
			dispatchEvent(new RequestEvent(RequestEvent.IMREADY));
		}
		
		public function get stateSet():Boolean 
		{
			return _stateSet;
		}
		
		public function set stateSet(value:Boolean):void 
		{
			_stateSet = value;
		}
		
	}

}