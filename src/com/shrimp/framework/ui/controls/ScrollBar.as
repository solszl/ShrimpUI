package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.managers.WorldClockManager;
	import com.shrimp.framework.ui.container.Container;
	import com.shrimp.framework.ui.controls.core.Component;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[Event(name="change", type="flash.events.Event")]
	public class ScrollBar extends Container
	{
		/**水平移动*/
		public static const HORIZONTAL:String="horizontal";
		/**垂直移动*/
		public static const VERTICAL:String="vertical";

		private var _tick:Number=1;
		private var _upBtn:Button;
		private var _downBtn:Button;
		private var _slider:Slider;

		private var _isUp:Boolean;
		/**	目标组件*/
		private var _target:Component;
		private var _thumbPercent:Number;
		private var _touchable:Boolean;

		private var _direction:String;

		public function ScrollBar(direction:String, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			_direction=direction;
			super(parent, xpos, ypos);
			mouseChildren=true;
		}

		override protected function init():void
		{
			super.init();
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			_slider.addEventListener(Event.CHANGE, onSliderChange);
			_slider.setSliderParams(0, 100, 0);
		}

		protected function onSliderChange(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onButtonMouseDown(event:MouseEvent):void
		{
			isUp=event.currentTarget == _upBtn;
			slide();
			WorldClockManager.getInstance().doFrameOnce(1, loop);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}

		protected function onStageMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			WorldClockManager.getInstance().clearTimer(loop);
			WorldClockManager.getInstance().clearTimer(slide);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_upBtn=new Button(this);
			_upBtn.label="up"
			_slider=new Slider(_direction);
			addChild(_slider);
			_downBtn=new Button(this);
			_downBtn.label="down";
		}

		private function loop():void
		{
			WorldClockManager.getInstance().doFrameLoop(1, slide);
		}

		private function slide():void
		{
			if (isUp)
			{
				value-=tick;
			}
			else
			{
				value+=tick;
			}
		}

		/**	设置变化量*/
		public function get tick():Number
		{
			return _tick;
		}

		public function set tick(value:Number):void
		{
			_tick=value;
		}

		/**	状态值，true的时候为，上，或左，否则为，下或右*/
		public function get isUp():Boolean
		{
			return _isUp;
		}

		public function set isUp(value:Boolean):void
		{
			_isUp=value;
		}

		public function get value():Number
		{
			return _slider.value;
		}

		public function set value(value:Number):void
		{
			_slider.value=value;
		}

		public function get direction():String
		{
			return _slider.direction;
		}

		public function set direction(value:String):void
		{
			_slider.direction=value;
		}

		/**	最小值*/
		public function get min():Number
		{
			return _slider.minimum;
		}

		public function set min(value:Number):void
		{
			_slider.minimum=value;
		}

		/**	最大值*/
		public function get max():Number
		{
			return _slider.maximum;
		}

		public function set max(value:Number):void
		{
			_slider.maximum=value;
		}

		/**滚动对象*/
		public function get target():Component
		{
			return _target;
		}

		public function set target(value:Component):void
		{
			if (_target)
			{
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
			}
			_target=value;
			if (value)
			{
				_target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				if (_touchable)
				{
					_target.addEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
				}
			}
		}

		protected function onMouseWheel(e:MouseEvent):void
		{
			value+=(e.delta < 0 ? 1 : -1) * _thumbPercent * (max - min);
			if (value < max && value > min)
			{
				e.stopPropagation();
			}
		}

		/**滑条长度比例(0-1)*/
		public function get thumbPercent():Number
		{
			return _thumbPercent;
		}

		public function set thumbPercent(value:Number):void
		{
			invalidateDisplayList();
			_thumbPercent=value;
			if (_slider.direction == VERTICAL)
			{
				_slider.backTrack.height=Math.max(int(_slider.height * value), 28);
			}
			else
			{
				_slider.backTrack.width=Math.max(int(_slider.width * value), 28);
			}
		}

		/**是否触摸滚动，默认为true*/
		public function get touchable():Boolean
		{
			return _touchable;
		}

		public function set touchable(value:Boolean):void
		{
			_touchable=value;
		}

		protected function onTargetMouseDown(e:MouseEvent):void
		{
			_target.mouseChildren=true;
			WorldClockManager.getInstance().clearTimer(tweenMove);
			if (!this.contains(e.target as DisplayObject))
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp2);
				stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				_lastPoint=new Point(stage.mouseX, stage.mouseY);
			}

			if (this.contains(e.target as DisplayObject))
			{

			}
			else
			{

			}
		}

		protected function onStageEnterFrame(e:Event):void
		{
			_lastOffset=_slider.direction == VERTICAL ? stage.mouseY - _lastPoint.y : stage.mouseX - _lastPoint.x;
			if (Math.abs(_lastOffset) >= 1)
			{
				_lastPoint.x=stage.mouseX;
				_lastPoint.y=stage.mouseY;
				_target.mouseChildren=false;
				value-=_lastOffset;
			}
		}

		protected function onStageMouseUp2(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp2);
			stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			if (Math.abs(_lastOffset) > 50)
			{
				_lastOffset=50 * (_lastOffset > 0 ? 1 : -1);
			}
			WorldClockManager.getInstance().doFrameLoop(1, tweenMove);
		}

		private function tweenMove():void
		{
			_lastOffset=_lastOffset * 0.92;
			value-=_lastOffset;
			if (Math.abs(_lastOffset) < 0.5)
			{
				_target.mouseChildren=true;
				WorldClockManager.getInstance().clearTimer(tweenMove);
			}
		}

		protected var _lastPoint:Point;
		protected var _lastOffset:Number
	}
}
