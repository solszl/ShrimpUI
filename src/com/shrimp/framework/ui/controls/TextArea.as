package com.shrimp.framework.ui.controls
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class TextArea extends TextInput
	{
		public function TextArea(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="")
		{
			super(parent, xpos, ypos, text);
			setActualSize(100, 100);
		}

		private var scroll:VScrollBar;
		private var lineHeight:Number;

		override protected function createChildren():void
		{
			super.createChildren();
			addChild(scroll=new VScrollBar());
			_textField.wordWrap=true;
			_textField.multiline=true;
			_textField.addEventListener(Event.SCROLL, onTextFieldScroll);
			scroll.addEventListener(Event.CHANGE, onScrollBarChange);
		}

		private function onTextFieldScroll(e:Event):void
		{
			lineHeight=_textField.textHeight;
			if (_textField.maxScrollV < 2)
			{
				scroll.visible=false;
			}
			else
			{
				scroll.visible=true;
				scroll.target=this;
				scroll.thumbPercent=(_textField.numLines - _textField.maxScrollV + 1) / _textField.numLines;
				scroll.tick=lineHeight;
				scroll.setSliderParams(lineHeight, _textField.maxScrollV * lineHeight, _textField.scrollV * lineHeight);
			}
		}

		private function onScrollBarChange(e:Event):void
		{
			var scrollValue:int=scroll.value / lineHeight;
			if (_textField.scrollV != scrollValue)
			{
				_textField.removeEventListener(Event.SCROLL, onTextFieldScroll);
				_textField.scrollV=scrollValue;
				_textField.addEventListener(Event.SCROLL, onTextFieldScroll);
			}
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			_textField.width=_textField.width - scroll.width - 2;
			_textField.height=_height;
			scroll.height=_height;
			scroll.x=_width - scroll.width;
			scroll.y=0;
		}

		/**滚动条实体*/
		public function get scrollBar():VScrollBar
		{
			return scroll;
		}

		/**垂直滚动最大值*/
		public function get maxScrollV():int
		{
			return _textField.maxScrollV;
		}

		/**滚动到某个位置，单位是行*/
		public function scrollTo(line:int):void
		{
			measure();
			_textField.scrollV=line;
		}
	}
}
