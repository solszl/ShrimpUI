package com.shrimp.framework.ui.controls
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 *	纵向滚动条 
	 * @author Sol
	 * 
	 */	
	public class VSlider extends Slider
	{
		public function VSlider(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			super(Slider.VERTICAL, parent, xpos, ypos, defaultHandler);
		}
	}
}