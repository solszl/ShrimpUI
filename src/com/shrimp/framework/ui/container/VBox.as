package com.shrimp.framework.ui.container
{
	import com.shrimp.framework.ui.layout.VerticalLayout;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class VBox extends Container
	{
		private var ___layout:VerticalLayout;

		public function VBox(gap:int=5, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			___layout=new VerticalLayout();
			___layout.gap=gap;
			layout=___layout;
		}

		public function set gap(value:Number):void
		{
			VerticalLayout(___layout).gap=value;
		}

		public function get gap():Number
		{
			return VerticalLayout(___layout).gap;
		}

		[Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
		public function get horizontalAlign():String
		{
			return VerticalLayout(___layout).horizontalAlign;
		}

		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			VerticalLayout(___layout).horizontalAlign=value;
		}

		[Inspectable(category="General", enumeration="top,middle,bottom", defaultValue="top")]
		public function get verticalAlign():String
		{
			return VerticalLayout(___layout).verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			VerticalLayout(___layout).verticalAlign=value;
		}

		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index);

			this.invalidateDisplayList();
		}
	}
}
