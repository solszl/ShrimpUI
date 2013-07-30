package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.framework.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 *	label组件,暂不支持HTML
	 * @author Sol
	 * 2013-07-26
	 *
	 */
	public class Label extends Component
	{
		protected var _text:String="";
		protected var _tf:TextField;
		protected var _format:TextFormat;
		private var _fontSize:int=Style.fontSize;
		private var _color:uint=Style.LABEL_COLOR;
		private var _bold:Boolean=false;
		private var _align:String=TextFormatAlign.LEFT;
		private var _indent:int;
		protected var _html:Boolean=false;

		private var _stroke:uint=0;

		public function Label(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="")
		{
			_text=text;
			super(parent, xpos, ypos);
			stroke=Style.stroke;
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_tf=new TextField();
			_tf.selectable=false;
			_tf.mouseEnabled=true;
			_tf.tabEnabled=false;
			_tf.text=_text;
			_tf.defaultTextFormat=new TextFormat(Style.fontFamily, _fontSize, _color, _bold, null, null, null, null, _align, null, null, _indent);
			_tf.height=_height;
			this.addChild(_tf);
		}

		/**
		 *	取到当前设置的textFormat
		 * @return
		 *
		 */
		public function get textFormat():TextFormat
		{
			return _format;
		}

		public function set textFormat(value:TextFormat):void
		{
			_format=value;
			_tf.defaultTextFormat=value;
			_tf.setTextFormat(value);
		}

		/**
		 *	描边
		 * @return
		 *
		 */
		public function get stroke():uint
		{
			return _stroke;
		}

		public function set stroke(value:uint):void
		{
			if (_stroke == value)
				return;
			_stroke=value;
			_tf.filters=Style.fontFilter;
		}

		protected var _textChanged:Boolean=false;
		protected var _textPropertyChanged:Boolean=false;

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

		public function get text():String
		{
			return _text;
		}

		public function get textField():TextField
		{
			return _tf;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			if (_color == value)
				return;

			_color=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		public function get bold():Boolean
		{
			return _bold;
		}

		public function set bold(value:Boolean):void
		{
			if (bold == value)
				return;

			_bold=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		public function get fontSize():int
		{
			return _fontSize;
		}

		public function set fontSize(value:int):void
		{
			if (_fontSize == value)
				return;

			_fontSize=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		[Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			if (value == _align)
				return;

			_align=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		/**第一个字符的缩进*/
		public function get indent():int
		{
			return _indent;
		}

		public function set indent(value:int):void
		{
			if (_indent == value)
				return;

			_indent=value;
			_textPropertyChanged=true;
			invalidateProperties();
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_textChanged)
			{
				_textChanged=false;
				_tf.text=_text;
				invalidateDisplayList();
			}

			if (_textPropertyChanged)
			{
				_textPropertyChanged=false;
				_tf.defaultTextFormat=new TextFormat(Style.fontFamily, _fontSize, _color, _bold, null, null, null, null, _align, null, null, _indent);
				_tf.text=_text;
			}
		}

		override protected function measure():void
		{
			measuredWidth=_tf.textWidth + 4 + _indent;
			measuredHeight=Math.max(_tf.textHeight + 4, 15);
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			_tf.width=_width;
			_tf.height=_height;
			if (_tf.type == TextFieldType.DYNAMIC && _tf.multiline == false)
			{
				var w:Number=_width;
				if (_tf.textWidth > w)
				{
					var orginalText:String=_text;
					var s:String=_tf.text;
					while (s.length > 1 && _tf.textWidth > w - 4)
					{
						s=s.slice(0, -1);
						_tf.text=s + "...";
					}
				}
			}
		}
	}
}
