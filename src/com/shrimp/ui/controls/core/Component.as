package com.shrimp.ui.controls.core
{
	import com.shrimp.interfaces.ITooltip;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *	组件基类
	 * @author Sol
	 *
	 */
	public class Component extends Sprite implements ITooltip
	{
		private var _tooltip:Object;

		protected var _listeners:Array;

		protected var _height:Number;
		protected var _width:Number;

		private var _sizeChanged:Boolean=false;

		private var mPivotX:Number;
		private var mPivotY:Number;
		private var mOrientationChanged:Boolean;

		public function Component(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super();
			move(xpos, ypos);
			if (parent != null)
			{
				parent.addChild(this);
			}

			init();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			if (_width == value)
				return;
			_width=value;
			_sizeChanged=true;
			invalidateDisplayList();
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			if (_height == value)
				return;
			_height=value;
			_sizeChanged=true;
			invalidateDisplayList();
		}

		protected function init():void
		{
			_listeners=[];

			createChildren();

			mouseChildren=tabChildren=tabEnabled=false;
		}

		protected function createChildren():void
		{

		}

		/**	移动*/
		public function move(xpos:Number, ypos:Number):void
		{
			x=Math.round(xpos);
			y=Math.round(ypos);
		}

		/**根据名字删除子对象，如找不到不会抛出异常*/
		public function removeChildByName(name:String):void
		{
			var display:DisplayObject=getChildByName(name);
			if (display)
			{
				removeChild(display);
			}
		}

		/**显示边框*/
		public function showBorder(color:uint=0xff0000):void
		{
			removeChildByName("border");
			var border:Shape=new Shape();
			border.name="border";
			border.graphics.lineStyle(1, color);
			border.graphics.drawRect(0, 0, width, height);
			addChild(border);

		}

		public function set toolTip(value:Object):void
		{
			//TODO: reg tooltip
		}

		public function get toolTip():Object
		{
			return this._tooltip;
		}

		/**复写添加监听的方法，将监听对象，类型， 函数注册到listeners中。方便集中管理，销毁*/
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._listeners.push({type: type, listener: listener, useCapture: useCapture});
		}

		/**复写移除监听方法，将监听的事件移除，并且从listeners中移除*/
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

		/**
		 *	移除组件所有的监听事件
		 *
		 */
		public function removeListeners():void
		{
			for each (var event:Object in _listeners)
			{
				super.removeEventListener(event.type, event.listener, event.useCapture);
			}
			_listeners=[];
		}

		public function getListenerByType(type:String):Array
		{
			var listeners:Array=[];
			for each (var event:Object in _listeners)
			{
				if (event.type == type)
				{
					listeners.push(event.listener);
				}

			}
			return listeners;
		}

		public function invalidateDisplayList():void
		{
			if (_sizeChanged)
			{
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		/** X轴注册点*/
		public function get pivotX():Number
		{
			return mPivotX;
		}

		public function set pivotX(value:Number):void
		{
			if (mPivotX != value)
			{
				mPivotX=value;
				mOrientationChanged=true;
			}
		}

		/** Y轴注册点*/
		public function get pivotY():Number
		{
			return mPivotY;
		}

		public function set pivotY(value:Number):void
		{
			if (mPivotY != value)
			{
				mPivotY=value;
				mOrientationChanged=true;
			}
		}
	}
}
