package com.shrimp.framework.core
{
	import flash.display.Sprite;

	/**
	 *	应用基类
	 * @author Sol
	 *
	 */
	public class ApplicationBase extends Sprite
	{
		public static var app:Sprite;

		public function ApplicationBase()
		{
			super();
			app=this;
		}
	}
}
