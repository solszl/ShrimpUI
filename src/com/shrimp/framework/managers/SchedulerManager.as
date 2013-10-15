package com.shrimp.framework.managers
{
	import com.shrimp.framework.interfaces.IScheduler;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 *	调度管理 
	 * 把所有的Manager都添加到SchedulerManager里。通过内部enterFrame事件不停的去刷调度表里的manager
	 * 每个manager通过实现IScheduler的run方法执行相应的操作。
	 * 该类不宜进行复杂业务操作。尽可能执行简单操作，如：同步等
	 * @simple 
	 * 1、SchedulerManager.init();
	 * 2、Class SynManager implments IScheduler
	 * 3、SchedulerManager.schedulerList.push(new SynManager());
	 * @author Sol
	 * 
	 */	
	public class SchedulerManager
	{
		private static var sp:Shape = new Shape();
		private static var isRunning:Boolean = false;
		
		public static var schedulerList:Array=[];
		
		public function SchedulerManager()
		{
		}
		
		/**
		 *	初始化调度器 
		 */		
		public static function init():void
		{
			if(isRunning)
				return;
			isRunning=true;
			sp.addEventListener(Event.ENTER_FRAME,onHeart);
		}
		
		protected static function onHeart(event:Event):void
		{
			if(!schedulerList || schedulerList.length==0)
				return;
			
			for each(var scheduler:IScheduler in schedulerList)
			{
				scheduler.run(getTimer());
			}
		}
	}
}