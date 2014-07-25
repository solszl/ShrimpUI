package com.shrimp.framework.load
{
	import com.shrimp.framework.utils.ClassUtils;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class ResourceDomain
	{
		/**	资源*/
		public static var resourceMap:Dictionary=new Dictionary();
		/**	特效*/
		public static var effectMap:Dictionary=new Dictionary();

		/**
		 * 向资源集合中添加资源
		 * @param key	资源key,通常传入这个资源所在的类的名字 面板的话,通常为 PANEL{0}	通配为面板ID, PANEL207 
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
			trace("remove resource ",key);
			if (key in resourceMap)
			{
				delete resourceMap[key]
			}
			ResourceLibrary.removeFromLibrary(key);
		}

		/**
		 * 向资源集合中添加特效资源
		 * @param key 通常为 PANEL{0}	通配为面板ID, DOMAIN207 
		 * @param domain
		 * 
		 */		
		public static function addDomain(domainName:String, domain:ApplicationDomain):void
		{
			effectMap[domainName]=domain;
		}

		public static function removeDomain(domainName:String):void
		{
			if (domainName in effectMap)
			{
				delete effectMap[domainName];
			}
		}

		public static function getDomainClass(domainName:String, linkName:String):Class
		{
			var domain:ApplicationDomain;
			if (domainName in effectMap)
			{
				domain=effectMap[domainName];
			}

			return ClassUtils.getClass(linkName, domain);
		}

		public static function getDomainInstance(domainName:String, linkName:String):*
		{
			var domain:ApplicationDomain;
			if (domainName in effectMap)
			{
				domain=effectMap[domainName];
			}

			return ClassUtils.getClassInstance(linkName, domain);
		}

		public static function hasResource(domainName:String):Boolean
		{
			return resourceMap[domainName] != null;
		}

		public static function hasDomain(domainName:String):Boolean
		{
			return effectMap[domainName] != null
		}
	}

}
