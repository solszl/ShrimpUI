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
	}
}
