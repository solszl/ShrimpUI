package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.GlobalConfig;
	import com.shrimp.framework.event.CloseEvent;
	import com.shrimp.framework.managers.PopUpManager;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.framework.utils.StringUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Alert extends Component
	{
		public static const YES:uint=0x0001;

		public static const NO:uint=0x0002;

		public static const OK:uint=0x0004;

		public static const CANCEL:uint=0x0008;

		public static var buttonWidth:Number=80;
		public static var buttonHeight:Number=28;
		public static var btnGap:Number=15;

		protected var buttons:Array=[];

		protected var textField:TextField;
		protected var titleField:TextField;

		protected var bg:DisplayObject;

		protected var buttonContainer:Sprite;

		protected static const MIN_WIDTH:int=320;
		protected static const MIN_HEIGHT:int=200;
		protected static const TITLE_HEIGHT:int=20;

		protected static var alertPool:Array=[];
		protected static var _closeHandler:Function;

		protected static var alert:Alert;
		private static const ALERT_BUTTON_PREFIX:String="alert_button_";
		protected var format:String="<p align='center'><font size='{0}' color='{1}' face='{3}'>{2}</font></p>";

		public function Alert(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		public static function show(text:String="", title:String="", flags:uint=0x4, closeHandler:Function=null, iconClass:Class=null, addX:int=0):Alert
		{
			alert=alertPool.length > 0 ? alertPool.pop() : new Alert();
			alert.flags=flags;
			alert.title=title;
			alert.text=text;
			alert.validateNow();

			PopUpManager.addPopUp(alert, null, true);
			PopUpManager.centerPopUp(alert);

			alert.x+=addX;

			_closeHandler=closeHandler;

			return alert;
		}

		override protected function createChildren():void
		{
			super.createChildren();

			bg=new (Style.alertBG);
			addChild(bg);

			textField=new TextField();
			textField.multiline=true;
			textField.wordWrap=true;
			textField.selectable=false;
			textField.htmlText=StringUtil.substitute(format, Style.fontSize, Style.LABEL_COLOR, text, Style.fontFamily);
			textField.width=MIN_WIDTH - 20;
			textField.addEventListener(TextEvent.LINK, onLink);


			titleField=new TextField();
			titleField.defaultTextFormat=new TextFormat(Style.fontFamily, Style.fontSize, Style.LABEL_COLOR, true);

			buttonContainer=new Sprite();

			addChild(titleField);
			addChild(textField);
			addChild(buttonContainer);
		}

		private function onLink(e:TextEvent):void
		{
			navigateToURL(new URLRequest(e.text));
		}

		public static function closeAlert():void
		{
			if (alert != null && alert.stage != null)
			{
				PopUpManager.removePopUp(alert);
				alertPool.push(alert);
			}
		}

		private var _flagsChanged:Boolean;
		private var _flags:uint;

		public function get flags():uint
		{
			return _flags;
		}

		public function set flags(value:uint):void
		{
			if (value == _flags)
				return;

			_flags=value;
			_flagsChanged=true;

			invalidateProperties();
		}
		private var _titleChanged:Boolean=false;
		private var _title:String;

		public function get title():String
		{
			return _title ? _title : "";
		}

		public function set title(value:String):void
		{
			if (value == _title)
				return;
			_title=value;
			_title=value;
			_titleChanged=true;
			invalidateProperties();
		}

		private var _textChanged:Boolean;
		private var _text:String;

		public function get text():String
		{
			return _text ? _text : "";
		}

		public function set text(value:String):void
		{
			if (value == _text)
				return;

			_text=value;
			_textChanged=true;

			invalidateProperties();
		}

		override protected function measure():void
		{
			var w:Number=Math.max(textField.textWidth + 4, MIN_WIDTH);

			measuredWidth=w;

			var h:Number=Math.max(textField.textHeight + buttonHeight + TITLE_HEIGHT, MIN_HEIGHT);

			measuredHeight=h;
		}

		override protected function commitProperties():void
		{
			super.commitProperties();

			if (_flagsChanged)
			{
				_flagsChanged=false;
				removeButtons();
				createButtons();
				invalidateDisplayList();
			}

			if (_textChanged)
			{
				_textChanged=false;
				textField.htmlText=StringUtil.substitute(format, Style.fontSize, "#" + Style.LABEL_COLOR.toString(16), text, Style.fontFamily);
				invalidateDisplayList();
			}

			if (_titleChanged)
			{
				_titleChanged=false;
				titleField.text=title;
			}
		}

		private function removeButtons():void
		{
			for each (var button:Button in buttons)
			{
				buttonContainer.removeChild(button);
				button.removeEventListener(MouseEvent.CLICK, clickHandler);
				buttonPool.push(button);
			}
			buttons=[];
		}

		private var buttonPool:Array=[];

		private function createButton(label:String, eventKey:uint):Button
		{
			var button:Button=buttonPool.length > 0 ? buttonPool.pop() : new Button();
			button.buttonMode=true;
			button.label=label;
			button.setActualSize(Alert.buttonWidth, Alert.buttonHeight);
			button.x=buttonContainer.numChildren * (btnGap + buttonWidth);
			button.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			if (button.objData == null)
				button.objData=new Object();
			button.objData.customName=ALERT_BUTTON_PREFIX + eventKey;

			return Button(buttonContainer.addChild(button));
		}

		private function createButtons():void
		{
			if (flags & Alert.OK)
				buttons[Alert.OK]=createButton(GlobalConfig.ALERT_OK_LABEL, Alert.OK);

			if (flags & Alert.CANCEL)
				buttons[Alert.CANCEL]=createButton(GlobalConfig.ALERT_CANCEL_LABEL, Alert.CANCEL);

			if (flags & Alert.YES)
				buttons[Alert.YES]=createButton(GlobalConfig.ALERT_YES_LABEL, Alert.YES);

			if (flags & Alert.NO)
				buttons[Alert.NO]=createButton(GlobalConfig.ALERT_NO_LABEL, Alert.NO);
		}

		private function refreshButtons():void
		{
			if (flags & Alert.OK)
				buttons[Alert.OK].label=GlobalConfig.ALERT_OK_LABEL;

			if (flags & Alert.CANCEL)
				buttons[Alert.CANCEL].label=GlobalConfig.ALERT_CANCEL_LABEL;

			if (flags & Alert.YES)
				buttons[Alert.YES].label=GlobalConfig.ALERT_YES_LABEL;

			if (flags & Alert.NO)
				buttons[Alert.NO].label=GlobalConfig.ALERT_NO_LABEL;
		}

		private function getDetailBy(button:Button):int
		{
			if (button == null)
			{
				return 0;
			}

			if ((button.objData.customName == null) || (button.objData.customName.indexOf(ALERT_BUTTON_PREFIX) == -1))
			{
				return 0;
			}

			return uint(button.objData.customName.replace(ALERT_BUTTON_PREFIX, ''));
		}

		private function clickHandler(event:MouseEvent):void
		{
			var button:Button=Button(event.currentTarget);
			PopUpManager.removePopUp(this);

			if (_closeHandler != null)
			{
				var closeEvent:CloseEvent=new CloseEvent(CloseEvent.CLOSE, false, false, getDetailBy(button));
				_closeHandler(closeEvent);
			}

			alertPool.push(this);
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			textField.height=textField.textHeight + 4;

			textField.x=(_width - textField.width) * .5
			textField.y=20 + TITLE_HEIGHT;


			titleField.height=TITLE_HEIGHT;
			titleField.x=25;
			titleField.y=5;
			titleField.width=_width - 10


			var btnW:Number=buttonContainer.numChildren * buttonWidth + (buttonContainer.numChildren - 1) * btnGap
			buttonContainer.x=(_width - btnW) * .5;
			buttonContainer.y=_height * .8 - buttonHeight;

			bg.width=_width;
			bg.height=_height;
		}
	}
}
