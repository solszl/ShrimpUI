package com.shrimp.framework.managers
{
	import com.shrimp.framework.load.LoaderManager;
	import com.shrimp.framework.load.ResourceLibrary;
	import com.shrimp.framework.load.ResourceType;
	import com.shrimp.framework.utils.ClassUtils;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 *	资源管理类
	 * @author Sol
	 *
	 */
	public class AssetsManager
	{
		/**	位图缓存*/
		private static var bmdCache:Dictionary=new Dictionary();
		/**	序列动画缓存*/
		private static var clipCache:Dictionary=new Dictionary();
		/**	声音缓存*/
		private static var soundCache:Dictionary=new Dictionary();
		/**	byteArray、AMF,压缩后的byteArray缓存*/
		private static var byteArrayCache:Dictionary=new Dictionary();
		/**	txt文本，XML内容缓存*/
		private static var txtCache:Dictionary=new Dictionary();
		/**	其他缓存*/
		private static var otherCache:Dictionary=new Dictionary();

		private static var _domain:ApplicationDomain=ApplicationDomain.currentDomain;
		private static var _instance:AssetsManager;

		/**	资源管理类单件方法*/
		public static function getInstance():AssetsManager
		{
			if (!_instance)
			{
				_instance=new AssetsManager();
			}

			return _instance;
		}

		/**判断是否有类的定义*/
		public function hasClass(name:String):Boolean
		{
			return _domain.hasDefinition(name);
		}

		/**获取位图数据*/
		public function getBitmapData(name:String):BitmapData
		{
			var bmd:BitmapData=bmdCache[name];
			if (bmd == null)
			{
//				var bmdClass:Class=ClassUtils.getClass(name);
				var bmdClass:Class = ResourceLibrary.getClass(name);
				if (bmdClass == null)
				{
					return null;
				}
				bmd=new bmdClass(1, 1);
			}
			return bmd;
		}

		/**缓存位图数据*/
		public function cacheBitmapData(name:String, bmd:BitmapData):void
		{
			if (bmd)
			{
				bmdCache[name]=bmd;
			}
		}

		public function cacheBitmapClip(name:String, clips:Vector.<BitmapData>):void
		{
			if (clips)
			{
				clipCache[name]=clips;
			}
		}

		public function cacheObject(name:String, content:Object):void
		{
			if (content)
			{
				byteArrayCache[name]=content;
			}
		}

		/**	文本缓存
		 * dictionary内缓存的是不定性的Object，取出来的时候。手动as 转换一下 需要*/
		public function cacheTxtXML(name:String, content:Object):void
		{
			if (content)
			{
				txtCache[name]=content;
			}
		}

		/**销毁位图数据*/
		public function disposeBitmapData(name:String):void
		{
			var bmd:BitmapData=bmdCache[name];
			if (bmd)
			{
				delete bmdCache[name];
				bmd.dispose();
			}
		}

		public static function hasLoaded(url:String):Boolean
		{
			return LoaderManager.hadLoaded(url);
		}

		public static function loadItem(url:String, type:int, complete:Function=null, progress:Function=null, error:Function=null, useCache:Boolean=true):void
		{
//			LoaderManager.load(url, type, loadedItem, progress, error, useCache);
//			function loadedItem(content:Object):void
//			{
//				if (complete != null)
//				{
//					complete(content);
//				}
//				if (useCache)
//				{
//					cacheConent(type, url, content);
//				}
//			}
		}

		public static function loadAssets(arr:Array, complete:Function=null, progress:Function=null, onAllComplete:Function=null, onFailed:Function=null, useCache:Boolean=true):void
		{
			LoaderManager.loadAssets(arr, itemComplete, progress, onAllComplete, onFailed, useCache);
			function itemComplete(content:Object):void
			{
				if(complete!=null)
				{
					complete(content);
				}
				if(useCache)
				{
//					cacheConent(type, url, content);
				}
			}
		}

		private static function cacheConent(type:int, url:String, content:Object):void
		{
			switch (type)
			{
				case ResourceType.AMF:
					otherCache[url]=content;
					break;
				case ResourceType.BMD:
					bmdCache[url]=content;
					break;
				case ResourceType.BYTE:
				case ResourceType.DB:
				case ResourceType.SWF:
					otherCache[url]=content;
				case ResourceType.TXT:
					txtCache[url]=content;
				default:
					otherCache[url]=content;
					break;
			}
		}
	}
}
