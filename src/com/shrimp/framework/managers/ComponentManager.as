package com.shrimp.framework.managers
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.PriorityQueue;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 *	组件管理
	 * @author Sol
	 *
	 */
	public class ComponentManager
	{
		private static var _preInitComponentList:Dictionary = new Dictionary(true);
		private static var _validatePropertyQueue:PriorityQueue = new PriorityQueue();
		private static var _validateDisplayQueue:PriorityQueue = new PriorityQueue();
		private static var _validateSizeQueue:PriorityQueue = new PriorityQueue();

		private static var hadAttachListener:Boolean=false;

		public static function addPreInitComponent(target:Component):void
		{
			if (!(target in _preInitComponentList))
			{
				_preInitComponentList[target] = {propertiesReady:false, displayListReady:false, changeSize:false};
			}
		}

		public static function addPaddingDisplay(target:Component):void
		{
			_validateDisplayQueue.addElement(target);
			if(!hadAttachListener)
			{
				attachListener();
				hadAttachListener=true;
			}
		}

		public static function addPaddingProperty(target:Component):void
		{
			_validatePropertyQueue.addElement(target);
			if(!hadAttachListener)
			{
				attachListener();
				hadAttachListener=true;
			}
		}

		public static function addPaddingSize(target:Component):void
		{
			_validateSizeQueue.addElement(target);
			if(!hadAttachListener)
			{
				attachListener();
				hadAttachListener=true;
			}
		}

		public static function removePaddingDisplay(target:Component):void
		{
			if (target in _preInitComponentList)
			{
				_preInitComponentList[target]["displayListReady"] = true;
			}
		}

		public static function removePaddingProperty(target:Component):void
		{
			if (target in _preInitComponentList)
			{
				_preInitComponentList[target]["propertiesReady"] = true;
			}
		}

		public static function removePaddingSize(target:Component):void
		{
			if (target in _preInitComponentList)
			{
				_preInitComponentList[target]["changeSize"] = true;
			}
		}
		
		private static function attachListener():void
		{
			StageManager.stage.addEventListener(Event.RENDER,onRenderHandler);
			StageManager.stage.addEventListener(Event.ENTER_FRAME,onRenderHandler);
			StageManager.stage.invalidate();
		}
		
		/**
		 * 渲染的逻辑
		 * <p>首先将提交阶段的全部方法执行完毕 然后开始执行 测量 最后执行布局的逻辑</p>
		 */
		protected static function onRenderHandler(event:Event = null):void
		{
			StageManager.stage.removeEventListener(Event.RENDER,onRenderHandler);
			StageManager.stage.removeEventListener(Event.ENTER_FRAME,onRenderHandler);
			_validatePropertyQueue.sortElements();
			//从外面到内开始计算属性
			while(_validatePropertyQueue.length)
			{
				_validatePropertyQueue.minNestLevelElement.validateProperties();
			}
			
			_validateSizeQueue.sortElements();
			//从内到外度量尺寸
			while(_validateSizeQueue.length)
			{
				_validateSizeQueue.maxNestLevelElement.validateSize();
			}
			
			_validateDisplayQueue.sortElements();
			//从外到内摆放
			while(_validateDisplayQueue.length)
			{
				_validateDisplayQueue.minNestLevelElement.validateDisplayList(); 
			}
			
			var target:*;
			for (target in _preInitComponentList)
			{
				if (_preInitComponentList[target]["displayListReady"] && _preInitComponentList[target]["propertiesReady"] && _preInitComponentList[target]["changeSize"])
				{
					target.initialized = true;
					delete _preInitComponentList[target];
				}
			}
			hadAttachListener=false;
			
			counter++;
			trace(counter);
		}
		
		//帧计数器
		private static var counter:Number=0;
	}
}
