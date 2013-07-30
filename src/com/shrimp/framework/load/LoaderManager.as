package com.shrimp.framework.load
{
	import com.shrimp.framework.log.Logger;

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

		/**	默认函数构造器*/
		public function LoaderManager()
		{
		}

		private static var vo:ResourceVo;
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
		public static function load(url:String, type:int, complete:Function=null, progress:Function=null, error:Function=null, useCache:Boolean=true):void
		{
			vo=new ResourceVo();
			vo.url=url;
			vo.type=type;
			vo.complete=complete;
			vo.progress=progress;
			vo.error=error;

			var content:*=ResourceLoader.getResLoaded(vo.url);
			if (content != null)
			{
				endLoad(vo, content);
			}
			else
			{
				_resInfos.push(vo);
				checkNext();
			}
		}

		private static function checkNext():void
		{
			if (_isLoading) {
				return;
			}
			_isLoading = true;
			//检测加载队列是否还存在待加载的
			while (_resInfos.length > 0)
			{
				var info:ResourceVo=_resInfos.shift();
				var content:*=ResourceLoader.getResLoaded(info.url);
				if (content != null)
				{
					endLoad(info, content);
				}
				else
				{
					_resLoader.load(info.url, info.type, loadComplete, info.progress, info.error, true);
					return;
				}
			}
			_isLoading = false;
		}

		private static function loadComplete(content:*):void
		{
			endLoad(vo, content);
			_isLoading = false;
			checkNext();
		}

		private static function endLoad(info:ResourceVo, content:*):void
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
						info.error(info.url);
					}
				}
			}
			if (info.complete != null)
			{
				info.complete(content);
			}
		}

		/**加载SWF，返回1*/
		public static function loadSWF(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			load(url, ResourceType.SWF, complete, progress, error, isCacheContent);
		}

		/**加载位图，返回Bitmapdata*/
		public static function loadBMD(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			load(url, ResourceType.BMD, complete, progress, error, isCacheContent);
		}

		/**加载AMF，返回Object*/
		public static function loadAMF(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			load(url, ResourceType.AMF, complete, progress, error, isCacheContent);
		}

		/**加载TXT，返回String*/
		public static function loadTXT(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			load(url, ResourceType.TXT, complete, progress, error, isCacheContent);
		}

		/**加载 压缩过的二进制数据，返回Object*/
		public static function loadDB(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			load(url, ResourceType.DB, complete, progress, error, isCacheContent);
		}

		/**加载BYTE，返回ByteArray*/
		public static function loadBYTE(url:String, complete:Function=null, progress:Function=null, error:Function=null, isCacheContent:Boolean=true):void
		{
			load(url, ResourceType.BYTE, complete, progress, error, isCacheContent);
		}

		/**加载数组里面的资源
		 * @param arr 简单：["a.swf","b.swf"]，复杂[{url:"a.swf",type:ResLoader.SWF,size:100},{url:"a.png",type:ResLoader.BMD,size:50}]*/
		public static function loadAssets(arr:Array, complete:Function=null, progress:Function=null,onAllComplete:Function=null, error:Function=null, isCacheContent:Boolean=true):void
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
				load(item.url, item.type, loadAssetsComplete, loadAssetsProgress, error, isCacheContent);
			}

			function loadAssetsComplete(content:*):void
			{
				itemloaded++;
				if (complete != null)
				{
					complete(content);
				}
				if(itemloaded == itemCount)
				{
					if(onAllComplete!=null)
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
		public static function tryToCloseLoad(url:String):void {
			if (_resLoader.url == url) {
				_resLoader.tryToCloseLoad();
				Logger.getLogger("loaderManager").warning("Try to close load:", url);
				_isLoading = false;
				checkNext();
			}
		}
		
		public static function hadLoaded(url:String):Boolean
		{
			return url in ResourceLoader.loadedCache
		}
	}
}
