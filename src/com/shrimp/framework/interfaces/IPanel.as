package com.shrimp.framework.interfaces
{
	/**
	 *	Panel接口 
	 * @author Sol
	 * 
	 */	
	public interface IPanel
	{
		function show(...arg):void;
		function hide():void;
		function isOpen():Boolean;
		function set data(value:*):void;
		function get data():*;
		function set standAlone(value:Boolean):void;
		function get standAlone():Boolean;
		function set modal(value:Boolean):void;
		function get modal():Boolean;
		function clean():void;
		function dispose():void;
	}
}