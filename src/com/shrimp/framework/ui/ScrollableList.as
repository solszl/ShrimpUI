package com.shrimp.framework.ui
{
	import com.shrimp.framework.ui.container.Container;
	
	import flash.display.DisplayObjectContainer;
	
	public class ScrollableList extends Container
	{
		public function ScrollableList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
	}
}