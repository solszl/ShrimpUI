package com.shrimp.extensions.clip.data
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IDynamicClip;
	import com.shrimp.extensions.clip.event.ClipDataEvent;
	
	public class ClipDynamicDataList extends ClipFrameDataList implements IDynamicClip
	{
		public function ClipDynamicDataList($dispatcher:EventDispatcher=null)
		{
			super($dispatcher);
		}
		
		public function addFrameDatas($additionList:Vector.<IClipFrameData>):Vector.<IClipFrameData>
		{
			if(!$additionList) return null;
			
			if(totalFrame < 1) return null;
			
			
//			var addtionInfo:Vector.<Object> = new Vector.<Object>();
//			for each(var frameData:IClipFrameData in $additionList)
//			{
//				var addtionOBJ:Object = addSingleData(frameData);
//				if(!addtionOBJ) continue;
//				addtionInfo.push(addtionOBJ);
//			}
//			
//			if(addtionInfo.length > 0)
//			{
//				dispatchEvent(new ClipDataEvent(ClipDataEvent.FRAME_DATA_LIS_ADDED, addtionInfo));
//			}
//			
//			_totalFrame = _data.length;
			
			return $additionList;
		}
		
//		/**
//		 *新增一个data 
//		 * @param $frameData
//		 * @return {oldData:oldData, newData:$frameData}
//		 */		
//		private function addSingleData($frameData:IClipFrameData):Object
//		{
//			if(!$frameData) return null;
//			
//			var oldData:IClipFrameData;
//			if(hasFrameData($frameData.frameName))
//			{
//				oldData = getFrameData($frameData.frameName);
//				var index:int = getFrameIndex(oldData);
//				if(index != -1)
//				{
//					_data.splice(index, 1, $frameData);
//				}
//			}
//			else
//			{
//				if(isNaN(Number($frameData.frameName)))
//				{
//					_data.push($frameData);
//				}
//				else
//				{
//					var frameIndex:int = Math.min(int($frameData.frameName), _data.length);
//					$frameData.frameName = frameIndex;
//					_data.splice(frameIndex, 0 ,$frameData);
//				}
//			}
//			
//			_convertedData[$frameData.frameName] = $frameData;
//			
////			此处是派发销毁事件还是直接destroy，待定
////			if(oldData)
////			{
////				oldData.destroy();
////			}
//			
//			return {oldData:oldData, newData:$frameData};
//		}
		
		
		public function removeFrameDatas($deductionList:Vector.<IClipFrameData>):Vector.<IClipFrameData>
		{
//			if(!_convertedData) return null;
//			
//			var deductionInfo:Vector.<IClipFrameData> = new Vector.<IClipFrameData>();
//			
//			for each(var frameName:Object in $deductionList)
//			{
//				var deductionData:IClipFrameData = removeSingleData(frameName);
//				if(!deductionData) continue;
//				deductionInfo.push(deductionData);
//			}
//			
//			if(deductionInfo)
//			{
//				dispatchEvent(new ClipDataEvent(ClipDataEvent.FRAME_DATA_LIST_REMOVED, deductionInfo));
//			}
//			
//			_totalFrame = _data ? _data.length : 0;
//			
//			return deductionInfo;
			
			return null;
		}
		
//		/**
//		 *删除单个 ClipFrameData
//		 * @param $frameName
//		 * @return 
//		 */		
//		private function removeSingleData($frameName:Object):IClipFrameData
//		{
//			var frameData:IClipFrameData;
//			if($frameName in _convertedData)
//			{
//				frameData = _convertedData[$frameName];
//				delete _convertedData[$frameName];
//			}
//			
//			if(frameData)
//			{
//				var index:int = _data.indexOf(frameData);
//				if(index != -1)
//				{
//					_data.splice(index, 1);
//				}
//			}
//			
////			此处是否销毁被删除的对象
////			if(frameData)
////			{
////				frameData.destroy();
////			}
//			
//			return frameData;
//		}
	}
}