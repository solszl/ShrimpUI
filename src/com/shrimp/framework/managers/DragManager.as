package com.shrimp.framework.managers
{
	import com.shrimp.framework.managers.classes.DragManagerImpl;

	import flash.display.DisplayObject;

	public class DragManager
	{
		/**
		 *  Constant that specifies that the type of drag action is "none".
		 */
		public static const NONE:String="none";

		/**
		 *  Constant that specifies that the type of drag action is "copy".
		 */
		public static const COPY:String="copy";

		/**
		 *  Constant that specifies that the type of drag action is "move".
		 */
		public static const MOVE:String="move";

		/**
		 *  Constant that specifies that the type of drag action is "link".
		 */
		public static const LINK:String="link";

		/**
		 *  Constant that specifies that the type of drag action is "reject".
		 */
		public static const REJECT:String="reject";

		/**
		 *	@Constructor
		 */
		public function DragManager()
		{
			throw new Error("DragManager is not allowed instnacing!");
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Public
		//--------------------------------------------------------------------------

		/**
		 *	드래그 드랍 타겟을 설정한다.
		 */
		public static function acceptDragDrop(target:DisplayObject):void
		{
			DragManagerImpl.getInstance().acceptDragDrop(target);
		}

		/**
		 *	드래그를 시작한다.
		 */
		public static function doDrag(dragInitiator:DisplayObject, dragImage:DisplayObject=null, dragSource:Object=null, xOffset:Number=0, yOffset:Number=0, dropImageScale:Number=1.5, imageAlpha:Number=0.7, useDropAnimation:Boolean=true):void
		{
			DragManagerImpl.getInstance().doDrag(dragInitiator, dragImage, dragSource, xOffset, yOffset, dropImageScale, imageAlpha, useDropAnimation);
		}

		/**
		 *	현재 드래그 중인지 아닌지의 부울값
		 */
		public static function isDragging():Boolean
		{
			return DragManagerImpl.getInstance().isDragging();
		}

		/**
		 *	커서의 상태를 반환한다.
		 */
		public static function getFeedback():String
		{
			return DragManagerImpl.getInstance().getFeedback();
		}

		/**
		 *	커서의 상태를 변경한다.
		 */
		public static function showFeedback(feedback:String):void
		{
			DragManagerImpl.getInstance().showFeedback(feedback);
		}
	}
}
