package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.GlobalConfig;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	public class Slider extends Component
	{
		protected var _handle:Button;
		protected var _back:Image;
		protected var _backClick:Boolean;
		protected var _value:Number=0;
		protected var _max:Number=100;
		protected var _min:Number=0;
		protected var _orientation:String;
		protected var _tick:Number=0.01;
		
		public static const HORIZONTAL:String="horizontal";
		public static const VERTICAL:String="vertical";
		
		public function Slider(orientation:String=Slider.HORIZONTAL, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			_orientation=orientation;
			super(parent, xpos, ypos);
			if (defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			
			if (_orientation == HORIZONTAL)
			{
				setActualSize(200, 20);
			}
			else
			{
				setActualSize(20, 200);
			}
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function createChildren():void
		{
			_back=new Image(this);
			_back.mouseEnabled=true;
			_back.source = Style.sliderBG;
			_back.scale9Rect=new Rectangle(12,12,14,14);
			
			_handle=new Button(this);
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			
		}
		
		/**
		 * Adjusts value to be within minimum and maximum.
		 */
		protected function correctValue():void
		{
			if (_max > _min)
			{
				_value=Math.min(_value, _max);
				_value=Math.max(_value, _min);
			}
			else
			{
				_value=Math.max(_value, _max);
				_value=Math.min(_value, _min);
			}
		}
		
		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if (_orientation == HORIZONTAL)
			{
				range=_width - _height;
				_handle.x=(_value - _min) / (_max - _min) * range;
			}
			else
			{
				range=_height - _width;
				_handle.y=_height - _width - (_value - _min) / (_max - _min) * range;
			}
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			_back.setActualSize(_width,_height);
			positionHandle();
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum=min;
			this.maximum=max;
			this.value=value;
		}
		
		protected function onBackClick(event:MouseEvent):void
		{
			if (_orientation == HORIZONTAL)
			{
				_handle.x=mouseX - _height / 2;
				_handle.x=Math.max(_handle.x, 0);
				_handle.x=Math.min(_handle.x, _width - _height);
				_value=_handle.x / (width - _height) * (_max - _min) + _min;
			}
			else
			{
				_handle.y=mouseY - _width / 2;
				_handle.y=Math.max(_handle.y, 0);
				_handle.y=Math.min(_handle.y, _height - _width);
				_value=(_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if (_orientation == HORIZONTAL)
			{
				_handle.startDrag(false, new Rectangle(0, 0, _width - _height, 0));
			}
			else
			{
				_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _width));
			}
		}
		
		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}
		
		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number=_value;
			if (_orientation == HORIZONTAL)
			{
				_value=_handle.x / (width - _height) * (_max - _min) + _min;
			}
			else
			{
				_value=(_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
			}
			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * Sets / gets whether or not a click on the background of the slider will move the handler to that position.
		 */
		private var _backClickChanged:Boolean=false;
		
		public function set backClick(b:Boolean):void
		{
			_backClick=b;
			
			if (_backClick)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}
		
		public function get backClick():Boolean
		{
			return _backClick;
		}
		
		/**
		 * Sets / gets the current value of this slider.
		 */
		public function set value(v:Number):void
		{
			_value=v;
			correctValue();
			positionHandle();
			
		}
		
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}
		
		/**
		 * Gets the value of the slider without rounding it per the tick value.
		 */
		public function get rawValue():Number
		{
			return _value;
		}
		
		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max=m;
			correctValue();
			positionHandle();
		}
		
		public function get maximum():Number
		{
			return _max;
		}
		
		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			_min=m;
			correctValue();
			positionHandle();
		}
		
		public function get minimum():Number
		{
			return _min;
		}
		
		public function set tick(t:Number):void
		{
			_tick=t;
		}
		
		public function get tick():Number
		{
			return _tick;
		}
		
	}
}
