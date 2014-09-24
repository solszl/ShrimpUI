package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.framework.utils.ColorUtil;
	import com.shrimp.framework.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Label extends Component
	{
		public function Label(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="")
		{
			this.text=text;
			super(parent, xpos, ypos);
			stroke=Style.stroke;
		}

		protected var _textField:TextField;
		protected var _format:TextFormat;
		protected var _text:String="";
		protected var _html:Boolean;
		protected var _stroke:String;
		protected var _margin:Array=[0, 0, 0, 0];

		protected var _textChanged:Boolean=false;
		protected var _textPropertyChanged:Boolean=false;

		override protected function createChildren():void
		{

			_textField=new TextField();
			_textField.defaultTextFormat=new TextFormat(Style.fontFamily, Style.fontSize, Style.LABEL_COLOR);

			_format=_textField.defaultTextFormat;
			_format.font=Style.fontFamily;
			_format.size=Style.fontSize;
			_format.color=Style.LABEL_COLOR;
			_textField.selectable=false;
			_textField.text=text;
			addChild(_textField);
		}

		/**显示的文本*/
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if (value == _text)
				return;
			_text=value;

			if (StringUtil.isNullOrEmpty(value))
				_text="";

			_textChanged=true;

			if (hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			invalidateProperties();
		}


		/**描边(格式:color,alpha,blurX,blurY,strength,quality)*/
		public function get stroke():String
		{
			return _stroke;
		}

		public function set stroke(value:String):void
		{
			if (_stroke != value)
			{
				_stroke=value;
				ColorUtil.removeAllFilter(_textField);
				if (Boolean(_stroke))
				{
					var a:Array=StringUtil.split(value);
//					ColorUtil.addFilter(_textField,new GlowFilter(uint(a[0]), a[1], a[2], a[3], a[4], a[5]));
					_textField.filters=[new GlowFilter(uint(a[0]), a[1], a[2], a[3], a[4], a[5])];
				}
			}
		}

		/**是否是多行*/
		public function get multiline():Boolean
		{
			return _textField.multiline;
		}

		public function set multiline(value:Boolean):void
		{
			_textField.multiline=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**宽高是否自适应*/
		public function get autoSize():String
		{
			return _textField.autoSize;
		}

		public function set autoSize(value:String):void
		{
			_textField.autoSize=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**是否自动换行*/
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap=value;
		}

		/**是否可选*/
		public function get selectable():Boolean
		{
			return _textField.selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_textField.selectable=value;
			mouseEnabled=value;
		}

		/**是否具有背景填充*/
		public function get background():Boolean
		{
			return _textField.background;
		}

		public function set background(value:Boolean):void
		{
			_textField.background=value;
		}

		/**文本字段背景的颜色*/
		public function get backgroundColor():uint
		{
			return _textField.backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			_textField.backgroundColor=value;
		}

		/**字体颜色*/
		public function get color():Object
		{
			return _format.color;
		}

		public function set color(value:Object):void
		{
			_format.color=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**字体类型*/
		public function get font():String
		{
			return _format.font;
		}

		[Inspectable(category="General", enumeration="SimSun,Microsoft YaHei", defaultValue="SimSun")]
		public function set font(value:String):void
		{
			if (flash.system.Capabilities.manufacturer == "Google Pepper" && _format.font == "Microsoft YaHei")
			{
				_format.font="微软雅黑";
			}
			else
			{
				_format.font=value;
			}
			_textPropertyChanged=true;
			invalidateProperties();
		}

		[Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
		public function get align():String
		{
			return _format.align;
		}

		public function set align(value:String):void
		{
			_format.align=value;
//			_textField.autoSize = value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**粗体类型*/
		public function get bold():Object
		{
			return _format.bold;
		}

		public function set bold(value:Object):void
		{
			_format.bold=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**垂直间距*/
		public function get leading():Object
		{
			return _format.leading;
		}

		public function set leading(value:Object):void
		{
			_format.leading=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**第一个字符的缩进*/
		public function get indent():Object
		{
			return _format.indent;
		}

		public function set indent(value:Object):void
		{
			_format.indent=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**字体大小*/
		public function get fontSize():Object
		{
			return _format.size;
		}

		public function set fontSize(value:Object):void
		{
			_format.size=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**下划线类型*/
		public function get underline():Object
		{
			return _format.underline;
		}

		public function set underline(value:Object):void
		{
			_format.underline=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**字间距*/
		public function get letterSpacing():Object
		{
			return _format.letterSpacing;
		}

		public function set letterSpacing(value:Object):void
		{
			_format.letterSpacing=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		public function get margin():String
		{
			return _margin.join(",");
		}

		public function set margin(value:String):void
		{
			_margin=StringUtil.split(value);
			_textField.x=_margin[0];
			_textField.y=_margin[1];
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**格式*/
		public function get format():TextFormat
		{
			return _format;
		}

		public function set format(value:TextFormat):void
		{
			_format=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**文本控件实体*/
		public function get textField():TextField
		{
			return _textField;
		}

		/**将指定的字符串追加到文本的末尾*/
		public function appendText(newText:String):void
		{
			text+=newText;
		}

		public function set html(b:Boolean):void
		{
			_html=b;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		public function get html():Boolean
		{
			return _html;
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_textPropertyChanged)
			{
				_textPropertyChanged=false;
				_textField.defaultTextFormat=_format;
			}

			if (_textChanged)
			{
				_textChanged=false;
				html ? _textField.htmlText=_text : _textField.text=_text;
				invalidateSize();
				invalidateDisplayList();
			}
		}

		override protected function measure():void
		{
			trace("measure from label");
			measuredWidth=_textField.textWidth + 4 + _format.indent;
			measuredHeight=Math.max(_textField.textHeight + 4, 15);
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			_textField.width=width;
			_textField.height=height;
			if (_textField.type == TextFieldType.DYNAMIC && _textField.multiline == false)
			{
				var w:Number=_width;
				if (_textField.textWidth > w)
				{
					var orginalText:String=_text;
					var s:String=_textField.text;
					while (s.length > 1 && _textField.textWidth > w - 4)
					{
						s=s.slice(0, -1);
						_textField.text=s + "...";
					}
				}
			}
		}

	}
}


