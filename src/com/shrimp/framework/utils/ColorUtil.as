package com.shrimp.framework.utils
{
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;

	/**
	 *	颜色工具类
	 * @author Sol
	 *
	 */
	public class ColorUtil
	{
		/**黑色**/
		public static const RGB_BLACK:uint=0x000000;
		/**亮灰色**/
		public static const RGB_LIGHTGRAY:uint=0xcccccc;
		/**灰色**/
		public static const RGB_GRAY:uint=0xaaaaaa; //0xC0C0C0;
		/**白色**/
		public static const RGB_WHITE:uint=0xffffff;
		/**绿色**/
		public static const RGB_GREEN:uint=0x28dd54; //0x00ff00;
		/**蓝色**/
		public static const RGB_BLUE:uint=0x679dff; //0x0000ff;
		/**紫色**/
		public static const RGB_PURPLE:uint=0xc770fe; //0xa020f0;
		/**金色**/
		public static const RGB_GOLD:uint=0xf8cb40; //0xffd700;
		/**淡黄色**/
		public static const RGB_YELLOWY:uint=0xC6B26F;
		/**石板蓝**/
		public static const RGB_SLATE_BLUE:uint=0x6a5acd;
		/**红色**/
		public static const RGB_RED:uint=0xff0000;
		/**橙色**/
		public static const RGB_ORANGE:uint=0xff9a00;
		// 普通
		public static const defaultTransform:ColorTransform=new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		// 变灰
		public static const fadeFilter:ColorMatrixFilter=new ColorMatrixFilter([1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 0, 0, 0, 1, 0]);
		// 高亮
		private static const highLightTransform:ColorTransform=new ColorTransform(1, 1, 1, 1, 50, 50, 0, 0);

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

		/**
		 * 使物体褪色，变为黑白色
		 * @param displayObject 要被褪色的显示对象
		 */
		public static function fadeColor(displayObject:DisplayObject):void
		{
			deFadeColor(displayObject);
			var filters:Array=displayObject.filters;
			filters.push(fadeFilter);
			displayObject.filters=filters;
			displayObject.transform.colorTransform=new ColorTransform(0.8, 0.8, 0.8, 1, 10, 10, 10, 0);
		}

		/**
		 * 使物体恢复彩色
		 * @param displayObject 要恢复色彩的显示对象
		 */
		public static function deFadeColor(displayObject:DisplayObject):void
		{
			var filters:Array=displayObject.filters;
			for (var i:int=0; i < filters.length; i++)
			{
				var colorFilter:ColorMatrixFilter=filters[i] as ColorMatrixFilter;
				// 如果不是ColorMatrixFilter则跳过
				if (colorFilter == null)
					continue;
				// 如果与变灰滤镜相同则删除
				var flag:Boolean=true;
				var cMatrix:Array=colorFilter.matrix;
				var fMatrix:Array=fadeFilter.matrix;
				for (var j:int=0; j < 20; j++)
				{
					if (cMatrix[j] != fMatrix[j])
					{
						flag=false;
						break;
					}
				}
				if (flag)
				{
					filters.splice(i, 1);
					break;
				}
			}
			displayObject.filters=filters;
			displayObject.transform.colorTransform=defaultTransform;
		}

		//加光边
		public static function addColorRing(target:DisplayObject, color:uint=0xcccc00, diffuse:Number=3, strength:Number=6):void
		{
			if (target)
			{
				var filters:Array=target.filters;
				var filter:GlowFilter
				for (var i:String in filters)
				{
					if (filters[i] is GlowFilter)
					{
						filter=filters[i];
						break;
					}
				}

				if (filter)
				{
					filter.color=color;
				}
				else
				{
					filter=new GlowFilter(color, 1, diffuse, diffuse, strength, 2);
					filters.push(filter);
				}

				target.filters=filters;
			}
		}

		//取消光边
		public static function removeColorRing(target:DisplayObject):void
		{
			if (target && target.filters)
			{
				for (var i:int=0; i < target.filters.length; i++)
				{
					if (target.filters[i] is GlowFilter)
					{
						var filers:Array=target.filters;
						filers.splice(i, 1);
						target.filters=filers;
					}
				}
			}
		}

		public static function addShadow(target:DisplayObject, distance:int=4, strength:int=1, alpha:Number=.5):void
		{
			var filter:DropShadowFilter=new DropShadowFilter(distance, 45, 0, alpha, 2, 2, strength);
			var filters:Array=target.filters;
			filters.push(filter);
			target.filters=filters;
		}

		public static function addBlur(target:DisplayObject, strength:int):void
		{
			if (target)
			{
				var filter:BlurFilter;
				var filters:Array=target.filters;
				for (var i:String in filters)
				{
					if (filters[i] is BlurFilter)
					{
						filter=filters[i];
						break;
					}
				}

				if (filter)
				{
					filter.blurX=filter.blurY=strength;
				}
				else
				{
					filter=new BlurFilter(strength, strength);
					filters.push(filter);
				}
				target.filters=filters;
			}
		}

		/**
		 * 将整型数值转换成 RGB 格式的颜色字符串
		 *
		 * @param colorInt
		 * @return
		 *
		 */
		public static function toHexColor(colorInt:uint):String
		{
			return '#' + colorInt.toString(16);
		}
	}
}
