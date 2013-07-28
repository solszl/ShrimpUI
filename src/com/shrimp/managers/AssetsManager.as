package com.shrimp.managers
{
	import com.shrimp.load.ResourceType;
	import com.shrimp.log.Logger;
	
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
		private static var txtCache:Dictionary = new Dictionary();

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

		/**获取类*/
		public function getClass(name:String):Class
		{
			if (hasClass(name))
			{
				return _domain.getDefinition(name) as Class;
			}
			Logger.getLogger("AssetManager").error("Miss Asset:", name);
			return null;
		}

		/**获取资源*/
		public function getAsset(name:String):*
		{
			var clazz:Class=getClass(name);
			if (clazz != null)
			{
				return new clazz();
			}
			return null;
		}

		/**获取位图数据*/
		public function getBitmapData(name:String):BitmapData
		{
			var bmd:BitmapData=bmdCache[name];
			if (bmd == null)
			{
				var bmdClass:Class=getClass(name);
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
		
		public function cacheObject(name:String,content:*):void
		{
			if(content)
			{
				byteArrayCache[name]=content;
			}
		}
		/**	文本缓存
		 * dictionary内缓存的是不定性的Object，取出来的时候。手动as 转换一下 需要*/
		public function cacheTxtXML(name:String,content:*):void
		{
			if(content)
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

		public static function hasLoaded(type:int, url:String):Boolean
		{
			switch (type)
			{
				case ResourceType.BMD:
					if (url in bmdCache)
						return true;
				case ResourceType.TXT:
					return false;
				case ResourceType.SWF:
					return false
			}
			return false;
		}
	}
}
