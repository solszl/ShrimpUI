package com.shrimp.framework.managers
{
	import com.shrimp.framework.log.Logger;
	
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;

	/**
	 *	舞台管理类 
	 * @author Sol
	 * 
	 */	
	public class StageManager extends EventDispatcher
	{
		[Bindable]
		public static var stage:Stage;
		/**
		 * 整个游戏显示层次的根节点
		 */
		public static var root:Sprite;
		
		public static function init(root:Sprite):void
		{
			StageManager.root = root;
			StageManager.root.blendMode=BlendMode.LAYER;
			StageManager.root.tabChildren = false;
			StageManager.stage=root.stage;
			StageManager.stage.frameRate = 30;
			StageManager.stage.scaleMode=StageScaleMode.NO_SCALE;
			StageManager.stage.align = StageAlign.TOP_LEFT;
			StageManager.stage.quality="low";
			StageManager.stage.addEventListener(Event.RESIZE,onStageResize);
			if(ApplicationDomain.currentDomain.hasDefinition("flash.evnets.UncaughtErrorEvent"))
			{
				StageManager.stage.loaderInfo["uncaughtErrorEvents"].addEventListener(ApplicationDomain.currentDomain.hasDefinition("flash.evnets.UncaughtErrorEvent")["UNCAUGHT_ERROR"], onUncaughtErrorHandler);
			}
		}
		
		protected static function onStageResize(event:Event=null):void
		{
			LayerManager.resize();
		}
		
		public static function getStageWidth():Number
		{
			if(stage)
				return stage.stageWidth;
			
			return 0;
		}
		
		public static function getStageHeight():Number
		{
			if(stage)
				return stage.stageHeight;
			
			return 0;
		}
		
		private static function onUncaughtErrorHandler(event:*):void
		{
			var msg:String=event.error.getStackTrace();
			if (!msg)
			{
				if (event.error is Error)
				{
					msg=Error(event.error).message;
				}
				else if (event.error is ErrorEvent)
				{
					msg=ErrorEvent(event.error).text;
				}
				else
				{
					msg=event.error.toString();
				}
			}
			var content:String="【Error】:\n It's probably a bug, please contact Sol::<a herf ='mailto:solszl@163.com'</a>" + msg;
			Logger.getLogger().debug(content);
		}
	}
}