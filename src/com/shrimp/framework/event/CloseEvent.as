package com.shrimp.framework.event
{
	import flash.events.Event;

	/**
	 *	关闭事件
	 * @author Sol
	 *
	 */
	public class CloseEvent extends Event
	{
		public static const CLOSE:String = "close";

		public function CloseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, detail:int = -1)
		{
			super(type, bubbles, cancelable);
			this.detail = detail;
		}
		public var detail:int;

		override public function clone():Event
		{
			return new CloseEvent(type, bubbles, cancelable, detail);
		}
	}
}
