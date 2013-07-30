package com.shrimp.framework.load
{
	/**
	 *	加载对象，包内可见 
	 * @author Sol
	 * 
	 */	
	internal class ResourceVo
	{
		public var url:String;
		public var type:int;
		public var weight:int=0;
		public var complete:Function;
		public var progress:Function;
		public var error:Function;
	}
}