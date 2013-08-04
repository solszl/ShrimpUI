package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.event.MouseEvents;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.Gesture;
	import org.gestouch.gestures.LongPressGesture;
	import org.gestouch.gestures.TapGesture;

	/**	单击事件*/
	[Event(name="singleClick", type="com.shrimp.framework.event.MouseEvents")]
	/**	双击事件*/
	[Event(name="doubleClick", type="com.shrimp.framework.event.MouseEvents")]
	/**	长按事件*/
	[Event(name="longPress", type="com.shrimp.framework.event.MouseEvents")]
	public class Button extends Component
	{
		public function Button(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, label:String="")
		{
			super(parent, xpos, ypos);
			setActualSize(100,30);
			mouseChildren=false;
			this.label=label;
		}
		
		override protected function createChildren():void
		{
			_label=new Label(this);
			_label.mouseEnabled=false;
			_label.mouseChildren=false;
			_labelColor = _label.color;
		}
		
		protected var _label:Label;
		protected var _labelText:String="";
		private var _labelChanged:Boolean=false;
		
		private var _singleTap:TapGesture;
		private var _doubleTap:TapGesture;
		private var _longTap:LongPressGesture;
		
		public function get label():String
		{
			return _labelText;
		}
		
		public function set label(value:String):void
		{
			if (_labelText == value)
				return;
			
			_labelChanged=true;
			_labelText=value;
			
			invalidateProperties();
		}
		
		private var _labelColor:uint = 0;
		public function set labelColor(value:uint):void
		{
			_label.color=value;
		}
		
		public function get labelColor():uint
		{
			return _labelColor;
		}
		
		public function get labelSize():uint
		{
			return _label.fontSize;
		}
		
		public function set labelSize(value:uint):void
		{
			_label.fontSize=value;
		}
		
		public function get bold():Boolean
		{
			return _label.bold;
		}
		
		public function set bold(value:Boolean):void
		{
			_label.bold=value;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (_labelChanged)
			{
				_labelChanged=false;
				_label.text=_labelText;
				_label.validateNow();
				invalidateDisplayList();
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			doLabelAlign();
		}
		
		[Inspectable(category="General", enumeration="top-left,top-center,top-right,middle-left,middle-center,middle-right,bottom-left,bottom-center,bottom-right", defaultValue="middle-center")]
		public function get labelAlign():String
		{
			return _labelAlign;
		}
		
		public function set labelAlign(value:String):void
		{
			if (value == _labelAlign)
				return;
			
			_labelAlign=value;
			
			invalidateDisplayList();
		}
		
		private function doLabelAlign():void
		{
			var arr:Array=_labelAlign.split("-");
			
			if (arr[1] == "left")
			{
				_label.x=0;
			}
			else if (arr[1] == "center")
			{
				_label.x=_width / 2 - _label.width / 2
			}
			else
			{
				_label.x=_width - _label.width;
			}
			
			if (arr[0] == "top")
			{
				_label.y=0;
			}
			else if (arr[0] == "middle")
			{
				_label.y=_height / 2 - _label.height / 2;
			}
			else
			{
				_label.y=_height - _label.height;
			}
		}
		
		private var _labelAlign:String="middle-center";
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			gestureBuilder(type);
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
					_longTap.addEventListener(GestureEvent.GESTURE_STATE_CHANGE,onGesture);
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
	}
}
