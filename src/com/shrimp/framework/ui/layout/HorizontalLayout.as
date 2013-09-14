package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;

	public class HorizontalLayout extends AbstractLayout
	{
		public function HorizontalLayout()
		{
			type="HorizontalLayout";
		}
		protected var _gap:Number = 5;

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
			if(gap ==  value)
				return;
				
			_gap = value;
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

	}
}