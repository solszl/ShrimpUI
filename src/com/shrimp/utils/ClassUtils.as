package com.shrimp.utils
{
	import flash.system.ApplicationDomain;

	/**
	 * 从当前应用域中获取类、或类的实例。
	 * @author Sol
	 */
	public class ClassUtils
	{
		/**获取类的实例**/
		public static function getClassInstance(className:String,domain:ApplicationDomain=null):*
		{
			var instance:*;

			if(domain==null)
			{
				domain = ApplicationDomain.currentDomain;
			}
			if (domain.hasDefinition(className))
			{
				var getClass:Class=domain.getDefinition(className) as Class;
				instance=new getClass();
				return instance;
			}
			else
			{
				return null;
			}
		}

		/**获取类**/
		public static function getClass(className:String,domain:ApplicationDomain=null):Class
		{
			if(domain==null)
			{
				domain = ApplicationDomain.currentDomain;
			}
			
			if (domain.hasDefinition(className))
			{
				var getClass:Class=domain.getDefinition(className) as Class;
				return getClass;
			}
			else
			{
				trace("未找到类" + className);
				return null;
			}
		}
	}
}
