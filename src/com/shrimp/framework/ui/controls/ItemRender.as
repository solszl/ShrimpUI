package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.interfaces.IItemRenderer;
	import com.shrimp.framework.ui.container.Box;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class ItemRender extends Box implements IItemRenderer
	{
		public function ItemRender(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		private var _data:*;
		
//		[Bindable(event="dataChange")]
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:*):void
		{
			if (_data == value)
				return;
			
			_data=value;
			invalidateProperties();
			invalidateSize();
			dispatchEvent(new Event("dataChange"));
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private var _selected:Boolean=false;
		
		public function set selected(value:Boolean):void
		{
			_selected=value;
		}
		
		private var _index:int=0;
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index=value;
		}
		
		public function dispose():void
		{
		}
	}
}