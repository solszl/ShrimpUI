package com.shrimp.framework.managers
{
	/**
	 * 
	 * @author Sol
	 * 
	 */	
	public class Controller
	{
		
		public function Controller()
		{
			initController();
		}
		
		/**	implments in subClass*/
		protected function initController():void
		{
				
		}
		
		private var _initialized:Boolean=false;
		
		/**
		 * 	是否准备好了?
		 * 	如果准备好了,则进行相应的操作,否则,将操作暂存
		 */
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function set initialized(value:Boolean):void
		{
			_initialized=value;
		}
	}
}