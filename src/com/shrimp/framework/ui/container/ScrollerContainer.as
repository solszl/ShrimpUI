package com.shrimp.framework.ui.container
{
	import com.shrimp.framework.ui.controls.HScrollBar;
	import com.shrimp.framework.ui.controls.ScrollBar;
	import com.shrimp.framework.ui.controls.VScrollBar;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ScrollerContainer extends Container
	{
		protected var _vScrollBar:VScrollBar;
		protected var _hScrollBar:HScrollBar;

		protected var content:Container;

		public function ScrollerContainer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			content=new Container();
			content.setActualSize(250,250);
			_vScrollBar=new VScrollBar();
			_vScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
			_vScrollBar.target=this;
			_vScrollBar.touchable=true;
			super.addChild(_vScrollBar);
			_hScrollBar=new HScrollBar();
			_hScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
			_hScrollBar.target = this;
			super.addChild(_hScrollBar);
			super.addChildAt(content, 0);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			updateDisplayList();
			return content.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			updateDisplayList();
			return content.addChildAt(child, index);
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			updateDisplayList();
			return content.removeChild(child);
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			updateDisplayList();
			return content.removeChildAt(index);
		}

		override public function set width(value:Number):void
		{
			super.width=value;
			updateDisplayList();
		}

		override public function set height(value:Number):void
		{
			super.height=value;
			updateDisplayList();
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			var vShow:Boolean=_vScrollBar && content.height > _height;
			var hShow:Boolean=_hScrollBar && content.width > _width;
			var contentWidth:Number=vShow ? _width - _vScrollBar.width : _width;
			var contentHeight:Number=hShow ? _height - _hScrollBar.height : _height;
			content.scrollRect=new Rectangle(0, 0, contentWidth, contentHeight);
			if (_vScrollBar)
			{
				_vScrollBar.visible=content.height > _height;
				if (_vScrollBar.visible)
				{
					_vScrollBar.x=_width - _vScrollBar.width;
					_vScrollBar.y=0;
					_vScrollBar.height=_height - (hShow ? _hScrollBar.height : 0);
					_vScrollBar.tick=content.height * 0.1;
					_vScrollBar.thumbPercent=contentHeight / content.height;
					_vScrollBar.setSliderParams(0, content.height - contentHeight, _vScrollBar.value);
				}
			}
			if (_hScrollBar)
			{
				_hScrollBar.visible=content.width > _width;
				if (_hScrollBar.visible)
				{
					_hScrollBar.x=0;
					_hScrollBar.y=_height - _hScrollBar.height;
					_hScrollBar.width=_width - (vShow ? _vScrollBar.width : 0);
					_hScrollBar.thumbPercent=contentWidth / content.width;
					_hScrollBar.setSliderParams(0, content.width - contentWidth, _hScrollBar.value);
				}
			}
		}

		protected function onScrollBarChange(e:Event):void
		{
			var rect:Rectangle=content.scrollRect;
			if (rect)
			{
				var scroll:ScrollBar=e.currentTarget as ScrollBar;
				var start:int=Math.round(scroll.value);
				scroll.direction == ScrollBar.VERTICAL ? rect.y=start : rect.x=start;
				content.scrollRect=rect;
			}
		}

//		override public function commitMeasure():void {
//			exeCallLater(changeScroll);
//		}

		/**滚动到某个位置*/
		public function scrollTo(x:Number=0, y:Number=0):void
		{
			commitMeasure();
			if (vScrollBar)
			{
				vScrollBar.value=y;
			}
			if (hScrollBar)
			{
				hScrollBar.value=x;
			}
		}

		public function get vScrollBar():VScrollBar
		{
			return _vScrollBar;
		}

		public function get hScrollBar():HScrollBar
		{
			return _hScrollBar;
		}
	}
}
