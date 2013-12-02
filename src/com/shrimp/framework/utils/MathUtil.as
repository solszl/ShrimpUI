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
	}
}
