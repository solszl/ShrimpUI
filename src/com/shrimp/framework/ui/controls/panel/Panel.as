package com.shrimp.framework.ui.controls.panel
{
	import com.shrimp.framework.managers.LayerManager;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObjectContainer;

	/**
	 *	面板类
	 * @author Sol
	 *
	 */
	public class Panel extends AbstractPanel
	{
		public function Panel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override public function hide():void
		{
			var panel_layer:Component=LayerManager.getLayerByName(LayerManager.LAYER_PANEL);
			if (panel_layer && panel_layer.contains(this))
			{
				panel_layer.removeChild(this);
				onCloseBtnClick(null);
			}
		}

		override public function isOpen():Boolean
		{
			return visible && parent;
		}

		override public function show(... arg):void
		{
			var panel_layer:Component=LayerManager.getLayerByName(LayerManager.LAYER_PANEL);

			if (!panel_layer)
				throw new Error("unregistered panel layer in LayerManager");

			if (!panel_layer.contains(this))
			{
				panel_layer.addChild(this);
				if (_autoCenter)
				{
					x=Math.round((panel_layer.width - width) >> 1);
					y=Math.round((panel_layer.height - height) >> 1);
				}
			}
			else
			{
				visible=true;
				panel_layer.setChildIndex(this, panel_layer.numChildren - 1);
			}
			
			invalidateDisplayList();
		}
	}
}
