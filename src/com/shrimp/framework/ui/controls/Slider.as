package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="change", type="flash.events.Event")]
	public class Slider extends Component
	{
		/**方向*/		
		protected var _orientation:String;
		
		public static const HORIZONTAL:String="horizontal";
		public static const VERTICAL:String="vertical";
		public function Slider(orientation:String=Slider.HORIZONTAL,parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			_orientation=orientation;
			super(parent, xpos, ypos);
			if (defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		override protected function init():void
		{
			super.init();
			
			if(_orientation == HORIZONTAL)
			{
				setActualSize(100,10);
			}
			else
			{
				setActualSize(10,100);
			}
		}
		
		private var _back:Sprite;
		override protected function createChildren():void
		{
			super.createChildren();
			_back= new Sprite();
			_back.filters = [getShadow(2, true)]
			addChild(_back);
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			drawBack();
		}
		
		protected function drawBack():void
		{
			_back.graphics.clear();
			_back.graphics.beginFill(0xFF0000);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
		}
	}
}