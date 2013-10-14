package com.shrimp.framework.ui.controls.box
{
	import com.shrimp.framework.ui.container.Container;
	import com.shrimp.framework.ui.controls.RadioButton;
	import com.shrimp.framework.ui.layout.HorizontalLayout;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 *	单选框组 
	 * @author Sol
	 * 
	 */	
	public class RadioButtonGroup extends Container
	{
		private var _groupName:String;

		public function RadioButtonGroup(groupName:String="", parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			this._groupName=groupName;
			super(parent, xpos, ypos);
			_source=[];
		}
		private var _source:Array;
		//利用延迟渲染
		private var _dataProviderChanged:Boolean=false;
		private var _labelFieldChanged:Boolean=false;
		private var _selectedIndex:int;
		private var _selectedItem:RadioButton;
		/**	设置数据源
		 *默认查找是否存在设定的属性名称，如果有，设置，如果没有，则
		 *查找数据源中是否存在 label 属性，如果有，则显示label属性值，否则
		 *xxxx*/
		public function set dataProvider(value:Array):void
		{
			if(_source == value)
				return;
			
			this._source = value;
			_dataProviderChanged=true;
			
			validateNow();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(_dataProviderChanged)
			{
				if(_source)
				{
					var len:int = _source.length;
					var rb:RadioButton
					for (var i:int = 0; i < len; i++) 
					{
						rb = createRadioButton(_source[i]);
						addChild(rb);
					}
					
				}
				_dataProviderChanged=false;
			}
			
			if(_labelFieldChanged)
			{
				_labelFieldChanged=false;
			}
			
		}
		
		private var _labelField:String="";
		/**	设置显示文本字段*/
		public function set labelField(value:String):void
		{
			if(_labelField==value)
				return;
			
			_labelField = value;
			_labelFieldChanged=true;	
			invalidateProperties();
		}
		
		public function get labelField():String
		{
			return this._labelField;
		}
		
		override protected function updateDisplayList():void
		{
			//默认abstractLayout没有定义位置
			if(layout ==null)
			{
				layout = new HorizontalLayout();
			}
			layout.layout(this);
		}
		
		private function createRadioButton(data:Object):RadioButton
		{
			var rb:RadioButton=new RadioButton();
			rb.addEventListener("selected",onSelected);
			if(""!=_labelField)
			{
				if(data.hasOwnProperty(_labelField))
				{
					rb.label=data[labelField];
				}
			}
			else if(data.hasOwnProperty("label"))
			{
				rb.label=data["label"];
			}
			else if(data is String)
			{
				rb.label=data as String;
			}
			else
			{
				rb.label=data.toString();
			}
			rb.validateNow();
			return rb;
		}
		
		protected function onSelected(event:Event):void
		{
			var target:RadioButton = event.target as RadioButton;
			
			if(target != null)
				clear(target);
		}
		
		/**	选中索引*/
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if(_source.length<value || value<0)
				return;
			
			_selectedIndex = value;
			selectedItem = getChildAt(value) as RadioButton;
		}

		/**	选中项*/
		public function get selectedItem():RadioButton
		{
			return _selectedItem;
		}

		/**
		 * @private
		 */
		public function set selectedItem(value:RadioButton):void
		{
			_selectedItem = value;
			clear(value);
		}
		
		/** 获得数据列表总长度*/
		public function get totalCount():int
		{
			if(!_source)
				return 0;
			return _source.length;
		}
		/**	清空操作*/
		private function clear(rb:RadioButton):void
		{
			var len:int=this.numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				var child:RadioButton = (getChildAt(i) as RadioButton);
				if(rb != child && child.selected)
					child.selected=false;
			}
			_selectedIndex = getChildIndex(rb);
			rb.selected = true;
		}
	}
}
