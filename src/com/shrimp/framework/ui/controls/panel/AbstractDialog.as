package com.shrimp.framework.ui.controls.panel
{
	import com.shrimp.framework.interfaces.IDialog;
	import com.shrimp.framework.managers.LayerManager;
	import com.shrimp.framework.ui.container.Container;
	import com.shrimp.framework.ui.controls.Button;
	import com.shrimp.framework.ui.controls.core.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	public class AbstractDialog extends Container implements IDialog
	{
		protected var _modal:Boolean=false;
		private var _modalChanged:Boolean=false;

		public function AbstractDialog(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		private var closeBtn:Button;
		override protected function createChildren():void
		{
			closeBtn = new Button(this);
			closeBtn.skinClass = Style.panelCloseBtn;
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		/**	显示弹框*/
		public function show(... arg):void
		{
			var dialog_layer:DisplayObjectContainer=LayerManager.getLayerByName(LayerManager.LAYER_DIALOG);
			
			if (!dialog_layer)
				throw new Error("unregistered panel layer in LayerManager");
			
			if (!dialog_layer.contains(this))
			{
				dialog_layer.addChild(this);
				x=(dialog_layer.width - width) >> 1;
				y=(dialog_layer.height - height) >> 1;
			}
			else
			{
				dialog_layer.setChildIndex(this,dialog_layer.numChildren-1);
			}
		}

		/**	隐藏弹框*/
		public function hide():void
		{
			var dialog_layer:DisplayObjectContainer=LayerManager.getLayerByName(LayerManager.LAYER_DIALOG);
			
			if (!dialog_layer)
				throw new Error("unregistered panel layer in LayerManager");
			
			if(dialog_layer.contains(this))
			{
				dialog_layer.removeChild(this);
			}
		}

		public function set modal(b:Boolean):void
		{
			_modal=b;
			_modalChanged=true;
			invalidateDisplayList();
		}

		/**	是否使用模态*/
		public function get modal():Boolean
		{
			return _modal;
		}

		/**	是否处于打开状态*/
		public function isOpen():Boolean
		{
			return visible && parent;
		}

		/**	销毁内部数据*/
		public function dispose():void
		{
			
		}
		
		/**	清理内部数据*/
		public function clean():void
		{
			
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			if (_modalChanged)
			{
				_modalChanged=false;
			}
			
			if(closeBtn)
			{
				if(closeBtn.visible)
				{
					closeBtn.move(width-closeBtn.width-15,-27);
				}
			}
		}
		
		protected function onClose(event:MouseEvent):void
		{
			hide();
		}

	}
}
