package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.layout.VerticalLayout;

	import flash.display.DisplayObjectContainer;

	public class VScrollBar extends ScrollBar
	{
		public function VScrollBar(direction:String=ScrollBar.VERTICAL, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(direction, parent, xpos, ypos);
			layout=new VerticalLayout();
		}
	}
}
