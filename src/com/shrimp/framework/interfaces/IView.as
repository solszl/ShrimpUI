package com.shrimp.framework.interfaces
{
	public interface IView
	{
		function onShow():void;
		function onHide(endCallBK:Function=null):void;
		function destroy():void;
	}
}