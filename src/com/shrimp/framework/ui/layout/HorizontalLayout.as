package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;

	import flash.display.DisplayObject;

	/**
	 *	水平布局，还未实现对齐功能
	 * @author Sol
	 *
	 */
	public class HorizontalLayout extends AbstractLayout
	{
		public function HorizontalLayout()
		{
			super();
			type="HorizontalLayout";
		}
		protected var _gap:Number=5;

		protected var _horizontalAlign:String="left";
		protected var _verticalAlign:String="top";

		/**	水平间距*/
		public function get gap():Number
		{
			return _gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if (gap == value)
				return;

			_gap=value;
			layout(target)
		}

		override public function layout(target:Component):void
		{
			if (!target)
				return;
			this.target=target;

			layoutChildren();
		}

		protected function layoutChildren():void
		{
			_measureHeight=_measureWidth=0;

			var xpos:Number=0;

			var numChildren:uint=target.numChildren;
			var child:DisplayObject;
			var i:int=0;
			for (i=0; i < numChildren; i++)
			{
				child=target.getChildAt(i);
				child.x=xpos;
				xpos+=child.width;
				xpos+=_gap;
				_measureWidth+=child.width;
				if (_measureHeight < child.height)
				{
					_measureHeight=child.height;
				}
			}
			_measureWidth+=_gap * (numChildren - 1);
		}

		[Inspectable(category="General", enumeration="left,right,center", defaultValue="left")]
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if (value == _horizontalAlign)
				return;

			_horizontalAlign=value;

			if (target)
				(target as Component).invalidateDisplayList();
		}

		[Inspectable(category="General", enumeration="top,middle,bottom", defaultValue="top")]
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			if (value == _verticalAlign)
				return;

			_verticalAlign=value;

			if (target)
				(target as Component).invalidateDisplayList();
		}

	}
}
