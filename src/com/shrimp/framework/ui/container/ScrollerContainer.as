package com.shrimp.framework.ui.container
{
	import com.shrimp.framework.ui.controls.HScrollBar;
	import com.shrimp.framework.ui.controls.ScrollBar;
	import com.shrimp.framework.ui.controls.VScrollBar;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.layout.BaseLayout;
	import com.shrimp.framework.ui.layout.ILayout;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ScrollerContainer extends Container
	{
		protected var _vScrollBar:VScrollBar;
		protected var _hScrollBar:HScrollBar;

		protected var _content:Container;

		public function ScrollerContainer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_content=new Container();
			_content.setActualSize(250, 250);
			_vScrollBar=new VScrollBar();
			_vScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
			_vScrollBar.target=this;
			super.addChild(_vScrollBar);
			_hScrollBar=new HScrollBar();
			_hScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
			_hScrollBar.target=this;
			super.addChild(_hScrollBar);
			super.addChildAt(_content, 0);
			onScrollBarChange();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			invalidateDisplayList();
			return _content.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			invalidateDisplayList();
			return _content.addChildAt(child, index);
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			invalidateDisplayList();
			return _content.removeChild(child);
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			invalidateDisplayList();
			;
			return _content.removeChildAt(index);
		}

		override public function set width(value:Number):void
		{
			super.width=value;
			invalidateProperties();
			;
		}

		override public function set height(value:Number):void
		{
			super.height=value;
			invalidateProperties()
		}

		override public function get numChildren():int
		{
			return _content.numChildren;
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			_content.setActualSize(contentMeasureWidth, contentMeasureHeight);

			var vShow:Boolean=_vScrollBar && _content.height > _height;
			var hShow:Boolean=_hScrollBar && _content.width > _width;
			var cw:Number=vShow ? _width - _vScrollBar.width : _width;
			var ch:Number=hShow ? _height - _hScrollBar.height : _height;
			_content.scrollRect=new Rectangle(0, 0, cw, ch);
			if (_vScrollBar)
			{
				_vScrollBar.visible=_content.height > _height;
				if (_vScrollBar.visible)
				{
					_vScrollBar.x=_width - _vScrollBar.width;
					_vScrollBar.y=0;
					_vScrollBar.height=_height - (hShow ? _hScrollBar.height : 0);
					_vScrollBar.tick=_content.height * 0.1;
					_vScrollBar.thumbPercent=ch / _content.height;
					_vScrollBar.setSliderParams(0, _content.height - ch, _vScrollBar.value);
				}
			}
			if (_hScrollBar)
			{
				_hScrollBar.visible=_content.width > _width;
				if (_hScrollBar.visible)
				{
					_hScrollBar.x=0;
					_hScrollBar.y=_height - _hScrollBar.height;
					_hScrollBar.width=_width - (vShow ? _vScrollBar.width : 0);
					_hScrollBar.thumbPercent=cw / _content.width;
					_hScrollBar.setSliderParams(0, _content.width - cw, _hScrollBar.value);
				}
			}
		}

		protected function onScrollBarChange(e:Event=null):void
		{
			var rect:Rectangle=_content.scrollRect;
			if (rect)
			{
				var scroll:ScrollBar=e.currentTarget as ScrollBar;
				var start:int=Math.round(scroll.value);
				scroll.direction == ScrollBar.VERTICAL ? rect.y=start : rect.x=start;
				_content.scrollRect=rect;
			}
		}

		/**滚动到某个位置*/
		public function scrollTo(x:Number=0, y:Number=0):void
		{
			measure();
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

		public function get contentMeasureWidth():Number
		{
			return _content.measuredWidth;
		}

		public function get contentMeasureHeight():Number
		{
			return _content.measuredHeight;
		}
	}
}
