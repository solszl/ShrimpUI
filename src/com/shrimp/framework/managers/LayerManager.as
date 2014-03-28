package com.shrimp.framework.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 *	层级管理器
	 * 	当再某一个场景内,场景规则通常为.
	 * 
	 * tips layer	提示
	 * popup layer	弹出层
	 * panel layer	面板层
	 * ui layer		场景内UI层
	 * view layer	场景背景层
	 * 
	 * 注册后, 会根据order字段进行排序.
	 * @author Sol
	 * 
	 */
	public class LayerManager
	{
		public static const LAYER_TIP:String="tips_layer";
		public static const LAYER_DIALOG:String="dialog_layer";
		public static const LAYER_PANEL:String="panel_layer";
		public static const LAYER_UI:String="ui_layer";
		public static const LAYER_VIEW:String="view_layer";

		private static var layerContent:Array=[];
		
		/**
		 *	注册层级 
		 * @param layer	层的显示对象
		 * @param order	显示次序
		 * @param name	名字
		 * 
		 */		
		public static function registLayer(layer:DisplayObject,order:int,name:String):void
		{
			layerContent.push({layer:layer,order:order,name:name});
			
			reSort();
		}
		
		public static function unregistLayerById(order:int):void
		{
			for each(var o:Object in layerContent)
			{
				if(o["order"] == order)
				{
					layerContent.splice(0,1,o);
				}
			}
			
			reSort();
		}
		
		public static function getLayerByName(name:String):DisplayObjectContainer
		{
			var result:DisplayObjectContainer;
			for each(var o:Object in layerContent)
			{
				if(o["name"]==name)
					result = o["layer"] as DisplayObjectContainer;
				break;
			}
			
			return result;
		}
		
		private static function reSort():void
		{
			layerContent.sortOn("order",Array.NUMERIC|Array.DESCENDING);
		}
	}
}