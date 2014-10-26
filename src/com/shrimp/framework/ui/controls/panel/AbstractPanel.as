package com.shrimp.framework.ui.controls.panel
{
	import com.shrimp.framework.interfaces.IPanel;
	import com.shrimp.framework.managers.PanelManager;
	import com.shrimp.framework.ui.container.Box;
	import com.shrimp.framework.ui.controls.Button;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.framework.utils.ClassUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;

	/**
	 *	面板抽象类
	 * @author Sol
	 *
	 */
	public class AbstractPanel extends SimplePanel implements IPanel
	{

		protected var contentHolder:Box;
		protected var _showCloseBtn:Boolean;
		protected var _closeBtn:Button;

		protected var _autoCenter:Boolean=true;

		public function AbstractPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			contentHolder=new Box();
			super.addChildAt(contentHolder, 0);
		}

		override public function hide():void
		{
			throw new Error("Abstract method:this method must be implemented in subClass");
		}

		override public function isOpen():Boolean
		{
			throw new Error("Abstract method:this method must be implemented in subClass");
			return false;
		}

		override public function show(... arg):void
		{
			throw new Error("Abstract method:this method must be implemented in subClass");
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			return contentHolder.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return contentHolder.addChildAt(child, index);
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return contentHolder.removeChild(child);
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			return contentHolder.removeChildAt(index);
		}

		override public function set children(value:Vector.<DisplayObject>):void
		{
			contentHolder.children=value;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();

			contentHolder.setActualSize(_explicitWidth, _explicitHeight);

			if (_showCloseBtn)
			{
				_closeBtn.move(_width - _closeBtn.width, -27);
			}
		}

		/**	是否显示关闭按钮*/
		public function get showCloseBtn():Boolean
		{
			return _showCloseBtn;
		}

		public function set showCloseBtn(value:Boolean):void
		{
			_showCloseBtn=value;
			if (_closeBtn)
			{
				_closeBtn.visible=_showCloseBtn;
			}
			else
			{
				_closeBtn=new Button();
				_closeBtn.skinClass=Style.panelCloseBtn;
				super.addChild(_closeBtn);
				_closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
			}
		}

		protected function onCloseBtnClick(event:MouseEvent):void
		{
			hide();
		}

	}
}
