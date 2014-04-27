package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *	单选框 
	 * @author Sol
	 * 
	 */
	[Event(name="selected", type="flash.events.Event")]
	public class RadioButton extends Component
	{
		private var _label:String;
		public function RadioButton(label:String="",parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			this._label=label;
			super(parent, xpos, ypos);
			mouseChildren=false;
		}
		
		/**	复选框皮肤和文字间隔*/
		private static const gap:int=2;
		private var icon:Button;
		private var lbl:Label;
		private var _labelChanged:Boolean = false;
		
		override protected function createChildren():void
		{
			super.createChildren();
			icon=new Button(this,0,0);
			icon.selectedSkinClass = Style.radioBtnSelectedSkin;
			icon.skinClass = Style.radioBtnSkin;
			icon.selected=false;
			icon.toggle = true;
			icon.validateNow();
			lbl= new Label(this,icon.width+gap,0);
			lbl.text=this._label;
			lbl.validateNow();
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			selected=true;
			dispatchEvent(new Event("selected"));
		}
		
		public function set selected(b:Boolean):void
		{
			icon.selected = b;
			icon.validateProperties();
		}
		
		public function get selected():Boolean
		{
			return icon.selected;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			lbl.move(icon.width+gap,0);
			icon.move(0,Math.abs(icon.height-lbl.height)*.5);
		}
		
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			if(_label == value) return;
			
			_label=value;
			_labelChanged = true;
			
			invalidateProperties();
		}
		override protected function commitProperties():void
		{
			if(_labelChanged)
			{
				_labelChanged = false;
				lbl.text=_label;
				lbl.validateNow();
				
				invalidateDisplayList();
			}
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredWidth = icon.width+gap+lbl.width;
			measuredHeight=Math.max(icon.height,lbl.height);
		}
	}
}