package com.shrimp.extensions.clip.event
{
	import flash.events.Event;
	
	/**
	 *clip 事件 
	 * @author yeah
	 */	
	public class ClipEvent extends Event
	{
		/**
		 *每一帧派发的事件 
		 */		
		public static const FRAME:String = "ClipEvent_Frame";
		
		/**
		 *播放结束 （repeat == 0）
		 */		
		public static const COMPLETE:String = "ClipEvent_Complete";
		
		/**
		 *完成一个循环（一个序列帧从头到尾）
		 */		
		public static const REPEAT:String = "ClipEvent_Repeat";
		
		
		public function ClipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}