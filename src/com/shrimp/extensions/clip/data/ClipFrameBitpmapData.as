package com.shrimp.extensions.clip.data
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	import com.shrimp.extensions.clip.core.LazyDispatcher;
	
	/**
	 *clip 帧数据 
	 * 支持派发事件（数据动态改变时可用）
	 * 如果创建之初BitmapData处于异步加载状态则可以监听ClipDataEvent.FRAME_DATA_IS_READY事件刷新
	 * @author yeah
	 */	
	public class ClipFrameBitpmapData extends ClipFrameData
	{
		public function ClipFrameBitpmapData($bitmapData:BitmapData = null, $offset:Point = null, $useClone:Boolean = false, $dispatcher:EventDispatcher = null)
		{
			super($dispatcher);
			this.offset = $offset;
			setBitmapData($bitmapData, $useClone);
		}
		
		/**是否使用BitmapData的clone*/
		private var useClone:Boolean = false;
		
		/**
		 *设置 BitmapData 数据
		 * @param $bitmapData	BitmapData		$bitmapData不为空且外部监听了ClipDataEvent.FRAME_DATA_IS_READY事件则派发
		 * @param $useClone		是否使用BitmapData的clone
		 * @return 
		 */		
		public function setBitmapData($bitmapData:BitmapData, $useClone:Boolean = false, $destroyOldDispather:Boolean = false):void
		{
			destroy($destroyOldDispather);
			
			if(_bitmapData == $bitmapData || !$bitmapData) return;
			
			this.useClone = $useClone;
			_bitmapData = !useClone ? $bitmapData : $bitmapData.clone();
			
			dispatchEvent(new ClipDataEvent(ClipDataEvent.FRAME_DATA_IS_READY, this));
		}
		
		private var _bitmapData:BitmapData;

		/**
		 * bitmapData
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		
		override public function destroy($cleanDispather:Boolean):void
		{
			if(!_bitmapData) return;
			
			if(useClone)
			{
				_bitmapData.dispose();
			}
			
			_bitmapData = null;
			
			if($cleanDispather)
			{
				this._dispatcher = null;
			}
		}
	}
}