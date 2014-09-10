package com.shrimp.extensions.clip.event
{
	import flash.events.Event;
	
	/**
	 *clip event 
	 * @author yeah
	 */	
	public class ClipDataEvent extends Event
	{
		
		
		//====================const=======================
		
		/**
		 *ClipFrameData已经准备完成 
		 * data格式ClipFrameData
		 */		
		public static const FRAME_DATA_IS_READY:String = "frame_data_is_ready";
		
		/**
		 *IClipFrameDataList添加一帧数据 如果之前存在frameName对应的数据，覆盖之
		 * data格式:Vector.<Object> 
		 * Object格式：{oldData:oldData, newData:$frameData}
		 * oldData被覆盖的旧数据，如果不是覆盖的则=null； newData新数据
		 */		
		public static const FRAME_DATA_LIS_ADDED:String = "frame_data_lis_added";
		
		/**
		 *IClipFrameDataList删除一帧数据
		 * data格式:Vector.<ClipFrameData>  --- 被删除的ClipFrameData列表
		 */		
		public static const FRAME_DATA_LIST_REMOVED:String = "frame_data_list_removed";
		
		/**
		 *IClipFrameDataList 外部操作数据后刷新
		 */		
		public static const FRAME_DATA_LIST_REFRESH:String = "frame_data_list_refresh";
		
		//============================================
		/**
		 * event 附带的数据
		 */		
		public var data:Object;
		
		public function ClipDataEvent(type:String, $data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = $data;
		}
	}
}