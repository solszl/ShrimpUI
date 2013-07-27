package com.shrimp.managers
{
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
		public function getBitmapData(name:String, cache:Boolean=true):BitmapData
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
				if (cache)
				{
					bmdCache[name]=bmd;
				}
			}
			return bmd;
		}
		
		/**缓存位图数据*/
		public function cacheBitmapData(name:String, bmd:BitmapData):void {
			if (bmd) {
				bmdCache[name] = bmd;
			}
		}
		
		/**销毁位图数据*/
		public function disposeBitmapData(name:String):void {
			var bmd:BitmapData = bmdCache[name];
			if (bmd) {
				delete bmdCache[name];
				bmd.dispose();
			}
		}
	}
}
