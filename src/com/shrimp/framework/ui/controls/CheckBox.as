package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 *	复选框 
	 * @author Sol
	 * 
	 */	
	public class CheckBox extends Component
	{
		private var _label:String;
		public function CheckBox(label:String="",parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			this._label = label;
			super(parent, xpos, ypos);
		}
		/**	复选框皮肤和文字间隔*/
		private static const gap:int=2;
		private var icon:Button;
		private var label:Label;
		override protected function createChildren():void
		{
			super.createChildren();
			icon=new Button(this,0,0);
			icon.skinClass = Style.checkBoxSkin;
			icon.selectedSkinClass = Style.checkBoxSelectedSkin;
			icon.toggle = true;
			icon.validateNow();
			label= new Label(this,icon.width+gap,0);
			label.text=this._label;
			label.validateNow();
		}
		
		public function set selected(b:Boolean):void
		{
			icon.selected = b;
		}
		
		public function get selected():Boolean
		{
			return icon.selected;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			label.move(icon.width+gap,0);
		}
	}
}