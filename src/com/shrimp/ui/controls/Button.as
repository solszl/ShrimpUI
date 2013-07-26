package com.shrimp.ui.controls
{
	import com.shrimp.ui.controls.core.Component;
	
	import flash.display.DisplayObjectContainer;
	
	public class Button extends Component
	{
		public function Button(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0,label:String="",defaultHandler:Function=null)
		{
			super(parent, xpos, ypos);
		}
	}
}