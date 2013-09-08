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
		private var _img:AdvancedBitmap;

		public function Image(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_img=new AdvancedBitmap();
			addChildAt(_img, 0);
		}

		private var _source:Object;
		private var _usescale9Rect:Boolean;

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
			else if (value is Class)
			{
				var bit:BitmapData;
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
			}
			else if (value is BitmapData)
			{
				_img.bitmapData=value as BitmapData;
			}
			width=_img.bitmapData.width;
			height=_img.bitmapData.height;
			invalidateDisplayList();
			_source=value;
		}

		protected function onComplete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			_img.bitmapData=(content as BitmapData);
			AssetsManager.getInstance().cacheBitmapData(String(_source), _img.bitmapData);
			invalidateDisplayList();
		}

		protected function onFailed(url:String):void
		{
			trace("url:", url, "  load failed");
		}
		private var _scale9Rect:Rectangle;

		public function get scale9Rect():Rectangle
		{
			return _scale9Rect;
		}

		private var _originalBitmap:BitmapData;

		public function set scale9Rect(value:Rectangle):void
		{
			if (_scale9Rect && value && _scale9Rect.equals(value))
				return;

			_scale9Rect=value;

			_usescale9Rect=value != null;

			if (_usescale9Rect == false && _originalBitmap)
			{
				_originalBitmap.dispose();
			}

			if (_img && _usescale9Rect)
			{
				_originalBitmap=_img.bitmapData.clone();
			}

			invalidateDisplayList();
		}

		override protected function measure():void
		{
			measuredWidth=_img.width;
			measuredHeight=_img.height;
		}

		override protected function updateDisplayList():void
		{
			if (_img)
			{
				super.updateDisplayList();

				if (_usescale9Rect)
				{
					resizeBitmap(width, height);
				}
				else
				{
					if (_img.width != _width)
						_img.width=_width;
					if (_img.height != height)
						_img.height=height;
				}

			}
		}

		protected function resizeBitmap(w:Number, h:Number):void
		{
			if (!_originalBitmap)
			{
				_originalBitmap=_img.bitmapData.clone();
			}

			var bmpData:BitmapData=new BitmapData(w, h, true, 0x00000000);

			var rows:Array=[0, _scale9Rect.top, _scale9Rect.bottom, _originalBitmap.height];
			var cols:Array=[0, _scale9Rect.left, _scale9Rect.right, _originalBitmap.width];

			var dRows:Array=[0, _scale9Rect.top, h - (_originalBitmap.height - _scale9Rect.bottom), h];
			var dCols:Array=[0, _scale9Rect.left, w - (_originalBitmap.width - _scale9Rect.right), w];

			var origin:Rectangle;
			var draw:Rectangle;
			var mat:Matrix=new Matrix();


			for (var cx:int=0; cx < 3; cx++)
			{
				for (var cy:int=0; cy < 3; cy++)
				{
					origin=new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw=new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a=draw.width / origin.width;
					mat.d=draw.height / origin.height;
					mat.tx=draw.x - origin.x * mat.a;
					mat.ty=draw.y - origin.y * mat.d;
					bmpData.draw(_originalBitmap, mat, null, null, draw, true);
				}
			}

			_img.bitmapData.dispose();
			_img.bitmapData=bmpData;
		}
	}
}
