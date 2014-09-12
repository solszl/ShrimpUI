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
		 *帧率 如果不设置则默认设为 stage.frameRate;
		 * 如果设置了frameDuration 设置此参数无效,且get frameRate() 通过计算后如果不能整除则向上取整
		 * @return 
		 */		
		function get frameRate():int;
		function set frameRate($value:int):void;
		
		/**
		 *每帧播放时间 (毫秒) 如果不设置则默认设置为 Math.floor(1000/stage.frameRate);
		 * 设置了此参数则 设置的frameRate无效
		 * 设置此参数后如果想frameRate生效请设置frameDuration=-1
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
		 * 
		 * 当设置repeat = 0 时会调用stop(); 停止播放
		 * @return 
		 */		
		function get repeat():int;
		function set repeat($value:int):void;
		
		/**
		 *已经循环的次数 
		 * @return 
		 */		
		function get repeatCount():int;
		
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
		 *当前帧标签
		 * @return 
		 */		
		function get frameLabel():String;
		
		/**
		 *当前帧索引 
		 * @return 
		 */		
		function get frameIndex():int;
		
		/**
		 *当前帧的数据
		 */		
		function get frameData():IClipFrameData;
		
		/**
		 *每帧调用的方法
		 */		
		function frameHandler():void;
		
		/**
		 *播放 
		 * @param $frame 将要播放的起始帧 (类型【String 或 int】)
		 * 							如果为null 则之前的时间间隔跳帧后继续播放
		 */		
		function play($frame:Object = null):void;
		
		/**
		 *停止 
		 * @param $frame 	将要停止到的帧 (类型【String 或 int】)
		 * 								如果为null 则停留在$frame帧
		 * 								如果不为null 则停留在当前显示的帧
		 */		
		function stop($frame:Object = null):void;
		
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