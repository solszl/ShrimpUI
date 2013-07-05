package com.shrimp.ui.controls.core
{
	import com.shrimp.interfaces.ITooltip;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 *	组件基类
	 * @author Sol
	 *
	 */
	public class Component extends Sprite implements ITooltip
	{
		private var _tooltip:Object;

		protected var _listeners:Array;

		public function Component(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super();
			move(xpos, ypos);
			if (parent != null)
			{
				parent.addChild(this);
			}
			_listeners=[];
		}

		public function move(xpos:Number, ypos:Number):void
		{
			x=Math.round(xpos);
			y=Math.round(ypos);
		}

		public function set toolTip(value:Object):void
		{
			//TODO: reg tooltip
		}

		public function get toolTip():Object
		{
			return this._tooltip;
		}

		//复写添加监听的方法，将监听对象，类型， 函数注册到listeners中。方便集中管理，销毁
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._listeners.push({type: type, listener: listener, useCapture:useCapture});
		}

		//复写移除监听方法，将监听的事件移除，并且从listeners中移除
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			var delEvent:Object;
			for each (var event:Object in _listeners)
			{
				if (event.type == type && event.listener == listener)
				{
					delEvent=event;
					break;
				}
			}
			if (delEvent)
			{
				_listeners.splice(_listeners.indexOf(delEvent), 1);
			}
		}
		
		public function removeListeners():void
		{
			for each(var event:Object in _listeners)
			{
				super.removeEventListener(event.type,event.listener,event.useCapture);
			}
			_listeners=[];
		}
		
		public function getListenerByType(type:String):Array
		{
			var listeners:Array=[];
			for each(var event:Object in _listeners)
			{
				if(event.type == type)
				{
					listeners.push(event.listener);
				}
					
			}
			return listeners;
		}
	}
}
