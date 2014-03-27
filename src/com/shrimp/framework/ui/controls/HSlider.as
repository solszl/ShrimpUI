package com.shrimp.framework.ui.controls
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 *	横向滚动条 
	 * @author Sol
	 * 
	 */	
	public class HSlider extends Slider
	{
		public function HSlider(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			super(Slider.HORIZONTAL, parent, xpos, ypos, defaultHandler);
		}
		
	}
}