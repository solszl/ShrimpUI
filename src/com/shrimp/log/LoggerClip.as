package com.shrimp.log
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;

	public class LoggerClip extends Sprite implements ILoggerClip
	{
		/**	内容最大行数*/
		private static var MAX_LINES:Number=57;//单屏19条，存留3屏
		/**	当前行数*/
		private var curLines:int = 0;
		private var mcOutput:TextField;
		private var closeBtn:TextField;
		
		private var _root:Sprite;
		private var _stage:Stage;
		public function LoggerClip(root:Sprite,stage:Stage=null):void
		{
			this._root = root;
			if(!_stage)
			{
				_stage = root.stage;
			}
			
			mcOutput = new TextField();
			mcOutput.width = 500;//_stage.stageWidth/2;
			mcOutput.height = 300;//_stage.stageHeight/2;
			
			mcOutput.x = 5;//(_stage.stageWidth - mcOutput.width)>>1
			mcOutput.y = 10;//(_stage.stageHeight-mcOutput.height)>>1
			mcOutput.multiline=true;
			mcOutput.wordWrap=true;
			addChild(mcOutput);
			
			closeBtn = new TextField;
			closeBtn.autoSize = TextFieldAutoSize.RIGHT;
			closeBtn.htmlText="<a href='event:link'>关闭</a>";
			closeBtn.mouseEnabled = true;
			var _styleSheet:StyleSheet = new StyleSheet();
			_styleSheet.setStyle("a:hover", {color: "#FFFFFF", textDecoration: "none"});
			_styleSheet.setStyle("a:link", {color: "#ffff00", textDecoration: "none"});
			_styleSheet.setStyle("a:active", {color: "#FF0000", textDecoration: "none"});
			closeBtn.styleSheet = _styleSheet;
			addChild(closeBtn);
			closeBtn.addEventListener(TextEvent.LINK,onClose);
			
			closeBtn.x = 500 - closeBtn.textWidth;
			closeBtn.y = 5;
			
			graphics.lineStyle(2,0);
			graphics.beginFill(0,.6);
			graphics.drawRoundRect(0,0,510,310,5);
			graphics.endFill();
			
			if(_stage)
			{
				onAdd2Stage(null);			
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,onAdd2Stage);
			}
		}
		
		private function onAdd2Stage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd2Stage);
			
			if(stage)
				_stage = stage;
			
			var contentitem:ContextMenuItem=new ContextMenuItem("show/hide Log");
			contentitem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onItemClick)
			var menu:ContextMenu=  _root.contextMenu;
			if(!menu)
			{
				menu = new ContextMenu();
			}
			menu.hideBuiltInItems();
			menu.customItems=menu.customItems.concat(contentitem);
			_root.contextMenu=menu;
			function onItemClick(e:ContextMenuEvent):void
			{
				toggle();
				Mouse.show();
			}
		}
		
		private function onClose(e:TextEvent):void
		{
			toggle();
		}
		
		private function toggle():void
		{
			if(this.parent)
			{
				parent.removeChild(this)
			}
			else
			{
				_stage.addChild(this);
				x = (_stage.stageWidth-this.width)>>1;
				y = (_stage.stageHeight-this.height)>>1;
			}
		}
		
		public function output(msg:String):void
		{
			if(this.curLines>MAX_LINES)
			{
				clearOutput();
			}
			this.curLines++;
			var today_date:Date=new Date();
			var date_str:String=((today_date.getMonth() + 1) + "/" + today_date.getDate() + "/" + today_date.getFullYear() + " " + today_date.getHours() + ":" + today_date.getMinutes() + ":" + today_date.getSeconds());
			this.mcOutput.htmlText +="</br>" + date_str + " " + msg;
			this.mcOutput.scrollV = this.mcOutput.maxScrollV;
		}
		
		public function clearOutput():void
		{
			this.mcOutput.text="";
			this.curLines=0;
			this.mcOutput.scrollV = this.mcOutput.maxScrollV;
		}
	}
}