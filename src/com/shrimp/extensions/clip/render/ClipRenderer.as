package com.shrimp.extensions.clip.render
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import com.shrimp.extensions.clip.data.ClipFrameBitpmapData;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	
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
			
			if(_data)
			{
				if(_data.bitmapData)
				{
					this.bitmapData = _data.bitmapData;
				}
				else
				{
//					this.bitmapData = null;
					_data.addEventListener(ClipDataEvent.FRAME_DATA_IS_READY, frameDataIsReady);
				}
			}
			else
			{
				this.bitmapData = null;
			}
		}
		
		public function get self():DisplayObject
		{
			return this;
		}
		
		public function move($x:Number, $y:Number):void
		{
			this.x = $x;
			this.y = $y;
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