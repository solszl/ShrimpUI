package com.shrimp.framework.managers
{
	import com.shrimp.framework.managers.classes.CursorManagerImpl;

	public class CursorManager
	{
		public function CursorManager()
		{
			throw new Error("CursorManager is not allowed instnacing!");
		}

		public static function removeCursor():void
		{
			CursorManagerImpl.getInstance().removeCursor();
		}

		public static function removeBusyCursor():void
		{
			CursorManagerImpl.getInstance().removeBusyCursor();
		}

		public static function setBusyCursor():void
		{
			CursorManagerImpl.getInstance().setBusyCursor();
		}

		public static function setCursor(cursorClass:Class, xOffset:Number=0, yOffset:Number=0):void
		{
			CursorManagerImpl.getInstance().setCursor(cursorClass, xOffset, yOffset);
		}
	}

}