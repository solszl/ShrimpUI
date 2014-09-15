package com.shrimp.extensions.clip.data
{
	import com.shrimp.extensions.clip.core.clip_internal;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IDynamicClip;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	
	import flash.events.EventDispatcher;
	
	use namespace clip_internal;
	
	
	public class ClipDynamicDataList extends ClipFrameDataList implements IDynamicClip
	{
		public function ClipDynamicDataList($dispatcher:EventDispatcher=null)
		{
			super($dispatcher);
		}
		
		public function addFrameAt($frameData:IClipFrameData, $index:int=-1):IClipFrameData
		{
			var dataSource:Vector.<IClipFrameData> = _data;
			
			if($index == -1)
			{
				$index = totalFrame;
			}
			
			if(!dataSource)
			{
				dataSource = new Vector.<IClipFrameData>();
				dataSource[$index] = $frameData;
				data = dataSource;
				return $frameData;
			}
				
			var index:int = getFrameIndex($frameData);
			
			if(index == $index) return $frameData;
			
			if(index == -1)
			{
				index = $index;
			}
			else if(index != $index)
			{
				dataSource.splice(index, 1);
				index = Math.min($index, totalFrame -1);
			}
			
			dataSource.splice(index, 0, $frameData);
			refresh();
			return $frameData;
		}
		
		public function removeFrameAt($index:int):IClipFrameData
		{
			if(totalFrame <= $index)
			{
				throw new Error("$index:"+$index+"超出范围:" + totalFrame);
			}
			
			var frameData:IClipFrameData = getFrameData($index);
			_data.splice($index, 1);
			refresh();
			return frameData;
		}
		
		public function removeFrame($frameData:IClipFrameData):IClipFrameData
		{
			if(totalFrame < 1) 
			{
				throw new Error("数据源中不存在" +$frameData);
			}
			
			var index:int = getFrameIndex($frameData);
			
			if(index == -1) 
			{
				throw new Error("数据源中不存在" +$frameData);
			}
			
			_data.splice(index, 1);
			refresh();
			return $frameData;
		}
		
		public function replaceFrameAt($frameData:IClipFrameData, $index:int):void
		{
			if(totalFrame - 1 < $index || $index < 0) 
			{
				throw new Error("$index:"+$index+"超出范围:0~" + totalFrame);
			}
			
			var index:int = getFrameIndex($frameData);
			
			if(index == -1)
			{
				_data.splice($index, 1, $frameData);
			}
			else if($index != index)
			{
				var oldData:IClipFrameData = getFrameData($index);
				_data[$index] = $frameData;
				_data[index] = oldData;
			}
			else
			{
				return;
			}
			
			refresh();
		}
		
		
		/**
		 *派发事件 
		 * @param $type
		 * @param $data
		 */		
		private function onDispather($type:String, $data:Object = null):void
		{
			
		}
	}
}