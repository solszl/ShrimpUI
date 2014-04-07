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

		protected var _centerPoint:Point;

		protected var _startAngle:Number=0;

		/**每个元素之间的角度间隙*/
		protected var disAngle:Number;

		/**	目标组件*/
		protected var target:Component;
		
		/**	visible为false的组件是否参加排列*/
		protected var hideLayout:Boolean=false;
		
		protected var _measureHeight:Number=0;
		
		protected var _measureWidth:Number=0;
		
		protected var _gap:Number=5;
		
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
			throw new Error(" abstract class, implement in subclass");
		}

		public function toString():String
		{
			return type;
		}

		/**布局中心点位置*/
		public function get centerPoint():Point
		{
			return _centerPoint;
		}

		/**
		 * @private
		 */
		public function set centerPoint(value:Point):void
		{
			_centerPoint = value;
		}

		/**分布开始角度 默认0度开始分布*/
		public function get startAngle():Number
		{
			return _startAngle;
		}

		/**
		 * @private
		 */
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
		}

		public function get measureWidth():Number
		{
			return _measureWidth;
		}
		
		public function get measureHeight():Number
		{
			return _measureHeight;	
		}
	}
}
