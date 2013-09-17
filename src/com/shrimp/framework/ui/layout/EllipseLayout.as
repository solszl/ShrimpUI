package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;

	import flash.display.DisplayObject;

	/**
	 *	椭圆布局
	 * @author Sol
	 *
	 */
	public class EllipseLayout extends CircleLayout
	{
		public function EllipseLayout()
		{
			super();
			type="EllipseLayout";
		}

		private var _radiusY:Number;

		override public function layout(target:Component):void
		{
			var num:int=target.numChildren;
			this.disAngle=360 / num;
			for (var i:int=0; i < num; i++)
			{
				var tempRaian:Number=this.startAngle * Math.PI / 180;
				var node:DisplayObject=target.getChildAt(i) as DisplayObject;
				node.x=this.centerPoint.x - Math.sin(tempRaian) * this.radiusX - node.width * .5;
				node.y=this.centerPoint.y - Math.cos(tempRaian) * this.radiusY - node.height * .5;
				//角度增加
				this.startAngle+=this.disAngle;
			}
		}

		public function get radiusY():Number
		{
			return _radiusY;
		}

		public function set radiusY(value:Number):void
		{
			if (value == radiusY)
				return;

			_radiusY=value;
		}

	}
}
