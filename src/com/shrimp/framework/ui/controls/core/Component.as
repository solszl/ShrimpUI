package com.shrimp.framework.ui.controls.core
{
	import com.shrimp.framework.event.MouseEvents;
	import com.shrimp.framework.interfaces.ITooltip;
	import com.shrimp.framework.managers.ComponentManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.utils.getQualifiedClassName;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.TapGesture;

	/**	单击事件*/
	[Event(name="singleClick", type="org.gestouch.events.GestureEvent")]
	/**	双击事件*/
	[Event(name="doubleClick", type="org.gestouch.events.GestureEvent")]
	/**	长按事件*/
	[Event(name="longPress", type="org.gestouch.events.GestureEvent")]
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
		
		protected var _explicitHeight:Number=NaN;
		protected var _explicitWidth:Number=NaN;
		
		private var _horizontalCenter:Number=NaN;
		private var _verticalCenter:Number=NaN;
		
		private var _singleTap:TapGesture;
		private var _doubleTap:TapGesture;
		private var _longTap:LongPressGesture;
		private var _objData:Object;
		public function Component(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super();
			move(xpos, ypos);
			init();
			if (parent != null)
			{
				parent.addChild(this);
			}
		}
		
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		override public function get width():Number
		{
			return !isNaN(_explicitWidth) ? _explicitWidth : _width;
		}


		public function get measuredWidth():Number
		{
			measure();
			var max:Number=0;
			for (var i:int=numChildren - 1; i > -1; i--)
			{
				var comp:DisplayObject=getChildAt(i);
				max=Math.max(comp.x + comp.width, max);
			}
			return max;
		}

		
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth=value;
			if (isNaN(_explicitWidth))
			{
				if (_width != _measuredWidth)
				{
					_width=_measuredWidth;
					dispatchEvent(new Event(Event.RESIZE))
				}
			}
		}
		override public function set width(value:Number):void
		{
			if (_width == value)
				return;
			_width=value;
			_explicitWidth=value;
			invalidateDisplayList();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get height():Number
		{
			return !isNaN(_explicitHeight) ? _explicitHeight : _height;
		}

		public function get measuredHeight():Number
		{
			measure();
			var max:Number=0;
			for (var i:int=numChildren - 1; i > -1; i--)
			{
				var comp:DisplayObject=getChildAt(i);
				max=Math.max(comp.y + comp.height, max);
			}
			return max;
		}

		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
			if (isNaN(_explicitHeight))
			{
				if (_height != _measuredHeight)
				{
					_height=_measuredHeight;
					dispatchEvent(new Event(Event.RESIZE))
				}
			}
		}
		override public function set height(value:Number):void
		{
			if (_height == value)
				return;
			_height=value;
			_explicitHeight=value;
			invalidateDisplayList();
			dispatchEvent(new Event(Event.RESIZE));
		}

		protected function init():void
		{
			_listeners=[];

			createChildren();

			invalidateDisplayList();
			invalidateProperties();
			tabChildren=tabEnabled=false;
			ComponentManager.addPreInitComponent(this);
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

		public function setActualSize(w:Number, h:Number):void
		{
			_explicitWidth=w;
			_explicitHeight=h;
			
			_width=isNaN(w) ? _measuredWidth : w;
			
			_height=isNaN(h) ? _measuredHeight : h;
			
			invalidateDisplayList();
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

		private var _initialized:Boolean=false;
		private var _measuredHeight:Number;
		private var _measuredWidth:Number;

		public function get initialized():Boolean
		{
			return _initialized;
		}

		public function set initialized(value:Boolean):void
		{
			_initialized=value;

			if (value)
			{
				addEventListener("createComplete", creationCompleteHandler, false, 0, true);
				dispatchEvent(new Event("createComplete"));
			}
		}

		protected function creationCompleteHandler(event:Event):void
		{
//			trace("creationCompleteHandler");
		}

		public function validateNow():void
		{
//			trace("validateNow");
			validateProperties();
			validateDisplayList();
		}

		public function validateDisplayList():void
		{
			updateDisplayList();
			ComponentManager.removePaddingDisplay(this);
//			trace("validateDisplayList");
		}


		public function validateProperties():void
		{
			commitProperties();
			ComponentManager.removePaddingProperty(this)
//			trace("validateProperties");
		}

		public function invalidateDisplayList():void
		{
			ComponentManager.addPaddingDisplay(this);
//			trace("invalidateDisplayList");
		}

		public function invalidateProperties():void
		{
			ComponentManager.addPaddingProperty(this);
//			trace("invalidateProperties");
		}

		protected function measure():void
		{
//			trace("measure");
		}

		protected function updateDisplayList():void
		{
			measure();
//			trace("updateDisplayList");
		}

		protected function commitProperties():void
		{
//			trace("commitProperties");
		}

		/**执行影响宽高的延迟函数*/
		public function commitMeasure():void
		{

		}

		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		
		public function set horizontalCenter(value:Number):void
		{
			if (value == _horizontalCenter)
				return;
			_horizontalCenter=value;
			invalidateDisplayList();
		}
		
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		
		public function set verticalCenter(value:Number):void
		{
			if (value == _verticalCenter)
				return;
			_verticalCenter=value;
			invalidateDisplayList();
		}
		
		/**复写添加监听的方法，将监听对象，类型， 函数注册到listeners中。方便集中管理，销毁*/
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._listeners.push({type: type, listener: listener, useCapture: useCapture});
			//手势构造器
			gestureBuilder(type);
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
		
		private function gestureBuilder(type:String):void
		{
			switch(type)
			{
				case MouseEvents.SINGLE_CLICK:
					_singleTap = new TapGesture(this);
					_singleTap.addEventListener(GestureEvent.GESTURE_RECOGNIZED,onGesture);
					break;
				case MouseEvents.DOUBLE_CLICK:
					_doubleTap = new TapGesture(this);
					_doubleTap.maxTapDelay = 300;
					_doubleTap.numTapsRequired = 2;
					_singleTap.requireGestureToFail(_doubleTap);
					_doubleTap.addEventListener(GestureEvent.GESTURE_RECOGNIZED,onGesture);
					break;
				case MouseEvents.LONG_PRESS:
					_longTap = new LongPressGesture(this);
					_longTap.addEventListener(GestureEvent.GESTURE_BEGAN,onGesture);
					break;
			}
		}
		
		private function onGesture(event:GestureEvent):void
		{
			var g:Gesture = event.target as Gesture;
			if(g == _singleTap)
			{
				dispatchEvent(new GestureEvent(MouseEvents.SINGLE_CLICK,event.newState,event.oldState));
			}
			else if(g == _doubleTap)
			{
				dispatchEvent(new GestureEvent(MouseEvents.DOUBLE_CLICK,event.newState,event.oldState));
			}
			else if(g == _longTap)
			{
				dispatchEvent(new GestureEvent(MouseEvents.LONG_PRESS,event.newState,event.oldState));
			}
			else
			{
				trace("no such gesture");
			}
		}
		
		protected function getShadow(dist:Number, knockout:Boolean=false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, 2, 2);
		}
		
		public function getSizePosition():String
		{
			return "width:"+width+", height:"+height+", x:"+x+", y:"+y+", type:"+getQualifiedClassName(this);
		}

		/**	用来存储一些特殊属性*/
		public function get objData():Object
		{
			if(null==_objData)
				_objData=new Object();
			return _objData;
		}

		public function set objData(value:Object):void
		{
			_objData = value;
		}


	}
}
