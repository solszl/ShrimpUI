package com.shrimp.extensions.clip.render
{
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	import com.shrimp.extensions.clip.data.ClipFrameBitpmapData;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	public class ClipRenderer extends Bitmap implements IClipRenderer
	{
		public function ClipRenderer(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		private var _data:ClipFrameBitpmapData;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data($value:Object):void
		{
			if(_data == $value) return;
			
			
			if(_data)
			{
				if(_data.hasEventListener(ClipDataEvent.FRAME_DATA_IS_READY))
				{
					_data.removeEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				}
			}
			
			_data = $value as ClipFrameBitpmapData;
			
			updatePos();
			
			if(!_data)
			{
				this.bitmapData = null;
				return;
			}
			
			if(_data.bitmapData)
			{
				this.bitmapData = _data.bitmapData;
			}
			else
			{
//				this.bitmapData = null;				//需不需要提前置空旧的bmd
				_data.addEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
			}
		}
		
		public function get self():DisplayObject
		{
			return this;
		}
		
		/**
		 *外部设置的x 
		 */		
		private var explicit_x:Number = 0;
		
		/**
		 *外部设置的y
		 */		
		private var explicit_y:Number = 0;
		
		public function move($x:Number, $y:Number):void
		{
			explicit_x = $x;
			explicit_y = $y;
			updatePos();
		}
		
		/**
		 *更新位置 
		 */		
		private function updatePos():void
		{
			if(_data && _data.offset)
			{
				this.x = explicit_x + _data.offset.x;
				this.y = explicit_y + _data.offset.y;
			}
			else
			{
				this.x = explicit_x;
				this.y = explicit_y;
			}
		}
		
		public function destroy():void
		{
			if(_data)
			{
				if(_data.hasEventListener(ClipDataEvent.FRAME_DATA_IS_READY))
				{
					_data.removeEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				}
				_data.destroy(true);
			}
			
			this.bitmapData = null;
		}
		
		/**
		 * frameDataIsReady
		 * @param event
		 */		
		private function frameDataIsReady($e:ClipDataEvent):void
		{
			var frameData:ClipFrameBitpmapData = $e.data as ClipFrameBitpmapData;
			if(frameData)
			{
				frameData.removeEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				this.bitmapData = frameData.bitmapData;
			}
			else
			{
				this.bitmapData = null;
			}
		}
	}
}