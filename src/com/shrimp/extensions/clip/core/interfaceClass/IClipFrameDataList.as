package com.shrimp.extensions.clip.core.interfaceClass
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * IClip数据源接口
	 * @author yeah
	 */	
	public interface IClipFrameDataList extends IEventDispatcher
	{
		/**
		 *帧总数 
		 */		
		function get totalFrame():int;
		
		/**数据源 外部如果对Vector数据进行操作后请执行refresh()*/
		function set data(value:Vector.<IClipFrameData>):void;
		
		/**
		 *获取IClipFrameData 
		 * @param $index 帧索引
		 * @return 
		 */		
		function getFrameData($index:int):IClipFrameData;
		
		/**
		 *某帧的索引（如果不存在则返回-1）
		 * @param $frame 帧标签(String) 或者帧数据(IClipFrameData)
		 * @return 
		 */		
		function getFrameIndex($frame:Object):int;
		
		/**
		 *是否存在某帧 
		 * @param $frame 帧标签(String) 或者 帧索引(int) 或者 帧数据(IClipFrameData)
		 * @return 
		 */		
		function hasFrameData($frame:Object):Boolean;
		
		/**刷新会重新convertedData()并且派发ClipDataEvent.FRAME_DATA_LIST_REFRESH事件*/
		function refresh():void;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
	}
}