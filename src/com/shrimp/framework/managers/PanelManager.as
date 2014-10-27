package com.shrimp.framework.managers
{
	import com.shrimp.framework.GlobalConfig;
	import com.shrimp.framework.interfaces.IPanel;
	import com.shrimp.framework.interfaces.IScheduler;
	import com.shrimp.framework.ui.controls.Alert;
	import com.shrimp.framework.ui.controls.panel.Panel;
	import com.shrimp.framework.utils.ClassUtils;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	 *	面板管理类 
	 * @author Sol
	 * 
	 */	
	public class PanelManager implements IScheduler
	{
		private static var _instance:PanelManager;
		
		private static var panelMap:Dictionary = new Dictionary();
		
		private static var openMap:Dictionary = new Dictionary();
		
		public static function getInstance():PanelManager
		{
			if(!_instance)
				_instance = new PanelManager();
			
			return _instance;
		}
		
		public function PanelManager()
		{
			if(_instance)
				throw new Error("PanelManager had already constructed");
			
			_instance = this;
		}
		
		/**
		 * 打开某个面板
		 * @param clazz	面板类
		 * @param useModal	是否使用模态
		 * @param loadRemoteRes 是否加载远程资源
		 * @param arg	打开参数
		 * 
		 */		
		public function showPanel(panelId:int,useModal:Boolean,loadRemoteRes:Boolean=true,...arg):void
		{
			if(panelId == -1)
			{
				Alert.show("面板ID 不允许为负数,请检查,panelId:"+panelId);
				return;
			}
			
			//遍历打开列表.如果面板不是独立于其他的,则关闭,打开指定面板
			for each(var openPanel:* in openMap)
			{
				var p:IPanel =openPanel as IPanel;
//				if(panelMap[ClassUtils.getClassName(clazz)].panel is p)
//					return;
				
				if(p.standAlone==false)
				{
					closePanel(panelId);
				}
			}
			
			var panel:IPanel = getPanel(panelId);
			panel.modal = useModal;
			panel.show(arg);
			openMap[panelId]=panel;
		}
		
		/**	开门某个面板*/
		public function togglePanel(panelId:int,useModal:Boolean):void
		{
			if(isOpen(panelId))
			{
				closePanel(panelId);
			}
			else
			{
				showPanel(panelId,useModal);
			}
		}
		
		/**	关闭某个面板*/
		public function closePanel(panelId:int):void
		{
			if(panelId in openMap)
			{
				var panel:IPanel = getPanel(panelId);
				panel.hide();
				panel.clean();
				delete openMap[panelId];
			}
		}
		
		/**	关闭所有面板*/
		public function closeAllPanel():void
		{
			for each(var key:* in openMap)
			{
				(openMap[key] as IPanel).hide();
				(openMap[key] as IPanel).clean();
				delete openMap[key];
			}
		}
		
		/**	判断某个面板是否处在打开状态*/
		public function isOpen(panelId:int):Boolean
		{
			
			return panelId in openMap; 
		}
		
		/**	实现IScheduler接口的run函数 */		
		public function run(stamp:Number):void
		{
			for each(var obj:Object in panelMap)
			{
				if(obj.panel.isOpen())
				{
					continue;
				}
				
				if (stamp - obj.time >= GlobalConfig.PANEL_PERSISTENCE_MEMORY)
				{
					(obj.panel as IPanel).dispose();
					delete panelMap[obj.key];
				}
			}
		}
		
		public function getPanel(panelId:int):IPanel
		{
			var panel:IPanel;
			if(panelMap[panelId]==null)
			{
				throw new Error("no such panelId,",panelId);
			}
			
			var obj:Object = panelMap[panelId];
			
			if(obj.panel is Class)
			{
				panel = new (obj.panel);
			}
			else if(obj.panel is IPanel)
			{
				panel = obj.panel;
			}
			
			panelMap[panelId]={panel:panel,time:getTimer(),key:panelId};
			
			return panel;
		}
		
		public static function registPanel(id:int,panel:*):void
		{
			var obj:Object = new Object();
			obj.panel = panel;
			obj.time = getTimer();
			obj.key = id;
			panelMap[id] = obj;
		}
		
	}
}