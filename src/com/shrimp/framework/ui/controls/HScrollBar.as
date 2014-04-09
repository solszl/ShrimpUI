package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.layout.HorizontalLayout;
	
	import flash.display.DisplayObjectContainer;

	public class HScrollBar extends ScrollBar
	{
		public function HScrollBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(ScrollBar.HORIZONTAL, parent, xpos, ypos);
		}
	}
}
