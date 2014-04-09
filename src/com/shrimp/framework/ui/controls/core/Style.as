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
		[Embed(source="/assets/buttons/btnNormal.png", scaleGridTop='8', scaleGridBottom='12', scaleGridLeft='18', scaleGridRight='22')]
		public static const defaultBtnNormalSkin:Class;
		/**	按钮选中*/
		[Embed(source="/assets/buttons/btnSelected.png", scaleGridTop='10', scaleGridBottom='15', scaleGridLeft='15', scaleGridRight='30')]
		public static const defaultBtnSelectedSkin:Class;
		/**	滑块*/
		[Embed(source="/assets/scrollBar/thumb.png", scaleGridTop='7', scaleGridBottom='10', scaleGridLeft='7', scaleGridRight='10')]
		public static const thumb:Class;
		/**	背景框*/
		[Embed(source="/assets/scrollBar/track.png")]
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
		/**	Alert背景*/
		[Embed(source="/assets/alertbg.png")]
		public static const alertBG:Class;
		/**	选项卡普通 */
		[Embed(source="/assets/tab/tab_nomal.png")]
		public static const tabNormal:Class;
		/**	选项卡 选中 */
		[Embed(source="/assets/tab/tab_selected.png")]
		public static const tabSelected:Class;
		/**	面板关闭按钮*/
		[Embed(source="/assets/buttons/closeBtn.png")]
		public static const panelCloseBtn:Class;

		/**	默认字号*/
		public static var fontSize:int=14;
		/**	默认字体*/
		public static var fontFamily:String="Microsoft Yahei";
		/**	描边颜色*/
		public static const stroke:String="0x292317,1,2,2,16,1"; //color,alpha,blurX,blurY,strength,quality

		/**	文本字 颜色*/
		public static const LABEL_COLOR:uint=0xFFFFFF;
	}
}
