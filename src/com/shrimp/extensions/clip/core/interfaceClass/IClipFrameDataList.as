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
		/**数据源 外部如果对Vector数据进行操作后请执行refresh()*/
//		function get data():Vector.<IClipFrameData>;
		function set data(value:Vector.<IClipFrameData>):void;
		
		/**
		 *帧总数 
		 */		
		function get totalFrame():int;
		
		/**获取数据转换后的字典：格式_convertedData[frameName]=IClipFrameData)*/
//		function get convertedData():Dictionary;
		
		/**
		 *获取指定名称的IClipFrameData 
		 * @param $frameName
		 * @return 
		 */		
		function getFrameData($frameName:Object):IClipFrameData;
		
		/**
		 *获取指定索引的 IClipFrameData
		 * @param $index
		 * @return 
		 */		
		function getFrameDataByIndex($index:int):IClipFrameData;
		
		/**
		 *是否存在某帧 
		 * @param $frameName
		 * @return 
		 */		
		function hasFrameData($frameName:Object):Boolean;
		
		/**
		 *获取某帧的指定索引 
		 * @param $frameData
		 * @return 
		 */		
		function getFrameIndex($frameData:IClipFrameData):int;
		
		/**刷新会重新convertedData()并且派发ClipDataEvent.FRAME_DATA_LIST_REFRESH事件*/
		function refresh():void;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
	}
}