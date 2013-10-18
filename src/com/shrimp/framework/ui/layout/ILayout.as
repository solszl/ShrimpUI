package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;

	/**
	 *	布局接口 
	 * @author Sol
	 * 
	 */	
	public interface ILayout
	{
		function toString():String;
		function layout(target:Component):void;
	}
}