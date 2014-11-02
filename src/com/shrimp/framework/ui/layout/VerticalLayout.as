package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;

	/**
	 *	纵向布局类 
	 * @author Sol
	 * 
	 */	
	public class VerticalLayout extends HorizontalLayout
	{
		public function VerticalLayout()
		{
			super();
			type="VerticalLayout";
		}
		
		override protected function layoutChildren():void
		{
			_measureHeight=_measureWidth=0;
			
			var ypos:Number=0;
			
			var child:DisplayObject;
			var i:int=0;
			var numChildren:uint=target.numChildren;
			for (i=0; i < numChildren; i++)
			{
				child=target.getChildAt(i);
				child.y=ypos;
				ypos+=child.height;
				ypos+=_gap;
				_measureHeight+=child.height;
				if (_measureWidth < child.width)
				{
					_measureWidth=child.width;
				}
			}
			_measureHeight+=_gap * (numChildren - 1);
			
			if(target.width!=measureWidth)
			{
				target.width = measureWidth;
				needUpdateDisplaylist=true;
			}
			
			if(target.height!=measureHeight)
			{
				target.height = measureHeight;
				needUpdateDisplaylist=true;
			}
			
			if(needUpdateDisplaylist)
			{
				needUpdateDisplaylist=false;
				target.invalidateDisplayList();
			}
		}
		
		override protected function validataAlignH():void
		{
			var acW:Number=isNaN(target.explicitWidth) ? _measureWidth : target.explicitWidth;
			var child:DisplayObject;
			var i:int=0;
			for (i=0; i < target.numChildren; i++)
			{
				child=target.getChildAt(i);
				switch (_horizontalAlign)
				{
					case "left":
						child.x=0;
						break;
					case "right":
						child.x=acW - child.width;
						break;
					case "center":
						child.x=(acW - child.width) >> 1;
						break;
				}
			}
		}
		
		override protected function validataAlignV():void
		{
			if (_verticalAlign == "top" || isNaN(target.explicitHeight))
				return;
			
			var deltaY:Number=target.explicitHeight - _measureHeight;
			var child:DisplayObject;
			var i:int=0;
			for (i=0; i < target.numChildren; i++)
			{
				child=target.getChildAt(i);
				switch (_verticalAlign)
				{
					case "middle":
						child.y+=deltaY >> 1;
						break;
					case "bottom":
						child.y=deltaY;
						break;
				}
			}
		}
	}
}