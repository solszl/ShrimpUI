package com.shrimp.framework.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

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
				return domain.getDefinition(className) as Class;
			}
			else
			{
				throw new Error("unknown className::",className);
			}
		}
		
		public static function getClassName(clazz:Class):String
		{
			return getQualifiedClassName(clazz);
		}
		
		public static function getSuperClassName(clazz:Class):String
		{
			return getQualifiedSuperclassName(clazz);
		}
	}
}
