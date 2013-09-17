package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;

	/**
	 *	圆形布局
	 * @author Sol
	 *
	 */
	public class CircleLayout extends AbstractLayout
	{
		protected var _radiusX:Number=20;
		/**
		 *	圆形布局，需要传入的参数有， 
		 * radiusX(Number)，圆形的半径
		 * centerPoint(Point),原型的中点
		 * startAngle(Number),可选参数，为从哪个角度开始布局。 默认是-90度，即12点位置开始，顺时针布局
		 * 
		 */		
		public function CircleLayout()
		{
			super();
			type="CircleLayout";
		}

		override public function layout(target:Component):void
		{
			var num:int=target.numChildren;
			this.disAngle=360 / num;
			for (var i:int=0; i < num; i++)
			{
				var tempRaian:Number=this.startAngle * Math.PI / 180;
				var node:DisplayObject=target.getChildAt(i) as DisplayObject;
				node.x=this.centerPoint.x - Math.sin(tempRaian) * this.radiusX - node.width*.5;
				node.y=this.centerPoint.y - Math.cos(tempRaian) * this.radiusX - node.height*.5;
				//角度增加
				this.startAngle+=this.disAngle;
			}
		}
		
		public function set radiusX(value:Number):void
		{
			if(value == radiusX)
				return;
			
			_radiusX = value;
		}
		
		public function get radiusX():Number
		{
			return _radiusX;
		}
	}
}
