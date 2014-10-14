package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;

	/**
	 *	水平布局
	 * @author Sol
	 *
	 */
	public class HorizontalLayout extends BaseLayout
	{
		public function HorizontalLayout()
		{
			super();
			type="HorizontalLayout";
		}

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
			validataAlignH();
			validataAlignV();
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
				trace("child, i:",i,child,child.width);
				xpos+=_gap;
				_measureWidth+=child.width;
				if (_measureHeight < child.height)
				{
					_measureHeight=child.height;
				}
			}
			_measureWidth+=_gap * (numChildren - 1);
//			target.setActualSize(_measureWidth,_measureHeight);
			target.width = _measureWidth;
			target.height = _measureHeight;
			
			trace("target::",target,target.width);
		}

		protected function validataAlignH():void
		{
			if (isNaN(target.explicitWidth) || _horizontalAlign == "left")
				return;
			
			var deltaX:Number=target.explicitWidth - _measureWidth;
			var child:DisplayObject;
			var i:int=0;
			for (i=0; i < target.numChildren; i++)
			{
				child=target.getChildAt(i);
				switch (_horizontalAlign)
				{
					case "center":
						child.x+=deltaX >> 1;
						break;
					case "right":
						child.x+=deltaX;
						break;
				}
			}
		}
		
		protected function validataAlignV():void
		{
			if (isNaN(target.explicitHeight) || _horizontalAlign == "top")
				return;
			
			var acH:Number=isNaN(target.explicitHeight) ? _measureHeight : target.explicitHeight;
			var child:DisplayObject;
			var i:int=0;
			for (i=0; i < target.numChildren; i++)
			{
				child=target.getChildAt(i);
				switch (_verticalAlign)
				{
					case "bottom":
						child.y=acH - child.height;
						break;
					case "middle":
						child.y=(acH - child.height) >> 1;
						break;
				}
			}
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
