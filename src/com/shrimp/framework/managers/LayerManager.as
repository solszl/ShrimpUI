package com.shrimp.framework.managers
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

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
		/**	LAYER_TIP	提示:6*/
		public static const LAYER_TIP:String="layer_tips";
		/**	LYAER_POPUP	弹出层:5*/
		public static const LYAER_POPUP:String="layer_popup";
		/**	LAYER_DIALOG	对话框:4*/
		public static const LAYER_DIALOG:String="layer_dialog";
		/**	LAYER_PANEL	面板层:3*/
		public static const LAYER_PANEL:String="layer_panel";
		/**	LAYER_UI	UI层:2*/
		public static const LAYER_UI:String="layer_ui";
		/** LAYER_VIEW	场景层:1*/
		public static const LAYER_VIEW:String="layer_view";

		private static var layerContent:Array=[];

		/**
		 *	注册层级
		 * @param layer	层的显示对象
		 * @param order	显示次序
		 * @param name	名字
		 *
		 */
		public static function registLayer(layer:Component, order:int, name:String):void
		{
			layerContent.push({layer: layer, order: order, name: name});

			reSort();
		}

		public static function unregistLayerById(order:int):void
		{
			for each (var o:Object in layerContent)
			{
				if (o["order"] == order)
				{
					layerContent.splice(0, 1, o);
				}
			}

			reSort();
		}

		/**
		 *	根据层级名字返回容器 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getLayerByName(name:String):Component
		{
			var result:Component;
			for each (var o:Object in layerContent)
			{
				if (o["name"] == name)
				{
					result=o["layer"] as Component;
					break;
				}
			}

			return result;
		}

		private static function reSort():void
		{
			layerContent = layerContent.sortOn("order", Array.NUMERIC);
		}

		public static function resize():void
		{
			for each (var o:Object in layerContent)
			{
				(o["layer"] as Component).width=StageManager.getStageWidth();
				(o["layer"] as Component).height=StageManager.getStageHeight();
			}
		}
		
		/**	懒汉构造 层次结构
		 * <li>LAYER_VIEW:1</li>
		 * <li>LAYER_UI:2</li>
		 * <li>LAYER_PANEL:3</li>
		 * <li>LAYER_DIALOG:4</li>
		 * <li>LYAER_POPUP:5</li>
		 * <li>LAYER_TIP:6</li>
		 **/
		public static function lazyInit():void
		{
			var disobj:Component;
			disobj = new Component();
			StageManager.root.addChild(disobj);
			layerContent.push({layer: disobj, order: 1, name: LAYER_VIEW});
			disobj = new Component();
			StageManager.root.addChild(disobj);
			layerContent.push({layer: disobj, order: 2, name: LAYER_UI});
			disobj = new Component();
			StageManager.root.addChild(disobj);
			layerContent.push({layer: disobj, order: 3, name: LAYER_PANEL});
			disobj = new Component();
			StageManager.root.addChild(disobj);
			layerContent.push({layer: disobj, order: 4, name: LAYER_DIALOG});
			disobj = new Component();
			StageManager.root.addChild(disobj);
			layerContent.push({layer: disobj, order: 5, name: LYAER_POPUP});
			disobj = new Component();
			StageManager.root.addChild(disobj);
			layerContent.push({layer: disobj, order: 6, name: LAYER_TIP});
			resize();
			reSort();
		}
	}
}
