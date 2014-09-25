package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.interfaces.IView;
	import com.shrimp.framework.managers.StageManager;
	import com.shrimp.framework.ui.container.Box;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class BaseView extends Box implements IView
	{
		/**	资源是否已经准备完毕*/
		protected var resourcePrepared:Boolean=false;

		public function BaseView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		/**	呈现*/
		public function onShow():void
		{
			preShow();
			showing();
			endShow();
		}

		/**	隐藏*/
		public function onHide(endCallBK:Function=null):void
		{
			preHide();
			hiding();
			endHide(endCallBK);
		}

		/**	销毁*/
		public function destroy():void
		{
			resourcePrepared=false;
		}

		/**	预呈现*/
		protected function preShow():void
		{
			if (!resourcePrepared)
			{
				return;
			}
			StageManager.stage.addEventListener(Event.RESIZE, onStageResize);
		}

		/**	呈现中*/
		protected function showing():void
		{

		}

		/**	呈现完毕*/
		protected function endShow():void
		{

		}

		/**	预隐藏*/
		protected function preHide():void
		{

		}

		/**	隐藏中*/
		protected function hiding():void
		{

		}

		/**	隐藏完毕*/
		protected function endHide(endCallBK:Function):void
		{
			StageManager.stage.removeEventListener(Event.RESIZE, onStageResize);
			if (endCallBK != null)
			{
				endCallBK();
			}
		}

		protected function onStageResize(e:Event=null):void
		{
			invalidateDisplayList();
		}
	}
}
