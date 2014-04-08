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
			ResourceLibrary.addLibrary(key, content);
		}

		/**
		 *	从资源列表中拿到key主键的资源
		 * @param key
		 * @return
		 *
		 */
		public static function getResource(key:String):Object
		{
			return resourceMap[key];
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

		public static function addDomain(key:String, domain:ApplicationDomain):void
		{
			effectMap[key]=domain;
		}

		public static function removeDomain(key:String):void
		{
			if (key in effectMap)
			{
				delete effectMap[key];
			}
		}

		public static function getDomainClass(className:String, key:String):Class
		{
			var domain:ApplicationDomain;
			if (className in effectMap)
			{
				domain=effectMap[className];
			}

			return ClassUtils.getClass(key, domain);
		}

		public static function getDomainInstance(className:String, key:String):*
		{
			var domain:ApplicationDomain;
			if (className in effectMap)
			{
				domain=effectMap[className];
			}

			return ClassUtils.getClassInstance(key, domain);
		}

		public static function hasResource(key:String):Boolean
		{
			return resourceMap[key] != null;
		}

		public static function hasDomain(key:String):Boolean
		{
			return effectMap[key] != null
		}
	}
}
