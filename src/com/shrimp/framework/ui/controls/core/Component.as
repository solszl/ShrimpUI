package com.shrimp.framework.ui.controls.core
{
	import com.shrimp.framework.interfaces.ITooltip;
	import com.shrimp.framework.managers.ComponentManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		protected var _listeners:Array;

		public function Component(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
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

		protected function preInit():void
		{
			//初始化监听器
			_listeners = [];
		}

		/**	默认初始化*/
		protected function init():void
		{
			createChildren();

			tabChildren = tabEnabled = false;
			ComponentManager.addPreInitComponent(this);
		}

		protected function createChildren():void
		{

		}

		public function validateNow():void
		{
			out("validateNow");
			validateProperties();
			validateSize();
			validateDisplayList();
		}

		public function invalidateDisplayList():void
		{
			out("invalidateDisplayList");
			ComponentManager.addPaddingDisplay(this);
		}
		
		public function validateDisplayList():void
		{
			out("validateDisplayList");
			updateDisplayList();
			ComponentManager.removePaddingDisplay(this);
		}
		
		protected function updateDisplayList():void
		{
			_width = width;
			_height = height;
			out("updateDisplayList");
		}

		public function invalidateProperties():void
		{
			out("invalidateProperties");
			ComponentManager.addPaddingProperty(this);
		}
		
		public function validateProperties():void
		{
			out("validateProperties");
			commitProperties();
			ComponentManager.removePaddingProperty(this)
		}
		
		protected function commitProperties():void
		{
			out("commitProperties");
		}

		public function invalidateSize():void
		{
			out("invalidateSize");
			ComponentManager.addPaddingSize(this);
		}

		protected function measure():void
		{
			measuredHeight = 0;
			measuredWidth = 0;
			out("measure");
		}
		
		private var oldW:Number = -1;
		private var oldH:Number = -1;
		
		public function validateSize():void
		{
			if (isNaN(explicitWidth) || isNaN(explicitHeight))
			{
				measure();
			}
			
			if (oldW != width || oldH != height)
			{
				oldW = width;
				oldH = height;
				invalidateDisplayList();
				dispatchEvent(new Event(Event.RESIZE));
			}
			ComponentManager.removePaddingSize(this);
		}

		//---------------------------------------------------------------//
		//						override								 //
		//---------------------------------------------------------------//

		protected var _width:Number = NaN;
		
		override public function get width():Number
		{
			if (!isNaN(explicitWidth))
			{
				return _explicitWidth;
			}
			else if (!isNaN(_measuredWidth))
			{
				return measuredWidth;
			}
			else
			{
				return _width || 0;
			}
		}
		
		override public function set width(value:Number):void
		{
			if (explicitWidth == value)
				return;
			
			_explicitWidth = _width = value;
			invalidateProperties();
			invalidateSize();
		}
		
		protected var _height:Number = NaN;
		
		override public function get height():Number
		{
			if (!isNaN(explicitHeight))
			{
				return explicitHeight;
			}
			else if (!isNaN(_measuredHeight))
			{
				return measuredHeight;
			}
			else
			{
				return _height || 0;
			}
		}
		
		override public function set height(value:Number):void
		{
			if (_explicitHeight == value)
				return;
			
			_explicitHeight = _height = value;
			invalidateProperties();
			invalidateSize();
		}
		
		/**复写添加监听的方法，将监听对象，类型， 函数注册到listeners中。方便集中管理，销毁*/
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._listeners.push({type:type, listener:listener, useCapture:useCapture});
		}
		
		/**复写移除监听方法，将监听的事件移除，并且从listeners中移除*/
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			super.removeEventListener(type, listener, useCapture);
			var delEvent:Object;
			for each (var event:Object in _listeners)
			{
				if (event.type == type && event.listener == listener)
				{
					delEvent = event;
					break;
				}
			}
			if (delEvent)
			{
				_listeners.splice(_listeners.indexOf(delEvent), 1);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			addNestLevel(child);
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			addNestLevel(child);
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);
			subNestLevel(child);
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			super.removeChildAt(index);
			var child:DisplayObject = getChildAt(index);
			removeChild(child);
			return child
		}
		
		//---------------------------------------------------------------//
		//						public									 //
		//---------------------------------------------------------------//
		/**	移动*/
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		public function setActualSize(w:Number, h:Number):void
		{
			_explicitWidth = w;
			_explicitHeight = h;
			
			_width = isNaN(w) ? _measuredWidth : w;
			
			_height = isNaN(h) ? _measuredHeight : h;
			
			invalidateSize();
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
			_listeners = [];
		}
		
		public function getListenerByType(type:String):Array
		{
			var listeners:Array = [];
			for each (var event:Object in _listeners)
			{
				if (event.type == type)
				{
					listeners.push(event.listener);
				}
				
			}
			return listeners;
		}
		
		/**
		 *	拿到组件的宽,高,X,Y,以及反射出来的名字
		 * @return
		 *
		 */
		public function getSizePosition():String
		{
			return "width:" + width + ", height:" + height + ", x:" + x + ", y:" + y + ", type:" + getQualifiedClassName(this);
		}
		
		/**根据名字删除子对象，如找不到不会抛出异常*/
		public function removeChildByName(name:String):void
		{
			var display:DisplayObject = getChildByName(name);
			if (display)
			{
				removeChild(display);
			}
		}
		
		/**显示边框*/
		public function showBorder(color:uint = 0xff0000):void
		{
			with (this)
			{
				graphics.lineStyle(1, color);
				graphics.drawRect(0, 0, width, height);
			}
		}
		
		//---------------------------------------------------------------//
		//						private								 //
		//---------------------------------------------------------------//
		private function addNestLevel(child:DisplayObject):void
		{
			if (!(child is Component))
			{
				return;
			}
			
			var comp:Component = child as Component;
			comp.nestLevel = comp.nestLevel + 1;
		}
		
		private function subNestLevel(child:DisplayObject):void
		{
			if (!(child is Component))
			{
				return;
			}
			
			var comp:Component = child as Component;
			comp.nestLevel = comp.nestLevel - 1;
		}
		
		
		private function out(type:String):void
		{
//			trace(type,this);
		}
		
		//---------------------------------------------------------------//
		//						protected								 //
		//---------------------------------------------------------------//
		protected function creationCompleteHandler(e:Event):void
		{
			out("creationCompleteHandler");
		}
		
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, 0x000000, 1, 2, 2);
		}
		
		//---------------------------------------------------------------//
		//					getter & setter								 //
		//---------------------------------------------------------------//
		/**	明确的高*/
		protected var _explicitHeight:Number = NaN;
		public function get explicitHeight():Number
		{
			return _explicitHeight;
		}
		
		/**	计算出来的高*/
		private var _measuredHeight:Number;
		
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
			if (isNaN(_explicitHeight))
			{
				if (_height != _measuredHeight)
				{
					_height = _measuredHeight;
					dispatchEvent(new Event(Event.RESIZE))
				}
			}
		}
		
		/**	明确的宽*/
		protected var _explicitWidth:Number = NaN;
		public function get explicitWidth():Number
		{
			return _explicitWidth;
		}
		
		/**	计算出来的宽*/
		private var _measuredWidth:Number;
		
		/**	度量宽度*/
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		
		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
			if (isNaN(_explicitWidth))
			{
				if (_width != _measuredWidth)
				{
					_width = _measuredWidth;
					dispatchEvent(new Event(Event.RESIZE))
				}
			}
		}
		
		private var _tooltip:Object;
		
		public function set toolTip(value:Object):void
		{
			//TODO: reg tooltip
		}
		
		public function get toolTip():Object
		{
			return this._tooltip;
		}
		
		private var _initialized:Boolean = false;
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function set initialized(value:Boolean):void
		{
			_initialized = value;
			
			if (value)
			{
				addEventListener("createComplete", creationCompleteHandler, false, 0, true);
				dispatchEvent(new Event("createComplete"));
			}
		}
		
		private var _horizontalCenter:Number = NaN;
		
		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}
		
		public function set horizontalCenter(value:Number):void
		{
			if (value == _horizontalCenter)
				return;
			_horizontalCenter = value;
			invalidateDisplayList();
		}
		
		private var _verticalCenter:Number = NaN;
		
		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}
		
		public function set verticalCenter(value:Number):void
		{
			if (value == _verticalCenter)
				return;
			_verticalCenter = value;
			invalidateDisplayList();
		}
		private var _enabled:Boolean;
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			alpha = _enabled ? 1.0 : 0.8;
		}
		
		private var _objData:Object;
		
		/**	用来存储一些特殊属性*/
		public function get objData():Object
		{
			if (null == _objData)
				_objData = new Object();
			return _objData;
		}
		
		public function set objData(value:Object):void
		{
			_objData = value;
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
			
			_top = value;
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
			
			_left = value;
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
			_right = value;
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
			
			_bottom = value;
			invalidateDisplayList();
		}
		
		//新手引导名字
		private var _guideName:String;
		
		/**	新手引导名字*/
		public function get guideName():String
		{
			return _guideName;
		}
		
		public function set guideName(value:String):void
		{
			_guideName = value;
		}
		
		private var _nestLevel:Number = 0;
		
		public function get nestLevel():Number
		{
			return _nestLevel;
		}
		
		public function set nestLevel(value:Number):void
		{
			if (_nestLevel != value)
			{
				_nestLevel = value;
				value++;
				/**
				 * 可以达到级联设置子级显示列表nestLevel的效果
				 */
				for (var i:int = 0; i < numChildren; i++)
				{
					var comp:Component = getChildAt(i) as Component;
					if (comp)
					{
						comp.nestLevel = value;
					}
				}
			}
		}
	}
}
