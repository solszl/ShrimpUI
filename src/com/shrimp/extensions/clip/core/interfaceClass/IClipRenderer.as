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
		 *相对于IClip的位置（根据IClip的注册点而设置）
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