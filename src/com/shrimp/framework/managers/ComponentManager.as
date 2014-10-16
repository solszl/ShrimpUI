package com.shrimp.framework.managers
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 *	组件管理
	 * @author Sol
	 *
	 */
	public class ComponentManager
	{
		private static var _preInitComponentList:Dictionary = new Dictionary(true);
		private static var _paddingPropertyList:Dictionary = new Dictionary(true);
		private static var _paddingDisplayList:Dictionary = new Dictionary(true);
		private static var _paddingSizeList:Dictionary = new Dictionary(true);

		private static var _paddingSize:Boolean=false;
		private static var _paddingProperty:Boolean=false;
		private static var _paddingDisplay:Boolean=false;
		
		public static function addPreInitComponent(target:Component):void
		{
			if (!(target in _preInitComponentList))
			{
				requireUpdate();
				_preInitComponentList[target] = {propertiesReady:false, displayListReady:false, changeSize:false};
			}
		}

		public static function addPaddingDisplay(target:Component):void
		{
			_paddingDisplay=true
			if (!(target in _paddingDisplayList))
			{
				requireUpdate();
				_paddingDisplayList[target] = 1;
			}
		}

		public static function addPaddingProperty(target:Component):void
		{
			_paddingProperty=true;
			if (!(target in _paddingPropertyList))
			{
				requireUpdate();
				_paddingPropertyList[target] = 1;
			}
		}

		public static function addPaddingSize(target:Component):void
		{
			_paddingSize=true;
			if (!(target in _paddingSizeList))
			{
				requireUpdate();
				_paddingSizeList[target] = 1;
			}
		}

		public static function removePaddingDisplay(target:Component):void
		{
			if (target in _paddingDisplayList)
			{
				delete _paddingDisplayList[target];
			}
			if (target in _preInitComponentList)
			{
				_preInitComponentList[target]["displayListReady"] = true;
			}
		}

		public static function removePaddingProperty(target:Component):void
		{
			if (target in _paddingPropertyList)
			{
				delete _paddingPropertyList[target];
			}
			if (target in _preInitComponentList)
			{
				_preInitComponentList[target]["propertiesReady"] = true;
			}
		}

		public static function removePaddingSize(target:Component):void
		{
			if (target in _paddingSizeList)
			{
				delete _paddingSizeList[target];
			}

			if (target in _preInitComponentList)
			{
				_preInitComponentList[target]["changeSize"] = true;
			}
		}

		private static function run():void
		{
			var target:*;
			for (target in _paddingPropertyList)
			{
				target.validateProperties();
			}

			_paddingProperty=false;
			
			for (target in _paddingSizeList)
			{
				target.validateSize();
			}
			
			_paddingSize=false;

			for (target in _paddingDisplayList)
			{
				target.validateDisplayList();
			}
			
			_paddingDisplay = false;
			
			if(_paddingSize||_paddingProperty||_paddingDisplay)
			{
				trace("run again:::::",_paddingSize,_paddingProperty,_paddingDisplay);
				run();
				return;
			}

			
			for (target in _preInitComponentList)
			{
				if (_preInitComponentList[target]["displayListReady"] && _preInitComponentList[target]["propertiesReady"] && _preInitComponentList[target]["changeSize"])
				{
					target.initialized = true;
					delete _preInitComponentList[target];
				}
			}
			
			count++;
			trace(count);
		}

		private static var rn:Shape;
		private static var ispaddingUpdate:Boolean = false;

		private static function requireUpdate():void
		{
			if (!rn)
				rn = new Shape();

			if (ispaddingUpdate)
				return;

			ispaddingUpdate = true;
			rn.addEventListener(Event.RENDER,onEnterFrame);
			rn.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private static var count:int;
		private static function onEnterFrame(e:Event):void
		{
			run();
			ispaddingUpdate = false;
			rn.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			rn.removeEventListener(Event.RENDER,onEnterFrame);
		}
	}
}
