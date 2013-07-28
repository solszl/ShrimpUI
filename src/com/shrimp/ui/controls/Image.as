package com.shrimp.ui.controls
{
	import com.shrimp.load.LoaderManager;
	import com.shrimp.load.ResourceLoader;
	import com.shrimp.load.ResourceType;
	import com.shrimp.managers.AssetsManager;
	import com.shrimp.ui.controls.core.Component;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
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
			addChildAt(_img,0);
		}
		
		private var _source:Object;
		public function set source(value:Object):void
		{
			if (_source == value)
				return;
			_img.bitmapData = null;
			
			if(value is String)
			{
				if(AssetsManager.hasLoaded(ResourceType.BMD,String(value)))
				{
					_img.bitmapData = AssetsManager.getInstance().getBitmapData(String(value));
					invalidateDisplayList();
				}
				else
				{
					LoaderManager.loadBMD(String(value),onComplete,null,onFailed);	
				}
			}
			else if(value is Class)
			{
				
			}
			else if(value is BitmapData)
			{
				_img.bitmapData = value as BitmapData;
				invalidateDisplayList();
			}
			
			_source=value;
		}
		
		protected function onComplete(content:*):void
		{
			_img.bitmapData = (content as BitmapData);
			invalidateDisplayList();
		}
		
		protected function onFailed(url:String):void
		{
			trace("url:",url,"  load failed");
		}
	}
}