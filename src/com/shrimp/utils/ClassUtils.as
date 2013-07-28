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
		public static function getClassInstance(className:String):*
		{
			var instance:*;

			if (ApplicationDomain.currentDomain.hasDefinition(className))
			{
				var getClass:Class=ApplicationDomain.currentDomain.getDefinition(className) as Class;
				instance=new getClass();
				return instance;
			}
			else
			{
				return null;
			}
		}

		/**获取类**/
		public static function getClass(className:String):Class
		{
			if (ApplicationDomain.currentDomain.hasDefinition(className))
			{
				var getClass:Class=ApplicationDomain.currentDomain.getDefinition(className) as Class;
				return getClass;
			}
			else
			{
				return null;
				trace("未找到类" + className);
			}
		}
	}
}
