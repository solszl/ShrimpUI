package com.shrimp.framework.load
{
	import com.shrimp.framework.log.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class ResourceLibrary
	{

		/**
		 * 素材包列表，以ResourceType为key.
		 */
		private static var librayList:Dictionary=new Dictionary();

		/**
		 * 获取素材包中的一个 Bitmap
		 * @param key
		 * @param type
		 * @return
		 *
		 */
		public static function getBitmap(key:String, type:String=null):Bitmap
		{
			var bmd:BitmapData=getBitmapData(key, type);

			if (bmd)
			{
				return new Bitmap(bmd);
			}

			return null;
		}

		/**
		 * 获取素材包中的一个 BitmapData
		 * @param key
		 * @param type
		 * @return
		 *
		 */
		public static function getBitmapData(key:String, type:String=null):BitmapData
		{
			var cls:Class=getClass(key);
			if (cls && getQualifiedSuperclassName(cls) == getQualifiedClassName(BitmapData))
			{
				return new cls();
			}

			return null;
		}

		/**
		 * 获取素材包中的一个类
		 * @param key
		 * @param type
		 * @return
		 *
		 */
		public static function getClass(key:String, type:String=null):Class
		{
			var lib:Object;
			if (type == null)
			{
				for (var item:String in librayList)
				{
					lib=librayList[item];
					if (key in lib)
					{
						return lib[key];
					}
				}
			}
			else
			{
				if (type in librayList)
				{
					lib=librayList[type] as Object;
					if (key in lib)
					{
						return lib[key];
					}
				}
			}
			Logger.getLogger("ResourceLibrary").error("Warning:: unknow definition in ResourceLibrary.getClass:: ",key);
			return null;
		}

		/**
		 * 添加打包后的素材库
		 * @param type
		 * @param lib
		 *
		 */
		public static function addLibrary(type:String, lib:Object):void
		{
			if(type in librayList)
				throw new Error("发生资源覆盖，危险！！")
			librayList[type]=lib;
		}
	}
}