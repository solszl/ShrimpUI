package com.shrimp.managers
{
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 *	组件管理 
	 * @author Sol
	 * 
	 */	
	public class ComponentManager
	{
		private static var sp:Shape;
		private static function forceUpdate():void
		{
			if(!sp)
				sp=new Shape();
		}
	}
}