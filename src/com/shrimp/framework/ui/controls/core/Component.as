package com.shrimp.framework.ui.controls.core
{
	import com.shrimp.framework.interfaces.ITooltip;
	import com.shrimp.framework.managers.ComponentManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.utils.getQualifiedClassName;

	/**
	 *	组件基类
	 * @author Sol
	 *
	 */
	public class Component extends Sprite implements ITooltip
	{
		private var _tooltip:Object;

		protected var _listeners:Array;

		private var _initialized:Boolean=false;
		/**	计算出来的高*/
		private var _measuredHeight:Number;
		/**	计算出来的宽*/
		private var _measuredWidth:Number;

		protected var _height:Number;
		protected var _width:Number;

		/**	明确的高*/
		protected var _explicitHeight:Number=NaN;
		/**	明确宽*/
		protected var _explicitWidth:Number=NaN;

		private var _horizontalCenter:Number=NaN;
		private var _verticalCenter:Number=NaN;

		private var _objData:Object;

		public function Component(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super();

			preInit();
			move(xpos, ypos);
			if (parent != null)
			{
				parent.addChild(this);
			}
			init();
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
			/*if (!isNaN(explicitWidth))
			{
				return _explicitWidth;
			}
			else if (measuredWidth != 0)
			{
				return measuredWidth;
			}
			else
			{
				return _width;
			}*/

			if (!isNaN(_width))
			{
				return _width;
			}
			else if (!isNaN(explicitWidth))
			{
				return _explicitWidth;
			}
			else
			{
				return measuredWidth;
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

		public function get measuredWidth():Number
		{
			commitProperties();
			var max:Number=0;
			for (var i:int=numChildren - 1; i > -1; i--)
			{
				var comp:DisplayObject=getChildAt(i);
				max=Math.max(comp.x + comp.width, max);
			}
			return max;

//			return _measuredWidth;
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

		override public function get height():Number
		{
			/*if (!isNaN(explicitHeight))
			{
				return _explicitHeight;
			}
			else if (measuredHeight != 0)
			{
				return measuredHeight;
			}
			else
			{
				return _height;
			}*/
			
			if (!isNaN(_height))
			{
				return _height;
			}
			else if (!isNaN(explicitHeight))
			{
				return explicitHeight;
			}
			else
			{
				return measuredHeight;
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

		public function get measuredHeight():Number
		{
			commitProperties();
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
			_measuredHeight=value;
			if (isNaN(_explicitHeight))
			{
				if (_height != _measuredHeight)
				{
					_height=_measuredHeight;
					dispatchEvent(new Event(Event.RESIZE))
				}
			}
		}

		protected function preInit():void
		{
			//初始化监听器
			_listeners=[];
		}

		protected function init():void
		{

			createChildren();

			invalidateProperties();
			invalidateDisplayList();
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

		protected function creationCompleteHandler(e:Event):void
		{
			//trace("creationCompleteHandler");
		}

		public function validateNow():void
		{
			//trace("validateNow");
			validateProperties();
			validateDisplayList();
		}

		public function validateDisplayList():void
		{
			updateDisplayList();
			ComponentManager.removePaddingDisplay(this);
			//trace("validateDisplayList");
		}


		public function validateProperties():void
		{
			commitProperties();
			ComponentManager.removePaddingProperty(this)
			//trace("validateProperties");
		}

		public function invalidateDisplayList():void
		{
			ComponentManager.addPaddingDisplay(this);
			//trace("invalidateDisplayList");
		}

		public function invalidateProperties():void
		{
			ComponentManager.addPaddingProperty(this);
			//trace("invalidateProperties");
		}

		protected function measure():void
		{
			//trace("measure",this);
		}

		protected function updateDisplayList():void
		{
			measure();
			//trace("updateDisplayList");
		}

		protected function commitProperties():void
		{
			//trace("commitProperties");
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
		private var _enabled:Boolean;

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled=value;
			mouseEnabled=mouseChildren=_enabled;
			alpha=_enabled ? 1.0 : 0.8;
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

		protected function getShadow(dist:Number, knockout:Boolean=false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, 2, 2);
		}

		public function getSizePosition():String
		{
			return "width:" + width + ", height:" + height + ", x:" + x + ", y:" + y + ", type:" + getQualifiedClassName(this);
		}

		/**	用来存储一些特殊属性*/
		public function get objData():Object
		{
			if (null == _objData)
				_objData=new Object();
			return _objData;
		}

		public function set objData(value:Object):void
		{
			_objData=value;
		}

		private var _top:Object;

		public function get top():Object
		{
			return _top;
		}

		public function set top(value:Object):void
		{
			if (value == _top)
				return;

			_top=value;
			invalidateDisplayList();
		}

		private var _left:Object;

		public function get left():Object
		{
			return _left;
		}

		public function set left(value:Object):void
		{
			if (value == _left)
				return;

			_left=value;
			invalidateDisplayList();
		}

		private var _right:Object;

		public function get right():Object
		{
			return _right;
		}

		public function set right(value:Object):void
		{
			if (value == _right)
				return;
			_right=value;
			invalidateDisplayList();
		}

		private var _bottom:Object;

		public function get bottom():Object
		{
			return _bottom;
		}

		public function set bottom(value:Object):void
		{
			if (value == _bottom)
				return;

			_bottom=value;
			invalidateDisplayList();
		}
	}
}
