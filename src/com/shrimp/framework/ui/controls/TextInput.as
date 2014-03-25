package com.shrimp.framework.ui.controls
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;

	/**
	 *	文本输入框
	 * @author Sol
	 *
	 */
	[Event(name="change", type="flash.events.Event")]
	[Event(name="textInput", type="flash.events.Event")]
	public class TextInput extends Label
	{
		public function TextInput(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="")
		{
			super(parent, xpos, ypos, text);
			setActualSize(128, 22);
			selectable=true;
			_textField.type=TextFieldType.INPUT;
			_textField.autoSize="none";
			_textField.addEventListener(Event.CHANGE, onTextFieldChange);
			_textField.addEventListener(TextEvent.TEXT_INPUT, onTextFieldTextInput);
		}

		private function onTextFieldTextInput(e:TextEvent):void
		{
			dispatchEvent(e);
		}

		protected function onTextFieldChange(e:Event):void
		{
			text=_textField.text;
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**指示用户可以输入到控件的字符集*/
		public function get restrict():String
		{
			return _textField.restrict;
		}

		public function set restrict(value:String):void
		{
			_textField.restrict=value;
		}

		/**是否可编辑*/
		public function get editable():Boolean
		{
			return _textField.type == TextFieldType.INPUT;
		}

		public function set editable(value:Boolean):void
		{
			_textField.type=value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}

		/**最多可包含的字符数*/
		public function get maxChars():int
		{
			return _textField.maxChars;
		}

		public function set maxChars(value:int):void
		{
			_textField.maxChars=value;
		}

		public function set displayAsPassword(b:Boolean):void
		{
			_textField.displayAsPassword=b;
		}

		public function get displayAsPassword():Boolean
		{
			return _textField.displayAsPassword;
		}
	}
}
