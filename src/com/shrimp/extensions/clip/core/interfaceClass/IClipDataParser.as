package com.shrimp.extensions.clip.core.interfaceClass
{

	/**
	 *支持多种数据源的解析器接口
	 * @author yeah
	 */	
	public interface IClipDataParser
	{
		/**
		 *解析前的数据 
		 * @return 
		 */		
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 *获取解析器的键,通过此键获取解析器 
		 * @return 
		 */		
		function get parserKey():String;
		
	}
}