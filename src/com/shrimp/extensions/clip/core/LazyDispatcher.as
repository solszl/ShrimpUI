package com.shrimp.extensions.clip.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * LazyDispatcher
	 * a.构造函数没有参数：只有在LazyDispatcher的实例添加监听时才会动态创建EventDispatcher
	 * b.构造函数有参数：支持多个LazyDispatcher公用一个EventDispatcher
	 * @author yeah
	 */	
	public class LazyDispatcher implements IEventDispatcher
	{
		
		protected var _dispatcher:EventDispatcher;
		
		public function LazyDispatcher($dispatcher:EventDispatcher = null)
		{
			this._dispatcher = $dispatcher;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if(!_dispatcher)
			{
				_dispatcher = new EventDispatcher();
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if(_dispatcher)
			{
				_dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			if(_dispatcher)
			{
				return _dispatcher.dispatchEvent(event);
			}
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			if(_dispatcher)
			{
				return _dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			if(_dispatcher)
			{
				return _dispatcher.willTrigger(type);
			}
			return false;
		}
	}
}