package com.shrimp.framework.load
{
	/**
	 * 加载文件类型，用来指定用什么加载方式去加载资源
	 * @author Sol
	 * 
	 */	
	public class ResourceType
	{
		/**加载swf文件，返回1*/
		public static const SWF:uint = 0;
		/**加载位图，返回Bitmapdata*/
		public static const BMD:uint = 1;
		/**加载AMF数据，返回Object*/
		public static const AMF:uint = 2;
		/**加载TXT、XML文本，返回String*/
		public static const TXT:uint = 3;
		/**加载经过压缩的ByteArray，返回Object*/
		public static const DB:uint = 4;
		/**加载未压缩的ByteArray，返回ByteArray*/
		public static const BYTE:uint = 5;
	}
}