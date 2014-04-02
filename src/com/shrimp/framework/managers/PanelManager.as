package com.shrimp.framework.managers
{
	import com.shrimp.framework.GlobalConfig;
	import com.shrimp.framework.interfaces.IPanel;
	import com.shrimp.framework.interfaces.IScheduler;
	import com.shrimp.framework.utils.ClassUtils;
	
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
		public function showPanel(clazz:Class,useModal:Boolean,loadRemoteRes:Boolean=true,...arg):void
		{
			//遍历打开列表.如果面板不是独立于其他的,则关闭,打开指定面板
			for each(var openPanel:* in openMap)
			{
				var p:IPanel =openPanel as IPanel;
//				if(panelMap[ClassUtils.getClassName(clazz)].panel is p)
//					return;
				
				if(p.standAlone==false)
				{
					closePanel(ClassUtils.getClass(getQualifiedClassName(p)));
				}
			}
			
			var panel:IPanel = getPanel(clazz);
			panel.modal = useModal;
			panel.show(arg);
			var key:String = ClassUtils.getClassName(clazz);
			openMap[key]=panel;
		}
		
		/**	开门某个面板*/
		public function togglePanel(clazz:Class,useModal:Boolean):void
		{
			if(isOpen(clazz))
			{
				closePanel(clazz);
			}
			else
			{
				showPanel(clazz,useModal);
			}
		}
		
		/**	关闭某个面板*/
		public function closePanel(clazz:Class):void
		{
			var key:String = ClassUtils.getClassName(clazz);
			if(key in openMap)
			{
				var panel:IPanel = getPanel(clazz);
				panel.hide();
				panel.clean();
				delete openMap[key];
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
		public function isOpen(clazz:Class):Boolean
		{
			
			return ClassUtils.getClassName(clazz) in openMap; 
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
		
		public function getPanel(clazz:Class):IPanel
		{
			var panel:IPanel;
			var key:String = ClassUtils.getClassName(clazz);
			if(panelMap[key])
			{
				panel = (panelMap[key]).panel as IPanel;
			}
			else
			{
				panel = new clazz();
			}
			
			panelMap[key]={panel:panel,time:getTimer(),key:key};
			
			return panel;
		}
		
	}
}