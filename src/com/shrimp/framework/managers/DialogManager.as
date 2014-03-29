package com.shrimp.framework.managers
{
	import com.shrimp.framework.GlobalConfig;
	import com.shrimp.framework.interfaces.IDialog;
	import com.shrimp.framework.interfaces.IScheduler;

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getTimer;

	/**
	 * 弹窗管理类
	 * 实现IScheduler 来控制对象在内存存放时间
	 * @author Sol
	 *
	 */
	public class DialogManager implements IScheduler
	{
		private static var _instance:DialogManager;

		private static var _clazzMap:Dictionary=new Dictionary(true);

		public function DialogManager()
		{
			if (_instance)
				throw new Error("DialogManager had already constructed!");

			_instance=this;
		}

		public static function getInstance():DialogManager
		{
			if (!_instance)
				_instance=new DialogManager();

			return _instance;
		}

		/**	遍历缓存的Dialog 面板.判断时间戳来进行删除 弹框*/
		public function run(stamp:Number):void
		{
			for each (var obj:Object in _clazzMap)
			{
				if ((obj.dialog as IDialog).isOpen())
					continue;

				if (stamp - obj.time >= GlobalConfig.DIALOG_PERSISTENCE_MEMORY)
				{
					trace("wtf");
					(obj.dialog as IDialog).dispose();
					delete _clazzMap[obj.key];
				}
			}
		}

		/**
		 *	弹框显示 
		 * @param clazz	弹框类
		 * @param useModal	是否使用模态
		 * @param arg	参数
		 * 
		 */		
		public function show(clazz:Class, useModal:Boolean, ... arg):void
		{
			var dialog:IDialog;
			var keyName:String=getQualifiedSuperclassName(clazz);
			if (_clazzMap[keyName])
			{
				dialog=(_clazzMap[keyName]).dialog as IDialog;
			}
			else
			{
				dialog=new clazz();
			}
			_clazzMap[keyName]={dialog: dialog, time: getTimer(),key:keyName};

			dialog.modal=useModal;
			dialog.show(arg);
		}

		/**
		 *	关闭弹框 
		 * @param clazz	弹框类
		 * 
		 */		
		public function hide(clazz:Class):void
		{
			var keyName:String=getQualifiedSuperclassName(clazz);
			var dialog:IDialog=(_clazzMap[keyName]).dialog as IDialog;
			
			_clazzMap[keyName]={dialog: dialog, time: getTimer(),key:keyName};
			
			dialog.clean();
//			dialog.hide();
		}
	}
}
