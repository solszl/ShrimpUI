package com.shrimp.framework.utils
{

	/**
	 *	颜色工具类
	 * @author Sol
	 *
	 */
	public class ColorUtil
	{
		/**
		 * 计算反色。
		 * @param rgb RGB 颜色。
		 * @return 参数 rgb 的反色。
		 */
		public static function getReverseColor(rgb:uint):uint
		{
			var r:uint=0xFF - (rgb >> 16 & 0xFF);
			var g:uint=0xFF - (rgb >> 8 & 0xFF);
			var b:uint=0xFF - (rgb & 0xFF);
			return (r << 16) | (g << 8) | b;
		}
	}
}
