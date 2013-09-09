package com.shrimp.framework.ui.container
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 容器积累
	 * @author Sol
	 * 
	 */	
	public class Container extends Component
	{
		public function Container(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
	}
}