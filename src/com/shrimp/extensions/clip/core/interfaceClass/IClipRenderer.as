package com.shrimp.extensions.clip.core.interfaceClass
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 *IClip渲染器接口 -- IClip使用此接口类型渲染数据
	 * @author yeah
	 */	
	public interface IClipRenderer
	{
		/**
		 *数据源 
		 * @return 
		 */		
		function get data():Object;
		function set data($value:Object):void;
		
		/**
		 *返回自己 
		 * @return 
		 */		
		function get self():DisplayObject;
		
		/**
		 *设置位置(偏移量 - 注册点)
		 * @param $x
		 * @param $y
		 */		
		function move($x:Number, $y:Number):void;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
		
		function get width():Number;
		function get height():Number;
	}
}