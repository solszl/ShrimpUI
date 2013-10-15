package com.shrimp.framework.managers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.shrimp.framework.core.ApplicationBase;
	
	import flash.display.DisplayObject;

	public class ModalController
	{

		private var modalMode:Boolean;

		private var target:DisplayObject;

		public function ModalController()
		{
		}

		public function setTarget(target:DisplayObject):void
		{
			this.target=target;
		}

		public function setModal():void
		{
			if (target)
			{
				modalMode=true;
				TweenMax.to(target,_duration/1000,{alpha:0.35,ease:Linear.easeNone});
				ApplicationBase.application.stage.focus = null;	
			}
		}

		public function removeModal():void
		{
			if (target)
			{
				modalMode=false;
				target.alpha = .35;
				TweenMax.to(target,_duration/1000,{alpha:1,ease:Linear.easeNone});
			}
		}

		public function isModal():Boolean
		{
			return modalMode;
		}

		private var _duration:uint=200;

		public function get duration():uint
		{
			return _duration;
		}

		public function set duration(value:uint):void
		{
			if (value == _duration)
				return;

			_duration=value;
		}
	}
}