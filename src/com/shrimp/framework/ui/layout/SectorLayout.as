package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;

	import flash.display.DisplayObject;

	/**
	 *	扇形布局
	 * @author Sol
	 *
	 */
	public class SectorLayout extends EllipseLayout
	{
		public function SectorLayout()
		{
			super();
			type="SectorLayout";
		}
		protected var _angelRange:Number;

		override public function layout(target:Component):void
		{
			var len:Number=target.numChildren;
			this.disAngle=this.angelRange / len;
			for (var i:int=0; i < len; i++)
			{
				var tempRaian:Number=this.startAngle * Math.PI / 180;
				var node:DisplayObject=target.getChildAt(i) as DisplayObject;
				node.x=this.centerPoint.x + Math.cos(tempRaian) * this.radiusX;
				node.y=this.centerPoint.y + Math.sin(tempRaian) * this.radiusY;
				//角度增加
				this.startAngle+=this.disAngle;
			}
		}
		/**分布范围 如果90那么就是指从startAngle 开始到angelRange 这样以一个范围*/
		public function get angelRange():Number
		{
			return _angelRange;
		}

		public function set angelRange(value:Number):void
		{
			_angelRange=value;
		}

	}
}
