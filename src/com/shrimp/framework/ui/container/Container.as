package com.shrimp.framework.ui.container
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.layout.AbstractLayout;
	import com.shrimp.framework.ui.layout.BaseLayout;
	import com.shrimp.framework.ui.layout.ILayout;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * 容器基类
	 * @author Sol
	 *
	 */
	[DefaultProperty("children")]
	public class Container extends Component
	{
		protected var _layout:*;
		private var _children:Vector.<DisplayObject>
		
		public function Container(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			mouseChildren=true;
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			child.addEventListener(Event.RESIZE, onResize, false, 0, true);
			invalidateDisplayList();

			return child;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			child.addEventListener(Event.RESIZE, onResize, false, 0, true);
			invalidateDisplayList();

			return child;
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			child.removeEventListener(Event.RESIZE, onResize);
			return child;
		}

		protected function onResize(event:Event):void
		{
			invalidateDisplayList();
		}

		public function get layout():*
		{
			return _layout;
		}

		public function set layout(value:ILayout):void
		{
			if (layout && layout.toString() == value.toString())
				return;
			
			_layout=value;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			if (_layout == null || _layout == undefined)
			{
				_layout=new BaseLayout();
			}
			_layout.layout(this);
			super.updateDisplayList();
		}

		public function set children(value:Vector.<DisplayObject>):void
		{
			if (value != _children)
			{
				while (numChildren > 0)
				{
					removeChildAt(0);
				}
				
				_children=value;
				
				var child:DisplayObject
				for each (child in _children)
				{
					addChild(child)
				}
				
				invalidateProperties();
				invalidateDisplayList();
			}
		}
		
		public function get children():Vector.<DisplayObject>
		{
			return _children;
		}
		
		public function removeAllChild():void
		{
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}
		
	}
}
