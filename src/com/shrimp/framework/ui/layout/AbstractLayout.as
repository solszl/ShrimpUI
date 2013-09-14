package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 *	布局抽象类
	 * @author Sol
	 *
	 */
	public class AbstractLayout implements ILayout
	{
		protected var type:String;

		/**布局中心点位置*/
		protected var centerPoint:Point;

		/**分布开始角度 默认0度开始分布*/
		protected var startAngle:Number=0;

		/**每个元素之间的角度间隙*/
		protected var disAngle:Number;

		/**	目标组件*/
		protected var target:Component;
		
		protected var _measureHeight:Number=0;
		
		protected var _measureWidth:Number=0;
		
		public function AbstractLayout()
		{

		}

		/**
		 *	布局实现，所有子类布局都重载改方法
		 * 默认布局
		 * @param target
		 *
		 */
		public function layout(target:Component):void
		{
			if(!target)
				return;
			
			this.target = target;
			
			var i:int=0;
			var child:DisplayObject;
			var numChildren:uint=target.numChildren;
			for(i=0;i<numChildren;i++)
			{
				child = target.getChildAt(i);
				var cw:Number=child.width + child.x
				if (cw > _measureWidth)
				{
					_measureWidth=cw;
				}
				
				var ch:Number=child.height + child.y;
				if (ch > _measureHeight)
				{
					_measureHeight=ch;
				}
			}
			
			var acW:Number=isNaN(target.explicitWidth) ? _measureWidth : target.explicitWidth;
			var acH:Number=isNaN(target.explicitHeight) ? _measureHeight : target.explicitHeight;
			for (i=0; i < numChildren; i++)
			{
				child=target.getChildAt(i);
				if (child is Component)
				{
					if (!isNaN(Component(child).horizontalCenter))
					{
						Component(child).x=((acW - child.width) >> 1) + Component(child).horizontalCenter;
					}
					
					if (!isNaN(Component(child).verticalCenter))
					{
						Component(child).y=((acH - child.height) >> 1) + Component(child).verticalCenter;
					}
				}
			}
		}

		public function toString():String
		{
			return type;
		}
	}
}
