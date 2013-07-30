package com.sg.game.framework.core
{
	import flash.display.DisplayObject;

	public interface IGuide
	{
		function addType(type:String,position:String):void;
		function addGuide(disObj:DisplayObject):void;
		function removeGuide():void;
	}
}