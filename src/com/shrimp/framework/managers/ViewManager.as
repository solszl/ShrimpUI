package com.shrimp.framework.managers
{
	import com.shrimp.framework.interfaces.IView;
	import com.shrimp.framework.log.Logger;
	
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.messaging.AbstractConsumer;

	/**
	 *	场景管理器
	 * @author Sol
	 *
	 */
	public class ViewManager extends EventDispatcher
	{
		private static var _instance:ViewManager;

		private static var viewMap:Dictionary;

		/**	当前场景枚举值*/
		private var _currentViewId:int;

		/**	当前场景,可能是个class 也可能是个displayObject*/
		private var _currentView:IView;

		/**	前置场景  @default -1*/
		private var _preViewId:int=-1;

		public static function getInstance():ViewManager
		{
			if (!_instance)
			{
				_instance=new ViewManager();
			}

			return _instance;
		}

		public function ViewManager()
		{
			super();

			if(_instance)
			{
				throw new Error("viewManager is singleton");
			}
			
			if (!_instance)
			{
				_instance=this;
			}

			init();
		}

		private function init():void
		{
			viewMap=new Dictionary();
		}

		/**	是否存在某个视图*/
		public function hasView(viewId:int):Boolean
		{
			return viewId in viewMap;
		}

		/**
		 *	注册场景
		 * @param viewId
		 * @param view
		 *
		 */
		public static function regView(viewId:int, view:Object):void
		{
			if (viewMap[viewId] != null)
			{
				Logger.getLogger("ViewManager").error("primary key repetition,viewId:", viewId);
				return;
			}

			viewMap[viewId]=view;
		}

		/**
		 *	卸载场景
		 * @param viewId
		 *
		 */
		public static function unregView(viewId:int):void
		{
			if (viewMap[viewId] == null)
			{
				Logger.getLogger("ViewManager").error("primary key is null,unexist key:", viewId);
				return;
			}

			var view:IView=viewMap[viewId] as IView;
			view.destroy();
			delete viewMap[viewId];
		}

		public function set view(viewId:int):void
		{
			if (viewMap[viewId] == null)
			{
				throw new IllegalOperationError("unexist viewId:" + viewId);
				return;
			}

			var view:IView;
			var obj:*=viewMap[viewId];
			if (obj is Class)
			{
				view=new obj();
				viewMap[viewId]=view;
			}
			else
			{
				view=viewMap[viewId] as IView;
			}
			
			//将前一个场景ID 设置为当前场景ID 
			_preViewId = _currentViewId;
			//设置当前场景ID
			_currentViewId = viewId;
			
			//当前场景离开
			if(_currentView)
			{
				_currentView.onHide(hideComplete);
			}
			
			PanelManager.getInstance().closeAllPanel();
			
			dispatchEvent(new Event("viewChanged"));
			_currentView = view;
			_currentView.onShow();
			
			LayerManager.getLayerByName(LayerManager.LAYER_VIEW).addChild(_currentView as DisplayObject);
		}
		
		private function hideComplete():void
		{
			LayerManager.getLayerByName(LayerManager.LAYER_VIEW).removeChild(_currentView as DisplayObject);
		}
		
		/**	回到前一个场景*/
		public function backPreview():void
		{
			view = _preViewId;
		}
	}
}
