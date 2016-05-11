package com.shrimp.framework.load
{
	import com.shrimp.framework.utils.ClassUtils;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class ResourceDomain
	{
		/**	资源*/
		public static var resourceMap:Dictionary=new Dictionary();

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

		public static function hasResource(domainName:String):Boolean
		{
			return resourceMap[domainName] != null;
		}
	}

}
