package com.shrimp.framework.ui.controls
{
	import com.greensock.TweenMax;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	public class Button extends Component
	{
		protected static var stateMap:Object={"rollOver": 1, "rollOut": 0, "mouseDown": 2, "mouseUp": 1, "selected": 2};
		private var bg:Image;

		public function Button(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="")
		{
			super(parent, xpos, ypos);
//			setActualSize(100,30);
			mouseChildren=false;
			this.label=label;

		}

		override protected function init():void
		{
			super.init();
			buttonMode=true;
			useHandCursor=true;
			addEventListener(MouseEvent.ROLL_OVER, onMouse);
			addEventListener(MouseEvent.ROLL_OUT, onMouse);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(MouseEvent.CLICK, onMouse);
		}

		protected function onMouse(e:MouseEvent):void
		{
			if ((!_toggle && _selected))
			{
				return;
			}
			if (e.type == MouseEvent.CLICK)
			{
				if (_toggle)
				{
					selected=!_selected;
				}
				return;
			}
			if (_selected == false && !toggle)
			{
				state=stateMap[e.type];
			}
			_skinDirty=true;
			invalidateProperties();
		}

		override protected function createChildren():void
		{
			bg=new Image(this);
//			bg.scale9Rect=new Rectangle(4,4,30,16);
			_label=new Label(this);
			_label.mouseEnabled=false;
			_label.mouseChildren=false;
			_labelColor=_label.color;
		}

		protected var _label:Label;
		protected var _labelText:String="";
		private var _labelChanged:Boolean=false;
		private var _over:Boolean=false;

		public function get label():String
		{
			return _labelText;
		}

		public function set label(value:String):void
		{
			if (_labelText == value)
				return;

			_labelChanged=true;
			_labelText=value;

			invalidateProperties();
		}

		private var _labelColor:Object=0;

		public function set labelColor(value:Object):void
		{
			_label.color=value;
		}

		public function get labelColor():Object
		{
			return _labelColor;
		}

		public function get labelSize():uint
		{
			return int(_label.fontSize);
		}

		public function set labelSize(value:uint):void
		{
			_label.fontSize=value;
		}

		public function get bold():Boolean
		{
			return _label.bold;
		}

		public function set bold(value:Boolean):void
		{
			_label.bold=value;
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_labelChanged)
			{
				_labelChanged=false;
				_label.text=_labelText;
				_label.validateNow();
				invalidateDisplayList();
			}

			if (_skinDirty)
			{
				if (lastState == state)
					return;
				bg.source=_skinClass;
				//根据状态 更新按钮皮肤 0：normal  1：over 2:down
				switch (state)
				{
					case 0:
						TweenMax.to(bg, 0, {colorMatrixFilter: {remove: true}});
						break;
					case 1:
						_overSkin ?bg.source=_overSkin:TweenMax.to(bg, 0, {colorMatrixFilter: {brightness: 1.1, saturation: 1.2}})
						break;
					case 2:
						_selectedSkin?bg.source=_selectedSkin:TweenMax.to(bg, 0, {colorMatrixFilter: {brightness: .66, saturation: .8}});
						break;
				}

//				invalidateDisplayList();
				updateDisplayList();
				lastState=state;
				_skinDirty=false;
			}
		}

		private var lastState:int=-1;

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			if (bg.width != _width)
				bg.width=_width;
			if (bg.height != _height)
				bg.height=_height;
			doLabelAlign();
		}

		[Inspectable(category="General", enumeration="top-left,top-center,top-right,middle-left,middle-center,middle-right,bottom-left,bottom-center,bottom-right", defaultValue="middle-center")]
		public function get labelAlign():String
		{
			return _labelAlign;
		}

		public function set labelAlign(value:String):void
		{
			if (value == _labelAlign)
				return;

			_labelAlign=value;

			invalidateDisplayList();
		}

		private function doLabelAlign():void
		{
			var arr:Array=_labelAlign.split("-");

			if (arr[1] == "left")
			{
				_label.x=0;
			}
			else if (arr[1] == "center")
			{
				_label.x=_width / 2 - _label.width / 2
			}
			else
			{
				_label.x=_width - _label.width;
			}

			if (arr[0] == "top")
			{
				_label.y=0;
			}
			else if (arr[0] == "middle")
			{
				_label.y=_height / 2 - _label.height / 2;
			}
			else
			{
				_label.y=_height - _label.height;
			}
		}

		private var _labelAlign:String="middle-center";

		private var _skinClass:Object=Style.defaultBtnNormalSkin;
		private var _overSkin:Object;
		private var _selectedSkin:Object;

		private var _skinDirty:Boolean=true;

		public function set skinClass(value:Object):void
		{
			if (value == null)
			{
				value=Style.defaultBtnNormalSkin;
			}

			if (value == _skinClass)
				return;

			_skinClass=value;

			bg.source=value;
			invalidateDisplayList();
		}

		public function get skinClass():Object
		{
			return _skinClass;
		}

		public function set overSkinClass(value:Object):void
		{
			if (value == null)
			{
				value=Style.defaultBtnNormalSkin;
			}

			if (value == _skinClass)
				return;

			_overSkin=value;

			bg.source=value;
			invalidateDisplayList();
		}

		public function set selectedSkinClass(value:Object):void
		{
			if (value == null)
			{
				value=Style.defaultBtnSelectedSkin;
			}

			if (value == _skinClass)
				return;

			_selectedSkin=value;

			bg.source=value;
			invalidateDisplayList();
		}

		override protected function measure():void
		{
			super.measure();
			_label.validateDisplayList();
			var skinW:Number=bg ? bg.width : 0;
			var skinH:Number=bg ? bg.height : 0;
			measuredWidth=Math.max(_label.width + 10, skinW);
			measuredHeight=Math.max(_label.height, skinH);
		}


		private var _state:int;

		private function set state(value:int):void
		{
			if (_state == value)
				return;

			_state=value;
		}

		private function get state():int
		{
			return _state;
		}

		private var _selected:Boolean=false;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;

			_selected=value;
			state=_selected ? stateMap["selected"] : stateMap["rollOut"];
			_skinDirty=true;
//			invalidateDisplayList();
			updateDisplayList();
		}

		private var _toggle:Boolean;

		public function get toggle():Boolean
		{
			return _toggle;
		}

		public function set toggle(value:Boolean):void
		{
			_toggle=value;
		}
	}
}
