package com.shrimp.ui
{
	import com.shrimp.interfaces.ITooltip;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 *	组件基类 
	 * @author Sol
	 * 
	 */	
	public class Component extends Sprite implements ITooltip
	{
		private var _tooltip:Object;
		public function Component(parent:DisplayObjectContainer,xpos:Number,ypos:Number)
		{
			super();
		}
		
		public function move(xpos:Number,ypos:Number):void
		{
			x=Math.round(xpos);
			y=Math.round(ypos);
		}
		
		public function set toolTip(value:Object):void
		{
			//TODO: reg tooltip
		}
		
		public function get toolTip():Object
		{
			return this._tooltip;
		}
	}
}