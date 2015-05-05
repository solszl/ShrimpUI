package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.utils.DisplayObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 *
	 * @author Sol
	 *
	 */
	public class AutoBitmap extends Bitmap
	{
		public function AutoBitmap()
		{

		}
		private var _width:Number = NaN;
		private var _height:Number = NaN;
		private var _smoothing:Boolean;
		private var _scale9Rect:Rectangle;
		private var useScale9Rect:Boolean;
		private var originBMD:BitmapData;

		/**	是否平滑*/
		override public function get smoothing():Boolean
		{
			return _smoothing;
		}

		override public function set smoothing(value:Boolean):void
		{
			super.smoothing = _smoothing = value;
		}

		public function get scale9Rect():Rectangle
		{
			return _scale9Rect;
		}

		public function set scale9Rect(value:Rectangle):void
		{
			_scale9Rect = value;
			useScale9Rect = value != null;
		}

		/**宽度(显示时四舍五入)*/
		override public function get width():Number
		{
			return isNaN(_width) ? super.width : _width;
		}

		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
			}
		}

		/**高度(显示时四舍五入)*/
		override public function get height():Number
		{
			return isNaN(_height) ? super.height : _height;
		}

		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
			}
		}

		public function validateSize():void
		{
			measure();
		}

		override public function set bitmapData(value:BitmapData):void
		{
			super.bitmapData = value;
			originBMD = value ? value.clone() : value;
		}

		protected function measure():void
		{
			updateDisplayList();
		}

		public function updateDisplayList(e:Event = null):void
		{
			if (bitmapData)
			{
				if (useScale9Rect)
				{
					var w:int = Math.round(width);
					var h:int = Math.round(height);
					super.bitmapData = DisplayObjectUtils.scale9Bmd(bitmapData, scale9Rect, w, h);
				}
				else
				{
					bitmapData = originBMD;
					super.width = width;
					super.height = height;
				}
				
				//修改自身宽高过后, 通知父容器 进行重新度量
				dispatchEvent(new Event(Event.RENDER));
			}
		}

		public function destory():void
		{
			super.bitmapData.dispose();
			originBMD.dispose();
			bitmapData = null;
		}
	}
}
