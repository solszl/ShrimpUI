package com.shrimp.framework.ui.container
{
	import com.shrimp.framework.ui.layout.HorizontalLayout;

	import flash.display.DisplayObjectContainer;

	public class HBox extends Container
	{
		private var __layout:HorizontalLayout;

		public function HBox(gap:int=5, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			__layout=new HorizontalLayout();
			__layout.gap=gap;
			layout=__layout;
		}

		public function set gap(value:Number):void
		{
			HorizontalLayout(__layout).gap=value;
		}

		public function get gap():Number
		{
			return HorizontalLayout(__layout).gap;
		}

		[Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
		public function get horizontalAlign():String
		{
			return HorizontalLayout(__layout).horizontalAlign;
		}

		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			HorizontalLayout(__layout).horizontalAlign=value;
		}

		[Inspectable(category="General", enumeration="top,middle,bottom", defaultValue="top")]
		public function get verticalAlign():String
		{
			return HorizontalLayout(__layout).verticalAlign;
			;
		}

		public function set verticalAlign(value:String):void
		{
			HorizontalLayout(__layout).verticalAlign=value;
		}
	}
}
