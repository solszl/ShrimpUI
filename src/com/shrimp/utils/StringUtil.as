package com.shrimp.utils
{
	/**
	 *	String工具类
	 * @author Sol
	 *
	 */
	public class StringUtil
	{
		/**
		 * 判断字符串是空引用，或值为空
		 * @param value
		 * @return
		 *
		 */
		public static function isNullOrEmpty(value:String):Boolean
		{
			if (value == null)
				return true;
			return value.replace(/\s/g, "") == "";
		}

		/**
		 * 使用传入的各个参数替换指定的字符串内的“{n}”标记。
		 * @example
		 *
		 *  var str:String = "here is some info '{0}' and {1}";
		 *  trace(StringUtil.substitute(str, zhenliang.sun, true));
		 *
		 *  // this will output the following string:
		 *  // "here is some info 'zhenliang.sun' and true"
		 * @param str
		 * @param rest
		 * @return
		 *
		 */
		public static function substitute(str:String, ... rest):String
		{
			if (str == null)
				return '';

			// Replace all of the parameters in the msg string.
			var len:uint=rest.length;
			var args:Array;

			if (len == 1 && rest[0] is Array)
			{
				args=rest[0] as Array;
				len=args.length;
			}
			else
			{
				args=rest;
			}

			for (var i:int=0; i < len; i++)
			{
				str=str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}

			return str;
		}

		/**
		 *	返回一个字符串组成的一个指定的字符串
		 * @param str
		 * @param n
		 * @return
		 *
		 */
		public static function repeat(str:String, n:int):String
		{
			if (n == 0)
				return "";

			var s:String=str;

			for (var i:int=1; i < n; i++)
			{
				s+=str;
			}
			return s;
		}

		/**
		 *	去掉字符串的前后空格
		 * @param input
		 * @return
		 *
		 */
		public static function trim(input:String):String
		{
			return StringUtil.ltrim(StringUtil.rtrim(input));
		}

		/**
		 *	去左空格
		 * @param input
		 * @return
		 *
		 */
		public static function ltrim(input:String):String
		{
			var size:Number=input.length;
			for (var i:Number=0; i < size; i++)
			{
				if (input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/**
		 *	去右空格
		 * @param input
		 * @return
		 *
		 */
		public static function rtrim(input:String):String
		{
			var size:Number=input.length;
			for (var i:Number=size; i > 0; i--)
			{
				if (input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}
			return "";
		}

		/**检查字符串中是否包含有中文字符**/
		public static function hasChineseCharacter(value:String):Boolean
		{
			var reg:RegExp=/[\u4e00-\u9fa5]/;
			return reg.test(value);
		}
	}
}
