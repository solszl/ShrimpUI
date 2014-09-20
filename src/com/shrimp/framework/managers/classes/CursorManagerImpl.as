package com.shrimp.framework.managers.classes
{

	import com.shrimp.framework.core.ApplicationBase;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class CursorManagerImpl
	{

		private static var _instance:CursorManagerImpl;

		private var BUSY_CURSOR:Class;


		private var xOffset:Number;
		private var yOffset:Number;

		private var cursorClass:Class;
		private var cursor:DisplayObject;

		private var stage:Stage;

		public function CursorManagerImpl()
		{
			if (_instance)
				throw new Error("CursorManagerImpl is not allowed instnacing!");

			stage=ApplicationBase.app.stage;
		}

		public static function getInstance():CursorManagerImpl
		{
			if (!_instance)
			{
				_instance=new CursorManagerImpl();
			}
			return _instance;
		}

		public function removeBusyCursor():void
		{
			removeCursor();
		}

		public function removeCursor():void
		{
			if (cursor && stage && stage.contains(cursor))
			{
				stage.removeChild(cursor);
				removeListeners();
				Mouse.show();

				cursor=null;
				cursorClass=null;
				xOffset=yOffset=NaN;
			}
		}

		public function setBusyCursor():void
		{
			setCursor(getBusyCursorClass());
		}

		public function setCursor(cursorClass:Class, xOffset:Number=0, yOffset:Number=0):void
		{
			if (cursor || cursorClass == this.cursorClass)
				return;

			this.cursorClass=cursorClass;
			this.xOffset=xOffset;
			this.yOffset=yOffset;

			if (cursorClass)
			{
				createCursor();
				configureListeners();
				Mouse.hide();
			}
		}

		private function configureListeners():void
		{
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
				stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			}
		}

		private function createCursor():void
		{
			if (!cursor)
			{
				cursor=DisplayObject(new cursorClass());
				cursor.x=stage.mouseX + xOffset;
				cursor.y=stage.mouseY + yOffset;
				InteractiveObject(cursor).mouseEnabled=false;
				stage.addChild(cursor);
			}
		}

		private function getBusyCursorClass():Class
		{
			return BUSY_CURSOR;
		}

		private function removeListeners():void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			}
		}

		private function mouseLeaveHandler(event:Event):void
		{
			if (cursor)
			{
				Mouse.show();
				cursor.visible=false;
			}
		}

		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (cursor)
			{
				Mouse.hide();
				cursor.x=stage.mouseX + xOffset;
				cursor.y=stage.mouseY + yOffset;
				cursor.visible=true;
			}
		}
	}

}
