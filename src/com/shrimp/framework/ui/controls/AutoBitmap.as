package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.utils.DisplayObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
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
		private var _width:Number;
		private var _height:Number;
		private var _smoothing:Boolean;
		private var _scale9Rect:Rectangle;
		private var useScale9Rect:Boolean;
		
		/**	是否平滑*/
		override public function get smoothing():Boolean
		{
			return _smoothing;
		}

		override public function set smoothing(value:Boolean):void
		{
			super.smoothing=_smoothing=value;
		}

		public function get scale9Rect():Rectangle
		{
			return _scale9Rect;
		}

		public function set scale9Rect(value:Rectangle):void
		{
			_scale9Rect=value;
			useScale9Rect=value != null;
			validateSize();
		}

		/**宽度(显示时四舍五入)*/
		override public function get width():Number
		{
			return isNaN(_width) ? (super.bitmapData ? super.bitmapData.width : super.width) : _width;
		}

		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width=value;
				validateSize();
			}
		}

		/**高度(显示时四舍五入)*/
		override public function get height():Number
		{
			return isNaN(_height) ? (super.bitmapData ? super.bitmapData.height : super.height) : _height;
		}

		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height=value;
				validateSize();
			}
		}

		public function validateSize():void
		{	
			measure();
		}
		
		protected function measure():void
		{
			addEventListener(Event.ENTER_FRAME,updateDisplayList);
//			updateDisplayList();
		}

		public function updateDisplayList(e:Event=null):void
		{
			removeEventListener(Event.ENTER_FRAME,updateDisplayList);
			if (bitmapData)
			{
				if (useScale9Rect)
				{
					var w:int=Math.round(width);
					var h:int=Math.round(height);
					bitmapData = DisplayObjectUtils.scale9Bmd(bitmapData,scale9Rect,w,h);
					super.width = w;
					super.height = h;
				}
			}
		}


	}
}
