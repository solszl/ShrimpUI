package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.load.LoaderManager;
	import com.shrimp.framework.load.ResourceLibrary;
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
		private var _img:AutoBitmap;

		public function Image(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_img=new AutoBitmap();
			addChildAt(_img, 0);
		}

		private var _source:Object;
		private var _usescale9Rect:Boolean;

		public function get source():Object
		{
			return _source;
		}

		public function set source(value:Object):void
		{
			if (_source == value)
				return;
			_img.bitmapData=null;

			if (value is String)
			{
				if (String(value).indexOf("Embed(") == 0)
				{
					_img.bitmapData=ResourceLibrary.getBitmapData(String(value));
					if (_img.bitmapData == null)
					{
						onFailed(null);
					}
				}
				else
				{

					if (AssetsManager.hasLoaded(String(value)))
					{
						_img.bitmapData=AssetsManager.getInstance().getBitmapData(String(value));
					}
					else
					{
						LoaderManager.loadBMD(String(value), onComplete, null, onFailed);
					}
				}
			}
			var bit:BitmapData;
			var w:int;
			var h:int;
			if (value is Class)
			{

				if (getQualifiedSuperclassName(value) == getQualifiedClassName(BitmapData))
				{
					bit=new value(1, 1);
				}
				else
				{
					bit=DisplayObjectUtils.getDisplayBmd(new value());
				}
				_img.bitmapData=bit;
				_img.width=bit.width;
				_img.height=bit.height;
				invalidateDisplayList();
			}
			else if (value is BitmapData)
			{
				bit=value as BitmapData;
				_img.bitmapData=bit;
				_img.width=bit.width;
				_img.height=bit.height;
				invalidateDisplayList();
			}
			_source=value;
		}

		protected function onComplete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			_img.bitmapData=(content as BitmapData);
			AssetsManager.getInstance().cacheBitmapData(String(_source), _img.bitmapData);
			validateNow();
		}

		protected function onFailed(url:String):void
		{
			trace("url:", url, "  load failed");
			graphics.beginFill(0xFF0000);
			graphics.drawRect(0, 0, 4, 4);
			graphics.endFill();
		}
		private var _scale9Rect:Rectangle;

		public function get scale9Rect():Rectangle
		{
			return _scale9Rect;
		}

		public function set scale9Rect(value:Rectangle):void
		{
			if (_scale9Rect && value && _scale9Rect.equals(value))
				return;

			_scale9Rect=value;

			_usescale9Rect=value != null;

			if (_img.bitmapData == null)
				return;

			invalidateDisplayList();
		}

		override protected function measure():void
		{
			measuredWidth=_img.width;
			measuredHeight=_img.height;
		}

		override protected function updateDisplayList():void
		{
			if (_img && _img.bitmapData)
			{
				super.updateDisplayList();

				if (_usescale9Rect)
				{
					_img.bitmapData=DisplayObjectUtils.scale9Bmd(_img.bitmapData, scale9Rect, width, height);
				}
				else
				{
					if (_img.width != _width)
						width=_img.width;
					if (_img.height != _height)
						height=_img.height;
				}
			}
		}

		public function getSourceBmd():BitmapData
		{
			if (_img && _img.bitmapData)
				return _img.bitmapData;

			return null;
		}
	}
}
