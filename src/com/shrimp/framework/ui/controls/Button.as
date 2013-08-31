package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	
	import flash.display.DisplayObjectContainer;

	public class Button extends Component
	{
		protected static var stateMap:Object = {"rollOver": 1, "rollOut": 0, "mouseDown": 2, "mouseUp": 1, "selected": 2};
		private var bg:Image;
		public function Button(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="")
		{
			super(parent, xpos, ypos);
//			setActualSize(100,30);
			mouseChildren=false;
			this.label=label;
			
		}
		
		override protected function createChildren():void
		{
			bg=new Image(this);
			_label=new Label(this);
			_label.mouseEnabled=false;
			_label.mouseChildren=false;
			_labelColor = _label.color;
			buttonMode=true;
			useHandCursor=true;
		}
		
		protected var _label:Label;
		protected var _labelText:String="";
		private var _labelChanged:Boolean=false;
		
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
		
		private var _labelColor:uint = 0;
		public function set labelColor(value:uint):void
		{
			_label.color=value;
		}
		
		public function get labelColor():uint
		{
			return _labelColor;
		}
		
		public function get labelSize():uint
		{
			return _label.fontSize;
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
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			if(bg.width!=_width)
				bg.width=_width;
			if(bg.height!=_height)
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
		
		private var _skinClass:Object;
		private var _overSkin:Object;
		private var _selectedSkin:Object;
		public function set skinClass(value:Object):void
		{
			if (value == null)
			{
				value=Style.defaultBtnNormalSkin;
			}
			
			if(value == _skinClass)
				return;
			
			_skinClass=value;
			
			bg.source = value;
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
			
			if(value == _skinClass)
				return;
			
			_overSkin=value;
			
			bg.source = value;
			invalidateDisplayList();
		}
		
		public function set selectedSkinClass(value:Object):void
		{
			if (value == null)
			{
				value=Style.defaultBtnSelectedSkin;
			}
			
			if(value == _skinClass)
				return;
			
			_selectedSkin=value;
			
			bg.source = value;
			invalidateDisplayList();
		}
		
		override protected function measure():void
		{
			super.measure();
			var skinW:Number=bg ? bg.width : 0;
			var skinH:Number=bg ? bg.height : 0;
			trace(skinW);
			measuredWidth=Math.max(_label.width + 10, skinW);
			measuredHeight=Math.max(_label.height, skinH);
		}
	}
}
