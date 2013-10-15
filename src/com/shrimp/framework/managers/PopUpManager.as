package com.shrimp.framework.managers
{
	import com.shrimp.framework.managers.classes.PopUpManagerImpl;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class PopUpManager
	{
		public function PopUpManager()
		{
			throw new Error("PopUpManager is not allowed instnacing!");
		}

		public static function addPopUp(popUp:DisplayObject, parent:DisplayObjectContainer=null, modal:Boolean=false):DisplayObject
		{
			return PopUpManagerImpl.getInstance().addPopUp(popUp, parent, modal);
		}

		public static function bringToFront(popUp:DisplayObject):void
		{
			PopUpManagerImpl.getInstance().bringToFront(popUp);
		}

		public static function createPopUp(definition:Class, parent:DisplayObjectContainer=null, modal:Boolean=false):DisplayObject
		{
			return PopUpManagerImpl.getInstance().createPopUp(definition, parent, modal);
		}

		public static function centerPopUp(popUp:DisplayObject):void
		{
			PopUpManagerImpl.getInstance().centerPopUp(popUp);
		}

		public static function removePopUp(popUp:DisplayObject):void
		{
			PopUpManagerImpl.getInstance().removePopUp(popUp);
		}
	}

}