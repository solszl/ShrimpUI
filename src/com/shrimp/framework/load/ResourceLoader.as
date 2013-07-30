package com.shrimp.framework.load
{
	import com.shrimp.framework.log.Logger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 *	资源加载类,允许 加载swf,位图,AMF,txt,xml,压缩过的bytearray与未压缩的bytearray
	 *
	 * @author Sol
	 *
	 */
	public class ResourceLoader
	{
		private var _loader:Loader=new Loader();
		private var _urlLoader:URLLoader=new URLLoader();
		private var _urlRequest:URLRequest=new URLRequest();
		private var _loaderContext:LoaderContext=new LoaderContext(false, ApplicationDomain.currentDomain);

		private var onCompleteCallBack:Function;
		private var onProgressCallBack:Function;
		private var onFailedCallBack:Function;
		private var _useCache:Boolean;

		private var currentItem:Object;
		private var _isLoading:Boolean;

		/**	已经加载过的文件列表，以文件url为Key*/
		public static var loadedCache:Dictionary=new Dictionary();

		public function ResourceLoader()
		{
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);

			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlLoader.addEventListener(Event.COMPLETE, onUrlLoaderCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
		}

		/**	加载过程中*/
		private function onProgressHandler(e:ProgressEvent):void
		{
			onProgress(e.bytesTotal, e.bytesLoaded);
		}

		/**
		 *	load加载完成回调
		 * @param e
		 *
		 */
		private function onLoaderCompleteHandler(e:Event):void
		{
			var content:*=null;
			if (currentItem.type == ResourceType.SWF)
			{
				content=_loader.content;
			}
			else if (currentItem.type == ResourceType.BMD)
			{
				if (_urlLoader.data != null)
				{
					_loader.loadBytes(_urlLoader.data);
					_urlLoader.data=null;
					return;
				}
				content=Bitmap(_loader.content).bitmapData;
			}
			
			if (_useCache)
			{
				loadedCache[url]=content;
			}
			onComplete(currentItem,content,_loader.contentLoaderInfo.applicationDomain);
//			_loader.unloadAndStop();
		}

		/**
		 *	urlLoader 加载完成回调
		 * @param e
		 *
		 */
		private function onUrlLoaderCompleteHandler(e:Event):void
		{
			var content:*=null;
			if (currentItem.type == ResourceType.AMF)
			{
				if (_urlLoader.data && _urlLoader.data.length > 0 && _urlLoader.data.readByte() == 0x11)
				{
					content=_urlLoader.data.readObject();
				}
			}
			else if (currentItem.type == ResourceType.DB)
			{
				var bytes:ByteArray=_urlLoader.data as ByteArray;
				bytes.uncompress();
				content=bytes.readObject();
			}
			else if (currentItem.type == ResourceType.BYTE)
			{
				content=_urlLoader.data as ByteArray;
			}
			else if (currentItem.type == ResourceType.TXT)
			{
				content=_urlLoader.data;
			}
			else if (currentItem.type == ResourceType.BMD)
			{
				if (_urlLoader.data != null)
				{
					_loader.loadBytes(_urlLoader.data);
					_urlLoader.data=null;
					return;
				}
				content=Bitmap(_loader.content).bitmapData;
				_loader.unloadAndStop();
			}
			if (_useCache)
			{
				loadedCache[url]=content;
			}
			onComplete(currentItem,content,null);
		}

		/**	加载失败*/
		private function onErrorHandler(e:Event):void
		{
			Logger.getLogger("resourceLoader").error("downLoad error:: while url is:" + url);
			if (onFailedCallBack != null)
			{
				onFailedCallBack(currentItem,url);
			}
		}

		/**	网络状态*/
		private function onStatusHandler(e:HTTPStatusEvent):void
		{

		}

		protected function onProgress(bytesTotal:int, bytesLoaded:int):void
		{
			if (onProgressCallBack != null)
			{
				onProgressCallBack(bytesTotal, bytesLoaded)
			}
		}

		protected function onComplete(item:Object,content:*,domain:ApplicationDomain):void
		{
			_isLoading=false;
			if (onCompleteCallBack != null)
			{
				onCompleteCallBack(item,content,domain);
			}
		}

		/**
		 *	加载类 加载单一文件
		 * @param url
		 * @param type
		 * @param complete
		 * @param progress
		 * @param useCache
		 *
		 */
		public function load(loadItem:Object, onItemComplete:Function, onProgress:Function, onFailed:Function, useCache:Boolean=true):void
		{
			if (_isLoading)
			{
				tryToCloseLoad();
			}
			currentItem=loadItem;
			_useCache=useCache;

			this.onCompleteCallBack=onItemComplete;
			this.onProgressCallBack=onProgress;
			this.onFailedCallBack=onFailed;

			//检测是否已经加载过，如果加载过了。直接从缓存中取出并返回，否则进行加载逻辑
			var content:*=getResLoaded(url);
			if (content != null)
			{
				return onComplete(loadItem,content,null);
			}

			startLoad();
		}

		private function startLoad():void
		{
			_isLoading=true;
			_urlRequest.url=url;
			if (currentItem.type == ResourceType.SWF)
			{
				_loader.load(_urlRequest, _loaderContext);
				return;
			}
			if (currentItem.type == ResourceType.BMD || currentItem.type == ResourceType.AMF || currentItem.type == ResourceType.DB || currentItem.type == ResourceType.BYTE)
			{
				_urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
				_urlLoader.load(_urlRequest);
				return;
			}
			if (currentItem.type == ResourceType.TXT)
			{
				_urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
				_urlLoader.load(_urlRequest);
				return;
			}
		}

		/**中止加载*/
		public function tryToCloseLoad():void
		{
			try
			{
				_loader.unloadAndStop();
				_urlLoader.close();
				_isLoading=false;
			}
			catch (e:Error)
			{
			}
		}

		/**获取已加载的资源*/
		public static function getResLoaded(url:String):*
		{
			return loadedCache[url];
		}

		/**删除已加载的资源*/
		public static function clearResLoaded(url:String):void
		{
			var res:*=loadedCache[url];
			if (res is BitmapData)
			{
				BitmapData(res).dispose();
			}
			else if (res is Bitmap)
			{
				Bitmap(res).bitmapData.dispose();
			}
			delete loadedCache[url];
		}

		/**加载资源的地址*/
		public function get url():String
		{
			return currentItem.url;
		}
	}
}
