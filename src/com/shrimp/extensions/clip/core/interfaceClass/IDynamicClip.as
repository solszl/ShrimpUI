package com.shrimp.extensions.clip.core.interfaceClass
{
	import flash.events.IEventDispatcher;
	
	/**
	 *可动态改变Frame的Clip接口
	 * @author yeah
	 */	
	public interface IDynamicClip extends IEventDispatcher
	{
		
		/**
		 *新增帧
		 * @param $frameData			新增的帧数据
		 * @param $index					添加到的索引位置 	-1添加到末尾
		 */		
		function addFrameAt($frameData:IClipFrameData, $index:int = -1):IClipFrameData;
		
		/**
		 *移除帧 
		 * @param $index				将要移除的帧索引
		 * @return 
		 */		
		function removeFrameAt($index:int):IClipFrameData;
		
		/**
		 *移除帧 
		 * @param $frameData		将要移除的帧数据
		 * @return 
		 */		
		function removeFrame($frameData:IClipFrameData):IClipFrameData;
		
		/**
		 *替换指定位置的帧 
		 * @param $frameData		替换后的帧数据（如果本来就存在于数据源中则与$index索引的数据互换位置）
		 * @param $index				索引位置
		 */		
		function replaceFrameAt($frameData:IClipFrameData, $index:int):void;
	}
}