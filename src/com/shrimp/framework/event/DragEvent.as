package com.shrimp.framework.event
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class DragEvent extends Event
	{

		public static const DRAG_COMPLETE:String="dragComplete";
		public static const DRAG_ENTER:String="dragEnter";
		public static const DRAG_DROP:String="dragDrop";
		public static const DRAG_OVER:String="dragOver";
		public static const DRAG_START:String="dragStart";


		public function DragEvent(type:String, dragInitiator:DisplayObject, dragImage:DisplayObject, dragSource:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);

			_dragInitiator=dragInitiator;
			_dragImage=dragImage;
			_dragSource=dragSource;
		}

		override public function clone():Event
		{
			return new DragEvent(type, dragInitiator, dragImage, dragSource, bubbles, cancelable);
		}

		private var _dragInitiator:DisplayObject;

		public function get dragInitiator():DisplayObject
		{
			return _dragInitiator;
		}

		//--------------------------------------
		//	dragImage
		//--------------------------------------

		private var _dragImage:DisplayObject;

		public function get dragImage():DisplayObject
		{
			return _dragImage;
		}

		//--------------------------------------
		//	dragSource
		//--------------------------------------

		private var _dragSource:Object;

		public function get dragSource():Object
		{
			return _dragSource;
		}
	}
}
