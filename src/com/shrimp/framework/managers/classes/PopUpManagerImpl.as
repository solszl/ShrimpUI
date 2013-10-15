package com.shrimp.framework.managers.classes
{
	import com.shrimp.framework.core.ApplicationBase;
	import com.shrimp.framework.managers.ModalController;
	import com.shrimp.framework.utils.ArrayList;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	public class PopUpManagerImpl
	{
		private static var _instance:PopUpManagerImpl;

		public var modalController:ModalController=new ModalController();

		private var modalList:ArrayList=new ArrayList();

		private var popUpHolder:DisplayObjectContainer;

		private var stage:Stage;

		public function PopUpManagerImpl()
		{
			if (_instance)
				throw new Error("PopUpManagerImpl is not allowed instnacing!");

			stage=ApplicationBase.application.stage;
		}

		public static function getInstance():PopUpManagerImpl
		{
			if (!_instance)
			{
				_instance=new PopUpManagerImpl();
			}
			return _instance;
		}

		public function addPopUp(popUp:DisplayObject, parent:DisplayObjectContainer=null, modal:Boolean=false):DisplayObject
		{
			return _addPopUp(popUp, parent, modal);
		}

		public function bringToFront(popUp:DisplayObject):void
		{
			if (popUp && popUp.parent)
				popUp.parent.setChildIndex(popUp, popUp.parent.numChildren - 1);
		}

		public function createPopUp(definition:Class, parent:DisplayObjectContainer=null, modal:Boolean=false):DisplayObject
		{
			var popUp:DisplayObject=DisplayObject(new definition());
			return _addPopUp(popUp, parent, modal);
		}

		public function centerPopUp(popUp:DisplayObject):void
		{
			popUp.x=Math.floor((stage.stageWidth - popUp.width) * .5);
			popUp.y=Math.floor((stage.stageHeight - popUp.height) * .5);
		}

		public function removePopUp(popUp:DisplayObject):void
		{
			if (popUp && popUp.parent)
				popUp.parent.removeChild(popUp);

			if (modalList.contains(popUp))
				modalList.removeItem(popUp);

			if (modalController.isModal() && modalList.length < 1)
			{
				ApplicationBase.application.mouseChildren=ApplicationBase.application.mouseEnabled=true;
				modalController.removeModal();
			}
		}

		private function _addPopUp(popUp:DisplayObject, parent:DisplayObjectContainer=null, modal:Boolean=false):DisplayObject
		{
			if (parent != null)
			{
				if (popUp && !parent.contains(popUp))
					parent.addChild(popUp);
			}
			else
			{
				createPopUpHolder();
				if (popUp && !popUpHolder.contains(popUp))
					popUpHolder.addChild(popUp);
			}


			if (modal)
			{
				if (!modalList.contains(popUp))
					modalList.addItem(popUp);

				ApplicationBase.application.mouseChildren=ApplicationBase.application.mouseEnabled=false;
				modalController.setTarget(ApplicationBase.application);
				modalController.setModal();
			}
			return popUp;
		}

		private function createPopUpHolder():void
		{
			if (popUpHolder && stage.contains(popUpHolder))
			{
				stage.setChildIndex(popUpHolder, stage.numChildren - 1);
			}
			else
			{
				popUpHolder=new Sprite();
				stage.addChild(popUpHolder);
			}

//			popUpHolder.width=stage.stageWidth;
//			popUpHolder.height=stage.stageHeight;
		}
	}

}
