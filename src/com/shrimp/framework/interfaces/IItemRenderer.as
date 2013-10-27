package com.shrimp.framework.interfaces
{
	public interface IItemRenderer
	{
		function get data():*;
		function set data(value:*):void
		
		function get selected():Boolean
		function set selected(value:Boolean):void;
		
		function get index():int;
		function set index(value:int):void;
		
		function dispose():void;
	}
}