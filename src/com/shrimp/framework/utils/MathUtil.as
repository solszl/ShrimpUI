package com.shrimp.framework.utils
{
	import flash.errors.IllegalOperationError;

	/**
	 *	数学工具类
	 * @author Sol
	 *
	 */
	public class MathUtil
	{
		/**
		 *	角度转换弧度
		 * @param degree	角度
		 * @return 			弧度
		 *
		 */
		public static function degree2radian(deg:Number):Number
		{
			return deg / 180.0 * Math.PI;
		}

		/**
		 *	弧度转角度 
		 * @param rad
		 * @return 
		 * 
		 */		
		public function radian2degree(rad:Number):Number
		{
			return rad / Math.PI * 180.0;            
		}
		
		/**
		 * 设定一个波动函数
		 * @param value	波动值
		 * @return
		 *
		 */
		public static function ranWave(value:Number):Number
		{
			return Math.random() * (value * 2) - value;
		}

		/**
		 * 向上取任意整数的最靠近的2的n次方数
		 */
		public function getUpPower2(n:uint):uint
		{
			if ((n & n - 1) == 0)
				return n;
			if ((n & 0x80000000) != 0)
				return 0;

			var i:uint=1;
			while (i < n)
			{
				i<<=1;
			}
			return i;
		}
		
		/**
		 *	判断给定数值是否在 给定区间内,包含两段数据[min,max]
		 * @param value
		 * @param min
		 * @param max
		 * @return
		 *
		 */
		public static function isIn(value:Number, min:Number, max:Number):Boolean
		{
			if (min > max)
			{
				var msg:String="给定数据存在问题,min:" + min + ",max:" + max + ",value:" + value + '';
				throw new IllegalOperationError(msg);
			}
			
			if (min == max)
			{
				return value == min;
			}
			
			return value >= min && value <= max;
		}
	}
}
