package com.shrimp.framework.managers.classes
{

	public class ToolTipManagerImpl
	{
		private static var _instance:ToolTipManagerImpl;

		public function ToolTipManagerImpl()
		{
			if (_instance)
				throw new Error("CursorManagerImpl is not allowed instnacing!");
		}
		
		public static function getInstance():ToolTipManagerImpl
		{
			if (!_instance)
			{
				_instance=new ToolTipManagerImpl();
			}
			return _instance;
		}
	}
}
