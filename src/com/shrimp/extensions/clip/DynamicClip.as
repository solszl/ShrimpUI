package com.shrimp.extensions.clip
{
	import com.shrimp.extensions.clip.core.clip_internal;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.core.interfaceClass.IDynamicClip;
	
	import flash.utils.getQualifiedClassName;
	
	use namespace clip_internal;
	
	/**
	 *可以动态增减帧的clip 
	 * @author yeah
	 */	
	public class DynamicClip extends Clip implements IDynamicClip
	{
		public function DynamicClip($source:IClipFrameDataList=null)
		{
			super($source);
		}
		
		public function addFrameAt($frameData:IClipFrameData, $index:int=-1):IClipFrameData
		{
			checkSource();
			IDynamicClip(source).addFrameAt($frameData, $index);
			updateWhenSourceChanged();
			return $frameData;
		}
		
		public function removeFrameAt($index:int):IClipFrameData
		{
			checkSource();
			var frameData:IClipFrameData = IDynamicClip(source).removeFrameAt($index);
			updateWhenSourceChanged();
			return frameData;
		}
		
		public function removeFrame($frameData:IClipFrameData):IClipFrameData
		{
			checkSource();
			var frameData:IClipFrameData = IDynamicClip(source).removeFrame($frameData);
			updateWhenSourceChanged();
			return frameData;
		}
		
		public function replaceFrameAt($frameData:IClipFrameData, $index:int):void
		{
			checkSource();
			IDynamicClip(source).replaceFrameAt($frameData, $index);
			updateWhenSourceChanged();
		}
		
		/**
		 *当source内容发生改变、更新当前帧 
		 */		
		private function updateWhenSourceChanged():void
		{
			_totalFrame = source.totalFrame;
			if(!frameData || frameLabel == frameData.frameLabel) return;
			
			var tempIndex:int = source.getFrameIndex(frameData.frameLabel);
			if(tempIndex != frameIndex)
			{
				setFrameIndex(tempIndex);
			}
		}
		
		
		/**
		 *检测 checkSource
		 */		
		private function checkSource():void
		{
			if(!source || !(source is IDynamicClip))
			{
				throw new Error("source必须是:" + getQualifiedClassName(IDynamicClip));
			}
			else
			{
				
			}
		}
	}
}