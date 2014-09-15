package com.shrimp.extensions.clip.data
{
	
	import com.shrimp.extensions.clip.core.LazyDispatcher;
	import com.shrimp.extensions.clip.core.clip_internal;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	use namespace clip_internal;
	
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
		clip_internal var frameLabelDic:Dictionary;
		
		clip_internal var _totalFrame:int;
		public function get totalFrame():int
		{
			return this._totalFrame;
		}
		
		clip_internal var _data:Vector.<IClipFrameData>;
		public function set data(value:Vector.<IClipFrameData>):void
		{
			if(_data == value) return;
			this._data = value;
			setData(_data);
		}
		
		/**
		 *设置数据 
		 * @param $data
		 * @return 
		 */		
		protected function setData($data:Vector.<IClipFrameData>):void
		{
			if(!$data)
			{
				_totalFrame = 0;
				return;
			}
			
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
		
		public function getFrameData($index:int):IClipFrameData
		{
			if(hasFrameData($index))
			{
				return _data[$index];
			}
			
			return null;
		}
		
		public function getFrameIndex($frame:Object):int
		{
			if(totalFrame < 1 || $frame == null) return -1;
			
			var index:int = -1;
			
			if($frame is IClipFrameData)
			{
				index = _data.indexOf(IClipFrameData($frame));
			}
			else if($frame is String && $frame in frameLabelDic)
			{
				index = frameLabelDic[index];
			}
			
			return index;
		}
		
		public function hasFrameData($frame:Object):Boolean
		{
			var index:int = -1;
			if($frame is int)
			{
				index = int($frame);
				return (index > -1 && index < totalFrame);
			}
			
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