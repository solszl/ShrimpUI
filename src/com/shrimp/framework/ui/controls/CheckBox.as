package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.framework.utils.DisplayObjectUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 *	复选框
	 * @author Sol
	 *
	 */
	[Event(name = "selected", type = "flash.events.Event")]
	public class CheckBox extends Component
	{
		private var _label:String;

		public function CheckBox(label:String = "", parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			this._label = label;
			super(parent, xpos, ypos);
			buttonMode=true;
			useHandCursor=true;
			mouseChildren = false;
		}
		/**	复选框皮肤和文字间隔*/
		private static const gap:int = 2;
		private var icon:Button;
		private var lbl:Label;
		private var _labelChanged:Boolean = false;

		override protected function createChildren():void
		{
			super.createChildren();
			icon = new Button(this, 0, 0);
			icon.selectedSkinClass = Style.checkBoxSelectedSkin;
			icon.skinClass = Style.checkBoxSkin;
			icon.toggle = true;
			icon.validateNow();
			lbl = new Label(this, icon.width + gap, 0);
			lbl.text = this._label;
			lbl.html = true;
			lbl.validateNow();
			invalidateProperties();
			invalidateSize();
			addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onClick(event:MouseEvent):void
		{
			selected = !selected;
			var arr:Array = [];
			DisplayObjectUtils.getObjectsUnderPoint(stage,new Point(event.stageX,event.stageY),arr);
			trace(arr.join(','));
		}

		public function set selected(b:Boolean):void
		{
			if (icon.selected == b)
			{
				return;
			}
			icon.selected = b;
			icon.invalidateProperties();
			icon.invalidateSize();
			invalidateSize();
			dispatchEvent(new Event("selected"));
		}

		public function get selected():Boolean
		{
			return icon.selected;
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			lbl.move(icon.width + gap, 0);
			icon.move(0, (lbl.height - icon.height) * .5);
		}

		public function get label():String
		{
			return lbl.text;
		}

		public function set label(value:String):void
		{
			if (lbl.text == value)
				return;

			lbl.text = value;
			_labelChanged = true;

			invalidateProperties();
		}

		override protected function commitProperties():void
		{
			if (_labelChanged)
			{
				_labelChanged = false;
				lbl.validateNow();
				invalidateSize();
				invalidateDisplayList();
			}
		}

		override protected function measure():void
		{
			super.measure();
			measuredWidth = icon.width + gap + lbl.width;
			measuredHeight = Math.max(icon.height, lbl.height);
		}
	}
}
