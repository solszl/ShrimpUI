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
		 *新增ClipFrameData数据
		 * @param $additionList		
		 *		一个被删除的ClipFrameData列表 
		 * 		如果之前存在$frameData.frameName对应的数据，覆盖之
		 * 
		 * 派发：ClipDataEvent.FRAME_DATA_LIS_ADDED
		 * @return 新增的ClipFrameData列表
		 */		
		function addFrameDatas($additionList:Vector.<IClipFrameData>):Vector.<IClipFrameData>;
		
		/**
		 *根据被删除的frameName列表删除ClipFrameData
		 * @param $deductionList		Vector集合存储的是被删除的ClipFrameData的frameName
		 * 派发：ClipDataEvent.FRAME_DATA_LIST_REMOVED
		 * @return 
		 */		
		function removeFrameDatas($deductionList:Vector.<IClipFrameData>):Vector.<IClipFrameData>;
	}
}