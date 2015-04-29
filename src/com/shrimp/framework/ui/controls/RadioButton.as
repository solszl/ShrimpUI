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
	[Event(name = "selected", type = "flash.events.Event")]
	public class RadioButton extends Component
	{
		private var _label:String = "";

		public function RadioButton(label:String = "", parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			this.label = label;
		}

		override protected function preInit():void
		{
			super.preInit();
			mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
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
			icon.selectedSkinClass = Style.radioBtnSelectedSkin;
			icon.skinClass = Style.radioBtnSkin;
			icon.selected = false;
			icon.toggle = true;
			icon.validateNow();

			lbl = new Label(this, icon.width + gap, 0);
			lbl.text = this._label;
			lbl.invalidateSize();
			invalidateProperties();
			invalidateSize();
			addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onClick(event:MouseEvent):void
		{
			selected = true;
			if (hasEventListener("selected"))
			{
				dispatchEvent(new Event("selected"));
			}
		}

		/**	手动设定RadioButton选中,该选中不抛出"selected"事件*/
		public function set selected(b:Boolean):void
		{
			if (icon.selected == b)
			{
				return;
			}
			icon.selected = b;
			icon.invalidateProperties();
			icon.invalidateSize();
		}

		public function get selected():Boolean
		{
			return icon.selected;
		}

		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			lbl.move(icon.width + gap, 0);
			icon.move(0, Math.abs(icon.height - lbl.height>>1));
		}

		public function get label():String
		{
			return lbl.text;
		}

		/**
		 *	设置RadioButton文本域文字 
		 * @param value	文本域文字 
		 * 
		 */		
		public function set label(value:String):void
		{
			if (_label == value)
				return;

			_label = value;
			_labelChanged = true;
			lbl.text = value;
			invalidateProperties();
			invalidateSize();
		}

		override protected function commitProperties():void
		{
			if (_labelChanged)
			{
				_labelChanged = false;
				lbl.validateNow();
				invalidateSize();
			}
		}

		override protected function measure():void
		{
			super.measure();
//			if(icon.width==0)
//			{
////				trace("!!!");
//				icon.validateSize();
//			}
			measuredWidth = icon.width + gap + lbl.width;
			measuredHeight = Math.max(icon.height, lbl.height);
		}

		public function set normalSkin(skin:Object):void
		{
			icon.skinClass = skin;
			invalidateProperties();
			invalidateSize();
		}

		public function set selectedSkin(skin:Object):void
		{
			icon.selectedSkinClass = skin;
			invalidateProperties();
			invalidateSize();
		}

	}
}
