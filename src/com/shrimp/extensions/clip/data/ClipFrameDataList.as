package com.shrimp.extensions.clip.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import com.shrimp.extensions.clip.core.LazyDispatcher;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	
	public class ClipFrameDataList extends LazyDispatcher implements IClipFrameDataList
	{
		public function ClipFrameDataList($dispatcher:EventDispatcher = null)
		{
			super($dispatcher);
		}
		
		protected var _data:Vector.<IClipFrameData>;
		public function set data(value:Vector.<IClipFrameData>):void
		{
			if(_data == value) return;
			this._data = value;
			convertVector2Dic(this._data);
		}
		
		public function get data():Vector.<IClipFrameData>
		{
			return _data;
		}
		
		protected var _totalFrame:int;
		public function get totalFrame():int
		{
			return this._totalFrame;
		}
		
		public function refresh():void
		{
			convertVector2Dic(this._data);
			dispatchEvent(new ClipDataEvent(ClipDataEvent.FRAME_DATA_LIST_REFRESH));
		}
		
		protected var _convertedData:Dictionary;
		
//		public function get convertedData():Dictionary
//		{
//			return _convertedData;
//		}
		
		/**
		 *转化数据 
		 * @param $vector
		 */		
		private function convertVector2Dic($vector:Vector.<IClipFrameData>):void
		{
			if(!$vector) return;
			_convertedData = new Dictionary();
			_totalFrame = 0;
			
			for each(var frameData:IClipFrameData in $vector)
			{
				if(frameData.frameName == null)
				{
					frameData.frameName = _totalFrame;
				}
				
				_convertedData[frameData.frameName] = frameData;
				
				_totalFrame++;
			}
		}
		
		public function getFrameData($frameName:Object):IClipFrameData
		{
			if(_convertedData && $frameName in _convertedData)
			{
				return (_convertedData[$frameName] as IClipFrameData);
			}
			return null;
		}
		
		public function getFrameDataByIndex($index:int):IClipFrameData
		{
			return ((data && $index > -1 && $index < totalFrame)?data[$index] : null);	
		}
		
		public function hasFrameData($frameName:Object):Boolean
		{
			return (_convertedData && $frameName in _convertedData);
		}
		
		public function getFrameIndex($frameData:IClipFrameData):int
		{
			return (data?data.indexOf($frameData) : -1);
		}
		
		public function destroy():void
		{
			if(_data)
			{
				_data.length = 0;
				_data = null;
			}
			_convertedData = null;
			
			this._dispatcher = null;
		}
	}
}