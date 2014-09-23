package com.shrimp.framework.managers.classes
{
	import com.shrimp.framework.core.ApplicationBase;
	import com.shrimp.framework.event.DragEvent;
	import com.shrimp.framework.managers.CursorManager;
	import com.shrimp.framework.managers.DragManager;
	import com.thirdparts.greensock.TweenNano;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 *	@Author				KHKim
	 *	@Version			1.2 beta
	 *	@Lanaguage			Action Script 3.0
	 *	@Date				2009.11.13
	 *	@Modify
	 *	@Description
	 */
	public class DragManagerImpl
	{
		//--------------------------------------------------------------------------
		//
		//	Class variables
		//
		//--------------------------------------------------------------------------

		private static var allowInstancing:Boolean;

		private static var uniqueInstance:DragManagerImpl;

		//--------------------------------------------------------------------------
		//
		//	Instance variables
		//
		//--------------------------------------------------------------------------

		private var dropImageScale:Number;
		private var imageAlpha:Number;
		private var origineTargetX:Number;
		private var origineTargetY:Number;
		private var origineMouseX:Number;
		private var origineMouseY:Number;
		private var origineImageAlpha:Number;

		private var feedback:String;

		private var dragging:Boolean;
		private var useDropAnimation:Boolean;

		private var dragSource:Object;

		private var dragImage:DisplayObject;
		private var dragInitiator:DisplayObject;
		private var dragTarget:DisplayObject;
		private var dropTarget:DisplayObject;

		private var stage:Stage;

		/**
		 *	@Constructor
		 */
		public function DragManagerImpl()
		{
			if (!allowInstancing)
				throw new Error("DragManagerImpl is not allowed instnacing!");

			stage=ApplicationBase.app.stage;
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
		 *	싱글톤 인스턴스를 반환한다.
		 */
		public static function getInstance():DragManagerImpl
		{
			if (!uniqueInstance)
			{
				allowInstancing=true;
				uniqueInstance=new DragManagerImpl();
				allowInstancing=false;
			}
			return uniqueInstance;
		}

		//--------------------------------------------------------------------------
		//
		//	Instance methods
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Public
		//--------------------------------------------------------------------------

		/**
		 *	드래그 드랍 타겟을 설정한다.
		 */
		public function acceptDragDrop(target:DisplayObject):void
		{
			dropTarget=target;
		}

		/**
		 *	드래그를 시작한다.
		 */
		public function doDrag(dragInitiator:DisplayObject, dragImage:DisplayObject=null, dragSource:Object=null, xOffset:Number=0, yOffset:Number=0, dropImageScale:Number=1.5, imageAlpha:Number=0.7, useDropAnimation:Boolean=true):void
		{
			removeDragImage();

			if(dragInitiator == null)
			{
				throw new IllegalOperationError("dragInitiator is null");
			}
			
			dragTarget=dragImage ? dragImage : dragInitiator;
			origineTargetX=dragTarget.x;
			origineTargetY=dragTarget.y;
			dragTarget.x+=xOffset;
			dragTarget.y+=yOffset;
			origineImageAlpha=dragTarget.alpha;
			this.dragImage=dragImage;
			this.dragInitiator=dragInitiator;
			this.dragSource=dragSource;
			this.dropImageScale=dropImageScale;
			this.imageAlpha=imageAlpha;
			this.useDropAnimation=useDropAnimation;

			setOriginePosition();
			configureListeners();
		}

		/**
		 *	현재 드래그 중인지 아닌지의 부울값
		 */
		public function isDragging():Boolean
		{
			return dragging;
		}

		/**
		 *	커서의 상태를 반환한다.
		 */
		public function getFeedback():String
		{
			return feedback;
		}

		/**
		 *	커서의 상태를 변경한다.
		 */
		public function showFeedback(feedback:String):void
		{
			this.feedback=feedback;

			if (feedback == DragManager.NONE)
				CursorManager.removeCursor();
			else
				CursorManager.setCursor(getCursorClass(feedback));
		}

		//--------------------------------------------------------------------------
		//  Internal
		//--------------------------------------------------------------------------

		private function configureListeners():void
		{
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHander, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHander, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHander, false, 0, true);
		}

		private function dispatchDragDrop():void
		{
			if (!dragging)
				return;

			if (dropTarget && dropTarget.hitTestPoint(stage.mouseX, stage.mouseY, true))
			{
				var widthTo:Number=dropTarget.width;
				var heightTo:Number=dropTarget.height;
				var point:Point=dropTarget.localToGlobal(new Point());//dropTarget.x, dropTarget.y
				var targetPoint:Point = dropTarget.globalToLocal(new Point(stage.mouseX,stage.mouseY));
//				dragTarget.width*=dropImageScale;
//				dragTarget.height*=dropImageScale;
				dragTarget.scaleX = dragTarget.scaleY = dropImageScale;
				dragTarget.x=point.x + targetPoint.x;//(dropTarget.width - dragTarget.width) / 2;
				dragTarget.y=point.y + targetPoint.y;//(dropTarget.height - dragTarget.height) / 2;

				if (useDropAnimation)
				{
					TweenNano.to(dragTarget, 0.3, {x: dragTarget.x, y: dragTarget.y,scaleX:1,scaleY:1, onComplete: removeDragImage});
					dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, dragInitiator, dragImage, dragSource));
				}
				else
				{
					dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, dragInitiator, dragImage, dragSource));
					removeDragImage();
				}
			}
			else if (feedback == DragManager.NONE)
			{
				removeDragImage();
			}
			else
			{
				TweenNano.to(dragTarget, 0.3, {x: origineTargetX, y: origineTargetY, onComplete: removeDragImage});
			}

			
			dragTarget.alpha = 1;
			dragging=false;
		}

		private function getCursorClass(feedback:String):Class
		{
			return null;
		}

		private function outofBoundX():Boolean
		{
			return stage.mouseX <= 0 || stage.mouseX >= stage.stageWidth;
		}

		private function outofBoundY():Boolean
		{
			return stage.mouseY <= 0 || stage.mouseY >= stage.stageHeight;
		}

		private function removeDragImage(data:Object=null):void
		{
			if (dragTarget)
			{
				dragTarget.alpha=origineImageAlpha;
				origineImageAlpha=NaN;
			}

			if (dragImage && stage.contains(dragImage))
				stage.removeChild(dragImage);
		}

		private function removeListeners():void
		{
			if (stage)
			{
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHander);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHander);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHander);
			}
		}

		private function released():void
		{
			removeListeners();
			CursorManager.removeCursor();
			dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE, dragInitiator, dragImage, dragSource));
			dispatchDragDrop();

			imageAlpha=origineMouseX=origineMouseY=origineTargetX=origineTargetY=NaN;
			dragTarget=dragInitiator=dropTarget=null;
			dragSource=null;
			feedback=null;
		}

		private function setCursor():void
		{
			if (!dragTarget)
				return;

			CursorManager.removeCursor();

			if (feedback == DragManager.NONE || dropTarget && dropTarget.hitTestPoint(stage.mouseX, stage.mouseY, true))
			{
				if (feedback == DragManager.MOVE)
					CursorManager.setCursor(getCursorClass(DragManager.MOVE));
			}
			else
			{
				CursorManager.setCursor(getCursorClass(DragManager.REJECT));
			}
		}

		private function setOriginePosition():void
		{
			origineMouseX=stage.mouseX;
			origineMouseY=stage.mouseY;
		}

		//--------------------------------------------------------------------------
		//
		//	Event handlers
		//
		//--------------------------------------------------------------------------

		private function mouseLeaveHander(event:Event):void
		{
			released();
		}

		private function mouseMoveHander(event:MouseEvent):void
		{
			if (!dragging)
				dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_START, dragInitiator, dragImage, dragSource));

			dragging=true;
			dragTarget.alpha=imageAlpha;

			if (dragImage && !stage.contains(dragImage))
				stage.addChild(dragImage);

			var dx:Number=stage.mouseX - origineMouseX;
			var dy:Number=stage.mouseY - origineMouseY;

			if (!outofBoundX())
				dragTarget.x+=dx;

			if (!outofBoundY())
				dragTarget.y+=dy;

			setOriginePosition();
			setCursor();

			if (!dropTarget || feedback == DragManager.NONE)
				return;

			if (dropTarget.hitTestPoint(stage.mouseX, stage.mouseY, true))
				dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_ENTER, dragInitiator, dragImage, dragSource));
			else
				dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_OVER, dragInitiator, dragImage, dragSource));
		}

		private function mouseUpHander(event:MouseEvent):void
		{
			released();
		}
	}
}
