package com.shrimp.framework.load
{
	import com.shrimp.framework.log.Logger;
	
	import flash.system.ApplicationDomain;

	/**
	 *	加载管理器。 再程序初始化的时候。 实例化该类
	 * @author Sol
	 *
	 */
	public class LoaderManager
	{
		/**	加载器*/
		private static var _resLoader:ResourceLoader=new ResourceLoader();
		private static var _resInfos:Array=[];
		private static var _failRes:Object={};
		private static var _isLoading:Boolean;

		private static var currentItem:Object;
		private static var onCompleteCallBack:Function;
		private static var onProgressCallBack:Function;
		private static var onFailedCallBack:Function;

		/**	默认函数构造器*/
		public function LoaderManager()
		{
		}

		/**
		 *	 加载单一文件
		 * @param url	文件路径
		 * @param type	文件类型
		 * @param complete	加载完成后的回调
		 * @param progress	加载过程中的回调
		 * @param error	加载出错的回调
		 * @param useCache	是否缓存数据
		 *
		 */
		public static function load(loadItem:Object, complete:Function=null, progress:Function=null, error:Function=null, useCache:Boolean=true):void
		{
			var content:Object=ResourceLoader.getResLoaded(loadItem.url);
//			onCompleteCallBack=complete;
//			onProgressCallBack=progress;
//			onFailedCallBack=error;
			loadItem.complete = complete;
			loadItem.progress = progress;
			loadItem.error = error;
			if (content != null)
			{
				endLoad(loadItem, content, null);
			}
			else
			{
				_resInfos.push(loadItem);
				checkNext();
			}
		}

		private static function checkNext():void
		{
			if (_isLoading)
			{
				return;
			}
			_isLoading=true;
			//检测加载队列是否还存在待加载的
			while (_resInfos.length > 0)
			{
				currentItem=_resInfos.shift();
				var content:Object=ResourceLoader.getResLoaded(currentItem.url);
				if (content != null)
				{
					endLoad(currentItem, content, null);
				}
				else
				{
					_resLoader.load(currentItem, itemLoadComplete, onprogress, onFailed, true);
					function itemLoadComplete(item:Object, content:Object, domain:ApplicationDomain):void
					{
						endLoad(item, content, domain);
						_isLoading=false;
						checkNext();
					}

					function onprogress():void
					{

					}

					function onFailed():void
					{

					}
					return;
				}
			}
			_isLoading=false;
		}

		private static function endLoad(info:Object, content:Object, domain:ApplicationDomain):void
		{
			//如果加载后为空，放入队列末尾重试一次
			if (content == null)
			{
				if (_failRes[info.url] == null)
				{
					_failRes[info.url]=1;
					_resInfos.push(info);
					return;
				}
				else
				{
					Logger.getLogger("loaderManager").error("load error:", info.url);
					if (info.error != null)
					{
						info.error(info, info.url);
					}
				}
			}

//			if (onCompleteCallBack!=null)
//			{
//				onCompleteCallBack(info, content, domain)
//			}
			
			if(info.complete)
			{
				info.complete(info, content, domain);
			}
		}

		/**加载SWF，返回1*/
		public static function loadSWF(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var obj:Object={};
			obj.url=url;
			obj.type=ResourceType.SWF;
			load(obj, complete, progress, error, isCacheContent);
		}

		/**加载位图，返回Bitmapdata*/
		public static function loadBMD(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var obj:Object={};
			obj.url=url;
			obj.type=ResourceType.BMD;
			load(obj, complete, progress, error, isCacheContent);
		}

		/**加载AMF，返回Object*/
		public static function loadAMF(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var obj:Object={};
			obj.url=url;
			obj.type=ResourceType.AMF;
			load(obj, complete, progress, error, isCacheContent);
		}

		/**加载TXT，返回String*/
		public static function loadTXT(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var obj:Object={};
			obj.url=url;
			obj.type=ResourceType.TXT;
			load(obj, complete, progress, error, isCacheContent);
		}

		/**加载 压缩过的二进制数据，返回Object*/
		public static function loadDB(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var obj:Object={};
			obj.url=url;
			obj.type=ResourceType.DB;
			load(obj, complete, progress, error, isCacheContent);
		}

		/**加载BYTE，返回ByteArray*/
		public static function loadBYTE(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var obj:Object={};
			obj.url=url;
			obj.type=ResourceType.BYTE;
			load(obj, complete, progress, error, isCacheContent);
		}

		/**加载数组里面的资源
		 * @param arr 简单：["a.swf","b.swf"]，复杂[{url:"a.swf",type:ResLoader.SWF,size:100},{url:"a.png",type:ResLoader.BMD,size:50}]*/
		public static function loadAssets(arr:Array, complete:Function=null, progress:Function=null, onAllComplete:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			var itemCount:int=arr.length;
			var itemloaded:int=0;
			var totalSize:int=0;
			var totalLoaded:int=0;
			for (var i:int=0; i < itemCount; i++)
			{
				var item:Object=arr[i];
				if (item is String)
				{
					item={url: item, type: item.type};
				}
				totalSize+=1;
				load(item, loadAssetsComplete, loadAssetsProgress, error, isCacheContent);
			}

			function loadAssetsComplete(item:Object, content:Object, domain:ApplicationDomain):void
			{
				itemloaded++;
				if (complete != null)
				{
					complete(item, content, domain);
				}
				if (itemloaded == itemCount)
				{
					if (onAllComplete != null)
					{
						onAllComplete();
					}
				}
			}

			function loadAssetsProgress(size:int, value:Number):void
			{
				if (progress != null)
				{
					value=(totalLoaded + size * value) / totalSize;
					progress(value);
				}
			}
		}

		/**获得已加载的资源*/
		public static function getResLoaded(url:String):*
		{
			ResourceLoader.getResLoaded(url);
		}

		/**尝试关闭加载*/
		public static function tryToCloseLoad(url:String):void
		{
			if (_resLoader.url == url)
			{
				_resLoader.tryToCloseLoad();
				Logger.getLogger("loaderManager").warning("Try to close load:", url);
				_isLoading=false;
				checkNext();
			}
		}

		public static function hadLoaded(url:String):Boolean
		{
			return url in ResourceLoader.loadedCache
		}
	}
}
