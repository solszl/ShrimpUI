package com.shrimp.extensions.clip.core.interfaceClass
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public interface IClip extends IEventDispatcher
	{
		/**
		 *是否处于播放状态 
		 * @return 
		 */		
		function get isPlaying():Boolean;
		
		/**
		 *是否自动播放 默认false
		 * @return 
		 */		
		function get autoPlay():Boolean;
		function set autoPlay($value:Boolean):void;
		
		/**
		 *播放完成后是否自动销毁 默认true
		 * @return 
		 */		
		function get autoDestroy():Boolean;
		function set autoDestroy($value:Boolean):void;
		
		/**
		 *注册点 
		 * @return 
		 */		
		function get pivot():Point;
		function set pivot($value:Point):void;
		
		/**
		 *刷新频率是否以stage.frameRate为准 默认false
		 * @return 
		 */		
//		function get subjectStageFrame():Boolean;
//		function set subjectStageFrame($value:Boolean):void;
		
		/**
		 *帧率 如果不设置则默认设为 stage.frameRate;
		 * 如果设置了frameDuration 设置此参数无效,且get frameRate() 通过计算后如果不能整除则向上取整
		 * 如果subjectStageFrame = true 则 if(frameRate > stage.frameRate) {frameRate = stage.frameRate}
		 * 如果subjectStageFrame = false 则 
		 * @return 
		 */		
		function get frameRate():int;
		function set frameRate($value:int):void;
		
		/**
		 *每帧播放时间 (毫秒) 如果不设置则默认设置为 Math.floor(1000/stage.frameRate);
		 * 设置了此参数则 设置的frameRate无效
		 * 设置此参数后如果想frameRate生效请设置frameDuration=-1
		 * 如果subjectStageFrame = true 则 frameDuration <= stage.frameRate
		 * @return 
		 */		
		function get frameDuration():int;
		function set frameDuration($value:int):void;
		
		/**
		 *clip渲染器 
		 * @return 
		 */		
		function get clipRenderer():IClipRenderer;
		function set clipRenderer($value:IClipRenderer):void;
		
		/**
		 *循环播放次数 -1无线重复 
		 * 默认值= -1
		 * @return 
		 */		
		function get repeat():int;
		function set repeat($value:int):void;
		
		/**
		 *数据源 
		 * @return 
		 */		
		function get source():IClipFrameDataList;
		function set source($value:IClipFrameDataList):void;
		
		/**
		 *总帧数 
		 * @return 
		 */		
		function get totalFrame():int;
		
		/**
		 *当前帧的名称
		 * @return 
		 */		
		function get currentFrameName():Object;
		
		/**
		 *当前帧索引 
		 * @return 
		 */		
		function get currentFrameIndex():int;
		
		/**
		 *当前帧的 ClipFrameData
		 * @return 
		 */		
		function get currentFrameData():IClipFrameData;
		
		/**
		 *更新 （外部最好不要调用）
		 */		
		function update():void;
		
		/**
		 *播放 
		 * @param $frameName 从$frameName这一帧开始 
		 * 如果为null 则根据时间间隔跳帧后继续播放
		 */		
		function play($frameName:Object = null):void;
		
		/**
		 *停止 
		 * @param $frameName 停止到某帧 
		 * 如果$frameName不为空则停留在指定帧
		 * 如果$frameName为空则停留在当前帧
		 */		
		function stop($frameName:Object = null):void;
		
		/**
		 *暂停 
		 */		
		function pause():void;
		
		/**
		 *销毁 
		 */		
		function destroy():void;
	}
}