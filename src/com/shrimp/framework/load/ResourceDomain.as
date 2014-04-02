package com.shrimp.framework.load
{
	import com.shrimp.framework.utils.ClassUtils;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author Sol
	 * 
	 */
	public class ResourceDomain
	{
		/**	资源*/
		public static var resourceMap:Dictionary=new Dictionary();
		/**	特效*/
		public static var effectMap:Dictionary=new Dictionary();

		/**
		 * 向资源集合中添加资源
		 * @param key	资源key,通常传入这个资源所在的类的名字
		 * @param content	资源内容
		 */		
		public static function addResource(key:String, content:Object):void
		{
			resourceMap[key]=content;
			ResourceLibrary.addLibrary(key,content);
		}

		/**
		 * 资源集合里 删除资源
		 * @param clazz 资源key,通常传入这个资源所在的类
		 */		
		public static function removeResource(key:String):void
		{
			if (key in resourceMap)
			{
				delete resourceMap[key]
			}
			ResourceLibrary.removeFromLibrary(key);
		}

		public static function addDomain(clazz:Class, domain:ApplicationDomain):void
		{
			var key:String=ClassUtils.getClassName(clazz);
			effectMap[key]=domain;
		}

		public static function removeDomain(clazz:Class):void
		{
			var key:String=ClassUtils.getClassName(clazz);
			if (key in effectMap)
			{
				delete effectMap[key];
			}
		}

		public static function getDomainClass(className:String, key:String):Class
		{
			var domain:ApplicationDomain;
			if (key in effectMap)
			{
				domain=effectMap[key];
			}

			return ClassUtils.getClass(className, domain);
		}

		public static function getDomainInstance(className:String, key:String):*
		{
			var domain:ApplicationDomain;
			if (key in effectMap)
			{
				domain=effectMap[key];
			}

			return ClassUtils.getClassInstance(className, domain);
		}
		
		public static function hasResource(key:String):Boolean
		{
			return resourceMap[key]!=null;	
		}
	}
}
