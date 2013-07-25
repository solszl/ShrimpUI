package com.shrimp.managers
{
	import com.shrimp.ui.controls.core.Component;
	
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
		private static var _preInitComponentList:Dictionary=new Dictionary(true);
		private static var _paddingPropertyList:Dictionary=new Dictionary(true);
		private static var _paddingDisplayList:Dictionary=new Dictionary(true);
		
		public static function addPreInitComponent(target:Component):void
		{
			if (!(target in _preInitComponentList))
			{
				requireUpdate();
				_preInitComponentList[target]={propertiesReady: false, displayListReady: false};
			}
		}
		
		public static function addPaddingDisplay(target:Component):void
		{
			if (!(target in _paddingDisplayList))
			{
				requireUpdate();
				_paddingDisplayList[target]=1;
			}
		}
		
		public static function addPaddingProperty(target:Component):void
		{
			if (!(target in _paddingPropertyList))
			{
				requireUpdate();
				_paddingPropertyList[target]=1;
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
				_preInitComponentList[target]["displayListReady"]=true;
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
				_preInitComponentList[target]["propertiesReady"]=true;
			}
		}
		
		private static function run():void
		{
			var target:*;
			for (target in _paddingPropertyList)
			{
				target.validateProperties();
			}
			
			for (target in _paddingDisplayList)
			{
				target.validateDisplayList();
			}
			
			for (target in _preInitComponentList)
			{
				if (_preInitComponentList[target]["displayListReady"] && _preInitComponentList[target]["propertiesReady"])
				{
					target.initialized=true;
					delete _preInitComponentList[target];
				}
			}
		}
		
		private static var rn:Shape;
		private static var ispaddingUpdate:Boolean = false;
		private static function requireUpdate():void
		{
			if(!rn) rn= new Shape();
			
			if(ispaddingUpdate) return;
			
			ispaddingUpdate = true;
//			rn.addEventListener(Event.RENDER,onEnerFrame);
			rn.addEventListener(Event.ENTER_FRAME,onEnerFrame);
			
			
		}
		private static function onEnerFrame(e:Event):void
		{
			run();
//			ispaddingUpdate = false;
//			rn.removeEventListener(Event.ENTER_FRAME,onEnerFrame);
		}
	}
}