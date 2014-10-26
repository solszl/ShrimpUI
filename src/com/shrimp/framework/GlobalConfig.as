package com.shrimp.framework
{
	/**
	 *	全局配置文件 
	 * @author Sol
	 * 
	 */	
	public class GlobalConfig
	{
		public static var ALERT_OK_LABEL:String="确定";
		public static var ALERT_CANCEL_LABEL:String="取消";
		public static var ALERT_YES_LABEL:String="是";
		public static var ALERT_NO_LABEL:String="否";
		
		/**viewstack切换页签的特效时间*/
		public static var VIEWSTACK_CHANGE_DURATION:Number=0.3;
		
		/**	slider 滑块背景颜色*/
		public static var SLIDER_HANDLE:uint=0xFFFFFF;
		public static var SLIDER_THUMB:uint=0x000000;
		
		/**	弹窗 内存持久化时间 默认5分钟*/
		public static var DIALOG_PERSISTENCE_MEMORY:int=5000;
		/**	面板内存持久化时间 默认5分钟*/
		public static var PANEL_PERSISTENCE_MEMORY:int=5000;
		
		/**	ScrollBar是否可拖拽*/
		public static var SCROLLBAR_TOUCHABLE:Boolean=true;
		
	}
}