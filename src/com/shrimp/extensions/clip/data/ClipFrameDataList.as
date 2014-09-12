package com.shrimp.extensions.clip.data
{
	import com.shrimp.extensions.clip.core.LazyDispatcher;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class ClipFrameDataList extends LazyDispatcher implements IClipFrameDataList
	{
		public function ClipFrameDataList($dispatcher:EventDispatcher = null)
		{
			super($dispatcher);
		}
		
		/**
		 *帧标签字典
		 * 格式：frameLabelDic [标签] = 索引
		 */		
		private var frameLabelDic:Dictionary;
		
		protected var _totalFrame:int;
		public function get totalFrame():int
		{
			return this._totalFrame;
		}
		
		private var _data:Vector.<IClipFrameData>;
		public function set data(value:Vector.<IClipFrameData>):void
		{
			if(_data == value) return;
			this._data = value;
			_totalFrame = 0;
			setData(_data);
		}
		
		/**
		 *获取data数据 
		 * @return 
		 */		
		protected function getData():Vector.<IClipFrameData>
		{
			if(!_data)
			{
				_data = new Vector.<IClipFrameData>();
			}
			return _data;
		}
		
		/**
		 *设置数据 
		 * @param $data
		 * @return 
		 */		
		private function setData($data:Vector.<IClipFrameData>):void
		{
			if(!$data) return;
			
			_totalFrame = $data.length;
			frameLabelDic = new Dictionary();
			
			var frameData:IClipFrameData;
			for(var i:int = 0; i < _totalFrame; i++)
			{
				frameData = $data[i];
				if(!frameData.frameLabel)				
				{
					frameData.frameLabel = i + "";
				}
				
				frameLabelDic[frameData.frameLabel] = i;
			}
		}
		
		public function getFrameData($frame:Object):IClipFrameData
		{
			var index:int = getFrameIndex($frame);
			return (index > -1 ? _data[index] : null);
		}
		
		public function getFrameIndex($frame:Object):int
		{
			if(totalFrame < 1 || !$frame) return -1;
			
			var index:int = -1;
			if($frame is int)
			{
				index = int($frame);
				if(index < 0 || index >= totalFrame)
				{
					index = -1;
				}
			}
			else if($frame is String)
			{
				if($frame in frameLabelDic)
				{
					index = frameLabelDic[index];
				}
			}
			else if($frame is IClipFrameData)
			{
				index = _data.indexOf(IClipFrameData($frame));
			}
			
			return index;
		}
		
		public function hasFrameData($frame:Object):Boolean
		{
			return (getFrameIndex($frame) != -1);
		}
		
		public function refresh():void
		{
			setData(_data);
			dispatchEvent(new ClipDataEvent(ClipDataEvent.FRAME_DATA_LIST_REFRESH));
		}
		
		public function destroy():void
		{
			if(_data)
			{
				_data.length = 0;
				_data = null;
			}
			
			frameLabelDic = null;
			
			this._dispatcher = null;
		}
	}
}