package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.container.Box;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class ViewStack extends Box
	{
		public function ViewStack(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		private var _selectedIndex:int=-1;
		private var selectedIndexChanged:Boolean=false;

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			value=Math.max(0, value);
			if (_selectedIndex == value)
				return;
			_selectedIndex=value;
			selectedIndexChanged=true;
			validateNow();
		}
		//当前选中的视窗
		private var currentChild:DisplayObject;

		override protected function commitProperties():void
		{
			super.commitProperties();
			if (selectedIndexChanged)
			{
				selectedIndexChanged=false;
				if (selectedIndex >= this.numChildren)
					return;

				var child:DisplayObject=getChildAt(selectedIndex);
				if (currentChild && currentChild != child)
				{
					currentChild.visible=false;
				}
				child.visible=true;
				currentChild=child;
			}
		}

		override protected function measure():void
		{
			super.measure();
			if(selectedIndex<0||numChildren==0)
				return;
			var child:DisplayObject=getChildAt(selectedIndex);
			measuredWidth=child.width;
			measuredHeight=child.height;
		}
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			child.visible=false;
			selectedIndexChanged=true;
			invalidateProperties();
			return child;
		}

		public function get selectedChild():DisplayObject
		{
			return getChildAt(_selectedIndex);
		}

		public function set selectedChild(value:DisplayObject):void
		{
			selectedIndex=getChildIndex(value);
		}

	}
}
