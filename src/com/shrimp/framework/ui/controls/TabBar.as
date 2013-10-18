package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.event.MouseEvents;
	import com.shrimp.framework.ui.container.Container;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.framework.ui.layout.HorizontalLayout;
	import com.shrimp.framework.ui.layout.ILayout;
	import com.shrimp.framework.ui.layout.VerticalLayout;
	import com.shrimp.framework.utils.ArrayList;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.gestouch.events.GestureEvent;

	/**
	 *	列表栏
	 * @author Sol
	 *
	 */
	[Event(name="select", type="flash.events.Event")]
	public class TabBar extends Container
	{
		private var _layout:ILayout;
		protected var _direction:String;
		//方向发生变化
		private var directionChanged:Boolean=false;
		//数据发生变化
		private var dataChanged:Boolean=false;
		//索引发生变化
		private var selectedIndexChanged:Boolean=false;
		private var _data:ArrayList;
		protected var _selectedIndex:int=-1;
		protected var _normalSkin:Object;
		protected var _selectedSkin:Object;
		public function TabBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			mouseChildren=true;
//			addEventListener(MouseEvents.SINGLE_CLICK,onButtonClick,false,0,true);
			addEventListener(MouseEvent.CLICK,onButtonClick,false,0,true);
		}
		
//		protected function onButtonClick(event:GestureEvent):void
		protected function onButtonClick(event:Event):void
		{
			var item:DisplayObject = event.target as DisplayObject;
			var index:int=-1;
			if(item.parent==this)
			{
				index=getChildIndex(item);
			}
			if(selectedIndex==index)
				return;
			selectedIndex=index;
			if(hasEventListener(Event.SELECT))
			{
				dispatchEvent(new Event("select"));
			}
		}
		
		/**	页签方向*/
		[Inspectable(category="General", enumeration="horizontal,vertical", defaultValue="horizontal")]
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			if (value == direction)
				return;
			_direction=value;
			directionChanged=true;
			invalidateProperties();
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			if(dataChanged)
			{
				createButtons();
				layoutContainer();
				dataChanged=false;
				invalidateDisplayList();
			}

			if (directionChanged)
			{
				layoutContainer();
				directionChanged=false;
				invalidateDisplayList();
			}
			
			if(selectedIndexChanged)
			{
				selectedIndexChanged=false;
				invalidateDisplayList();
			}
		}
		
		private function createButtons():void
		{
			var btn:Button;
			for (var i:int = 0; i<data.length; i++) 
			{
				btn=new Button(this);
				btn.selectedSkinClass=selectedSkin;
				btn.skinClass = normalSkin;
				btn.validateNow();
				btn.toggle=true;
				btn.label=data.source[i];
			}
		}
		
		//根据布局字符串重新布局
		protected function layoutContainer():void
		{
			switch (direction)
			{
				case "horizontal":
					_layout=new HorizontalLayout();
					HorizontalLayout(_layout).gap=5
					break;
				case "vertical":
					_layout=new VerticalLayout();
					VerticalLayout(_layout).gap=5
					break;
				default:
					_layout=new HorizontalLayout();
					break;
			}
			layout=_layout;
		}

		/**	原始数据*/
		public function get data():ArrayList
		{
			return _data;
		}

		public function set data(value:ArrayList):void
		{
			if(value==_data)
				return;
			
			_data = value;
			dataChanged=true;
			invalidateProperties();
		}

		/**	选中的索引,from zero*/
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if(value == _selectedIndex)
				return;
			//取消前一个选中的item的选中状态
			if(_selectedIndex < numChildren &&　_selectedIndex　> -1)
			{
				var btn:Button=Button(getChildAt(_selectedIndex));
				btn.selected = false;
				btn.invalidateProperties();
			}
			_selectedIndex = value;
			selectedIndexChanged=true;
			invalidateProperties();
		}

		public function set normalSkin(value:Object):void
		{
			if(value==_normalSkin)
				return;
			
			_normalSkin = value;
		}

		public function get normalSkin():Object
		{
			if(_normalSkin==null)
				_normalSkin=Style.tabNormal;
			return _normalSkin;
		}
		public function set selectedSkin(value:Object):void
		{
			if(value ==_selectedSkin)
				return;
			_selectedSkin = value;
		}
		
		public function get selectedSkin():Object
		{
			if(_selectedSkin==null)
				_selectedSkin=Style.tabSelected;
			return _selectedSkin;
		}
		
		public function get allState():String
		{
			var len:int=numChildren;
			var result:String="";
			for (var i:int = 0; i < len; i++) 
			{
				result+="tab"+i+": "+Button(getChildAt(i)).selected+", ";
			}
			return result;
		}
	}
}
