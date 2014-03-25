package com.shrimp.framework.utils
{
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
		public static function degree2radian(degree:Number):Number
		{
			return degree / 180.0 * Math.PI;
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
	}
}
