package com.shrimp.framework.ui.controls.core
{
	import flash.filters.GlowFilter;

	/**
	 *	皮肤类 
	 * @author Sol
	 * 
	 */	
	public class Style
	{
		/**	按钮默认*/
		[Embed(source="/assets/buttons/btnNormal.png", scaleGridTop='2', scaleGridBottom='2', scaleGridLeft='2', scaleGridRight='2')]
		public static const defaultBtnNormalSkin:Class;
		/**	按钮选中*/
		[Embed(source="/assets/buttons/btnSelected.png", scaleGridTop='10', scaleGridBottom='15', scaleGridLeft='15', scaleGridRight='30')]
		public static const defaultBtnSelectedSkin:Class;
		/**	滑块*/
		[Embed(source="/assets/scrollBar/thumb.png", scaleGridTop="4", scaleGridBottom="75", scaleGridLeft="4", scaleGridRight="7")]
		public static const thumb:Class;
		/**	背景框*/
		[Embed(source="/assets/scrollBar/track.png", scaleGridTop="4", scaleGridBottom="155", scaleGridLeft="4", scaleGridRight="12")]
		public static const track:Class;
		/**	上箭头*/
		[Embed(source="/assets/scrollBar/upArrow.png")]
		public static const upArrow:Class;
		/**	下箭头*/
		[Embed(source="/assets/scrollBar/downArrow.png")]
		public static const downArrow:Class;
		/**	单选框未选中*/
		[Embed(source="/assets/radioButton/unselect.png")]
		public static const radioBtnSkin:Class;
		/**	单选框选中*/
		[Embed(source="/assets/radioButton/selected.png")]
		public static const radioBtnSelectedSkin:Class;
		/**	复选框未选中*/
		[Embed(source="/assets/checkBox/unselect.png")]
		public static const checkBoxSkin:Class;
		/**	复选框选中*/
		[Embed(source="/assets/checkBox/selected.png")]
		public static const checkBoxSelectedSkin:Class;
		/**	默认字号*/
		public static var fontSize:int = 14;
		/**	默认字体*/
		public static var fontFamily:String="Microsoft yahei";
		/**	描边颜色*/
		public static const stroke:uint=0x292317;
		/**	默认字体滤镜*/
		public static const fontFilter:Array = [new GlowFilter(stroke, 1, 2, 2, 16)];
		
		/**	文本字 颜色*/
		public static const LABEL_COLOR:uint =0xFFFFFF;
	}
}