package com.shrimp.framework.ui.controls.panel
{
	import com.shrimp.framework.interfaces.IPanel;
	import com.shrimp.framework.ui.container.Container;
	
	import flash.display.DisplayObjectContainer;

	/**
	 *	简单的面板容器 
	 * @author Sol
	 * 
	 */	
	public class SimplePanel extends Container implements IPanel
	{
		/**	面板数据*/
		private var _data:*;
		/**	面板是否独立于其他面板*/
		private var _standAlone:Boolean=false;
		/**	面板是否打开了*/
		private var _isOpen:Boolean;
		private var _useModal:Boolean;

		public function SimplePanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		public function show(... arg):void
		{
		}

		public function hide():void
		{
			_isOpen=false;
		}

		public function isOpen():Boolean
		{
			return _isOpen;
		}

		public function set data(value:*):void
		{
			if (_data == value)
				return;
			_data=value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set standAlone(value:Boolean):void
		{
			if (_standAlone == value)
				return;
			_standAlone=value;
		}

		public function get standAlone():Boolean
		{
			return _standAlone;
		}

		/**	是否使用模态*/
		public function get modal():Boolean
		{
			return _useModal;
		}

		public function set modal(value:Boolean):void
		{
			_useModal = value;
		}
		
		public function clean():void
		{
			
		}
		
		public function dispose():void
		{
			
		}

	}
}
