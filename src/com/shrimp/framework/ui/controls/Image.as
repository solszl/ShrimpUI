package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.load.LoaderManager;
	import com.shrimp.framework.load.ResourceLibrary;
	import com.shrimp.framework.log.Logger;
	import com.shrimp.framework.managers.AssetsManager;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.utils.DisplayObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class Image extends Component
	{
		/**	每个Image都包含着一个AutoBitmap,所有操作均对此对象进行操作*/
		private var _img:AutoBitmap;
		/**	资源图片设置给source后的回调,该回调会在destory的时候置空*/
		public var loadComplete:Function;

		public function Image(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_img = new AutoBitmap();
			addChildAt(_img, 0);
		}

		private var _source:Object;

		public function get source():Object
		{
			return _source;
		}

		/**
		 *	设置数据源,该源支持的类型有
		 * <li>1:字符串,包含,打包到资源内部导出类的字符串,以"Embed("开头,另外支持动态加载资源,支持绝对路径和相对路径</li>
		 * <li>2:导出类</li>
		 * <li>3:源数据BitmapData</li>
		 * @param value
		 *
		 */
		public function set source(value:Object):void
		{
			if (_source == value)
				return;
			_img.bitmapData = null;
			_source = value;
			if (value is String)
			{
				if (String(value).indexOf("Embed(") == 0)
				{
					_img.bitmapData = ResourceLibrary.getBitmapData(String(value));
					if (_img.bitmapData == null)
					{
						onFailed(null);
					}
				}
				else
				{

					if (AssetsManager.hasLoaded(String(value)))
					{
						_img.bitmapData = AssetsManager.getInstance().getBitmapData(String(value));
						validateProperties();
						validateSize();
						validateDisplayList();
					}
					else
					{
						LoaderManager.loadBMD(String(value), onComplete, null, onFailed);
					}
				}
			}
			var bit:BitmapData;
			if (value is Class)
			{

				if (getQualifiedSuperclassName(value) == getQualifiedClassName(BitmapData))
				{
					bit = new value(1, 1);
				}
				else
				{
					bit = DisplayObjectUtils.getDisplayBmd(new value()); //(new value()).bitmapData;//
				}
				setBitmapData(bit);
			}
			else if (value is BitmapData)
			{
				setBitmapData(value as BitmapData);
			}
		}

		/**	动态资源加载完成回调,在此回调中,设置图片内容*/
		protected function onComplete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			setBitmapData(content as BitmapData);
			if(loadComplete!=null)
			{
				loadComplete();
			}
		}

		/**	当动态加载资源为空的时候, 在图片左上角画一个 红色4x4的红点*/
		protected function onFailed(url:String):void
		{
			Logger.getLogger("control").error("data is null,url is:", url);
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 4, 4);
			graphics.endFill();
			invalidateSize();
		}

		public function get scale9Rect():Rectangle
		{
			return _img.scale9Rect;
		}

		/**
		 *	设置图片九宫格
		 * @param value
		 *
		 */
		public function set scale9Rect(value:Rectangle):void
		{
			if (value && _img.scale9Rect && _img.scale9Rect.equals(value))
				return;

			_img.scale9Rect = value;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		/**	度量,将内部_img的宽高赋值给 测量宽高*/
		override protected function measure():void
		{
			super.measure();
			if (isNaN(explicitHeight))
			{
				measuredHeight = _img.height;
			}

			if (isNaN(explicitWidth))
			{
				measuredWidth = _img.width;
			}
		}

		/**	刷新显示列表*/
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			if (_img && _img.bitmapData)
			{
				_img.width = width;
				_img.height = height;
				_img.validateSize();
			}
		}

		/**
		 *	返回图片的位图数据,如果么有进行设置过source,则返回null
		 * @return
		 *
		 */
		public function getSourceBmd():BitmapData
		{
			if (_img && _img.bitmapData)
				return _img.bitmapData;

			return null;
		}

		/**
		 *	设置位图数据
		 * @param value	数据
		 * @param useCache	是否使用缓存
		 *
		 */
		private function setBitmapData(value:BitmapData, useCache:Boolean = true):void
		{
			_img.bitmapData = value;
			if (useCache)
			{
				AssetsManager.getInstance().cacheBitmapData(String(_source), _img.bitmapData);
			}

			//将加载完成的图片宽高设定给图片
			if(width==0)
			{
				width = _img.bitmapData.width;
			}
			
			if(height==0)
			{
				this.height = _img.bitmapData.height;
			}
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		/**
		 *	销毁方法,该方法,将内部img的bitmapData进行销毁
		 *
		 */
		public function destory():void
		{
			_img.destory();
			loadComplete=null;
		}
	}
}
