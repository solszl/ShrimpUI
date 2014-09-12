package com.shrimp.extensions.clip.core.interfaceClass
{
	import flash.geom.Point;

	/**
	 *clip帧数据接口 
	 * @author yeah
	 */	
	public interface IClipFrameData
	{
		/**
		 * 偏移量（在每一帧对齐结束后位置偏移量。在原来位置的基础上+-而不是直接赋值） 
		 * @return 
		 */		
		function get offset():Point;
		function set offset($value:Point):void;
		
		/**
		 *帧标签, 如果没有手动设置 则会设置为自身索引
		 */		
		function get frameLabel():String;
		function set frameLabel($value:String):void;
		
		/**
		 *销毁
		 * @param 
		 * 		因为是构造函数传参或者动态创建的Dispather，所以此处确定是否清除Dispather
		 * 		true则之前注册的监听都无效，需要重新注册
		 */		
		function destroy($cleanDispather:Boolean):void;
	}
}