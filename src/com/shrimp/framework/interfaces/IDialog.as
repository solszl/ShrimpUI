package com.shrimp.framework.interfaces
{
	public interface IDialog
	{
		function show(...arg):void;
		function hide():void;
		function set modal(b:Boolean):void;
		function get modal():Boolean;
		function isOpen():Boolean;
		function dispose():void;
		function clean():void;
	}
}