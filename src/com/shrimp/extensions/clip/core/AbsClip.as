package com.shrimp.extensions.clip.core
{
	import com.shrimp.extensions.clip.core.interfaceClass.IClip;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	import com.shrimp.extensions.clip.event.ClipEvent;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	use namespace clip_internal;
	
	/**
	 *Clip抽象类 
	 * @author yeah
	 */	
	public class AbsClip extends Component implements IClip
	{
		public function AbsClip()
		{
			super();
		}
		
		private var _isPlaying:Boolean = false;
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		private var _autoPlay:Boolean = false;
		public function get autoPlay():Boolean
		{
			return this._autoPlay;
		}
		
		public function set autoPlay($value:Boolean):void
		{
			if(this._autoPlay == $value) return;
			this._autoPlay = $value;
			//应该是在setSource的时候做自动播放
		}
		
		private var _autoDestroy:Boolean = false;
		public function get autoDestroy():Boolean
		{
			return this._autoDestroy;
		}
		
		public function set autoDestroy($value:Boolean):void
		{
			if(this._autoDestroy == $value) return;
			this._autoDestroy = $value;
		}
		
		private var _pivot:Point;
		public function get pivot():Point
		{
			return this._pivot;
		}
		
		public function set pivot($value:Point):void
		{
			if(!$value) 
			{
				$value = new Point();
			}
			
			if(!_pivot || _pivot.x != $value.x || _pivot.y != $value.y)
			{
				this._pivot = $value;
				
				if(clipRenderer)
				{
					clipRenderer.move(-this._pivot.x, -this._pivot.y);	
				}
			}
		}
		
		private var _frameRate:int = -1;
		public function get frameRate():int
		{
			return this._frameRate;
		}
		
		public function set frameRate($value:int):void
		{
			if(this.explicitFrameDuration != -1 || this._frameRate == $value) return;
			this._frameRate = $value;
			this._frameDuration = Math.floor(1000/_frameRate);
		}
		
		/**frameDuration外部设置的 -1则认为没设置*/
		private var explicitFrameDuration:int = -1;
		
		private var _frameDuration:int = -1;
		public function get frameDuration():int
		{
			return this._frameDuration;
		}
		
		public function set frameDuration($value:int):void
		{
			if(this._frameDuration == $value) return;
				
			this.explicitFrameDuration = $value;
			
			if(this.explicitFrameDuration != -1)
			{
				this._frameDuration = this.explicitFrameDuration;
				this._frameRate = Math.ceil(1000/this._frameDuration);
			}
			else
			{
				this._frameDuration = Math.floor(1000/this.frameRate);
			}
		}
		
		private var _repeat:int = -1;
		public function get repeat():int
		{
			return this._repeat;
		}
		
		public function set repeat($value:int):void
		{
			if(this._repeat == $value) return;
			this._repeat = $value;
		}
		
		private var _repeatCount:int = 0;
		public function get repeatCount():int
		{
			return this._repeatCount;
		}
		
		/**
		 *需要渲染的标志 
		 */		
		private var invalidateRenderDirty:Boolean = false;
		
		/**
		 *渲染延时生效 
		 */		
		private function invalidateRender():void
		{
			if(!clipRenderer || clipRenderer.data == frameData) return;
			invalidateRenderDirty = true;
			invalidateProperties();
		}
		
		private var _clipRender:IClipRenderer;
		public function get clipRenderer():IClipRenderer
		{
			return this._clipRender;
		}
		public function set clipRenderer($value:IClipRenderer):void
		{
			if(this._clipRender == $value) return;
			clipChanged(this._clipRender, $value);
			this._clipRender = $value;
			invalidateRender();
		}
		
		private var _source:IClipFrameDataList;
		public function get source():IClipFrameDataList
		{
			return this._source;
		}
		
		public function set source($value:IClipFrameDataList):void
		{
			if(this._source == $value) return;
			sourceChanged(this._source, $value);
			this._source = $value;
			_totalFrame = source? source.totalFrame : 0;
			invalidateRender();
		}
		
		
		clip_internal var _totalFrame:int = 0;
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		private var _frameIndex:int = -1;
		public function get frameIndex():int
		{
			return this._frameIndex;
		}
		
		private var _frameLabel:String;
		public function get frameLabel():String
		{
			return this._frameLabel;
		}
		
		private var _frameData:IClipFrameData;
		public function get frameData():IClipFrameData
		{
			return this._frameData;
		}
		
		/**
		 *设置当前索引 
		 * @param $value
		 */		
		clip_internal function setFrameIndex($value:int):void
		{
			if(this._frameIndex == $value) return;
			
			var maxFrameIndex:int = Math.max(0, totalFrame - 1);
			var isRepeat:Boolean = false;
			var isComplete:Boolean = false; 
			
			if($value >= maxFrameIndex)
			{
				_repeatCount += Math.floor($value/maxFrameIndex);
				$value = $value % totalFrame;
				isRepeat = true;
				
				if(repeat != -1 && repeatCount >= repeat)
				{
					$value = maxFrameIndex;
					_repeatCount = repeat;
					isComplete = true;
				}
			}
			
			this._frameIndex = $value;
			
			_frameData = source.getFrameData(_frameIndex);
			_frameLabel = _frameData ? _frameData.frameLabel : null;
			
			enterFrame();
			
			if(isRepeat)
			{
				repeatOnce();
				
				if(isComplete)
				{
					repeatComplete();
					return;
				}
			}
			
			invalidateRender();
		}
		
		/**
		 *预留给外部统一调用每帧更新的方法，暂时只允许内部调用
		 */		
		public function frameHandler():void
		{
			nextFrame(frameIndex);
		}
		
		/**
		 *播放 
		 * @param $frame 将要播放的起始帧 (类型【String 或 int】
 		* 									则$frame可以大于totalFrame 并且repeatCount += int($frame)/(totalFrame-1))
 		* 									this._frameIndex = $frame%(totalFrame)
		 * 							如果为null 则从当前帧开始播放
		 */		
		public function play($frame:Object=null):void
		{
			if(totalFrame < 1) return;
			
			var index:int = getIndexByFrameParam($frame);
			this._isPlaying = true;
			createDefaultClipRender();
			
			/**先设置当前显示的帧索引*/
			setFrameIndex(index);
			invalidateRender();
		}
		
		/**
		 *根据 $frame 参数 返回index 
		 * @param $frame
		 */		
		protected function getIndexByFrameParam($frame:Object):int
		{
			if(totalFrame < 1) 
			{
				throw new Error("数据源中不存在$frame:" + $frame);
			}
			
			var index:int = 0;
			
			if($frame is int)
			{
				index = int($frame);
			}
			else if($frame != null)
			{
				index = source.getFrameIndex($frame);
			}
			
			if(index == -1)
			{
				throw new Error("数据源中不存在$frame:" + $frame);
			}
			
			return index;
		}
		
		public function stop($frame:Object=null):void
		{
			if(isPlaying)
			{
				cleanTimer(this.frameHandler);
			}
			
			var index:int = getIndexByFrameParam($frame);
			
			createDefaultClipRender();
			
			if(index != -1)
			{
				setFrameIndex(index);
			}
			invalidateRender();
			this._isPlaying = false;
		}
		
		public function pause():void
		{
			isPlaying ? stop(this.frameIndex) : play(this.frameIndex);
		}
		
		public function destroy():void
		{
			stop();
			
			if(source)
			{
				source.destroy();
			}
			
			if(clipRenderer)
			{
				clipRenderer = null;
			}
			
			if(_frameData)
			{
				_frameData = null;
			}
			
			if(_frameLabel)
			{
				_frameLabel = null;
			}
			
			_frameIndex = -1;
			_repeatCount = 0;
		}
		
		//================================
		/**
		 *$frameIndex的下一帧 
		 * @param $frameIndex
		 */		
		protected function nextFrame($frameIndex:int):void
		{
			if(!isPlaying || totalFrame < 1) return;
			
			if($frameIndex == -1)
			{
				$frameIndex = frameIndex;
			}
			$frameIndex++;
			
			if($frameIndex > totalFrame - 1)
			{
				$frameIndex = 0;
			}
			
			setFrameIndex($frameIndex);
		}
		
		/**
		 *本帧执行完毕开始渲染 
		 * @param $frameData
		 * return 是否提交成功
		 */		
		protected function commitRenderData($frameData:IClipFrameData):Boolean
		{
			var commitSuccess:Boolean = false;
			if(clipRenderer && clipRenderer.data != $frameData)
			{
				commitSuccess = true;
				clipRenderer.data = $frameData;
				
				//此处可以派发 提交属性成功 的事件
				
				if(isNaN(explicitWidth) || isNaN(explicitHeight))
				{
					//如果没有外部设置尺寸此处测量一下
					measure();
				}
			}
			return commitSuccess;
		}
		
		/**
		 *一帧 
		 */		
		protected function enterFrame():void
		{
		}
		
		/**
		 *一次循环 
		 */		
		protected function repeatOnce():void
		{
		}
		
		/**
		 *如果repeat ！= -1 ，当所循环次数repeatCount=repeat时调度 
		 */		
		protected function repeatComplete():void
		{
			autoDestroy ? destroy() : stop(totalFrame - 1);
		}
		
		/**
		 *source 发生改变 
		 * @param $oldSource
		 * @param $newSource
		 */		
		protected function sourceChanged($oldSource:IClipFrameDataList, $newSource:IClipFrameDataList):void
		{
			if($oldSource)
			{
				$oldSource.destroy();
			}
			_repeatCount = 0;
		}
		
		/**
		 *clipRender 改变 
		 * @param $oldClip		旧的clipRender
		 * @param $newClip		新的clipRender
		 */		
		protected function clipChanged($oldClip:IClipRenderer, $newClip:IClipRenderer):void
		{
			if($oldClip)
			{
				if($oldClip.self.parent)
				{
					$oldClip.self.parent.removeChild($oldClip.self);
				}
				$oldClip.destroy();
			}
			
			if($newClip)
			{
				if(this.pivot)
				{
					$newClip.move(-this.pivot.x, -this.pivot.y);	
				}
				this.addChild($newClip.self);
			}
		}
		
		/**
		 * 注册timer 抽象方法，子类覆盖
		 * @param $frameFunction		clip每个frameRate调用的方法
		 * @param $frameDuration		clip每个frameRate时间间隔（frameDuration）
		 */		
		protected function registTimer($frameFunction:Function, $frameDuration:int):void
		{
			throw new IllegalOperationError("registTimer 方法 必须被重写");
		}
		
		/**
		 * 清除timer 抽象方法，子类覆盖
		 * @param $frameFunction		clip每个frameRate调用的方法
		 */		
		protected function cleanTimer($$frameFunction:Function):void
		{
			throw new IllegalOperationError("cleanTimer 方法 必须被重写");
		}
		
		/**
		 *创建默认clipRender渲染器并赋值给clipRender  抽象方法，子类覆盖
		 * @return IClipRenderer
		 */		
		protected function createDefaultClipRender():IClipRenderer
		{
			if(clipRenderer) return clipRenderer
			throw new IllegalOperationError("createClipRender 方法 必须被重写");
		}
		
		//================================
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(invalidateRenderDirty)
			{
				commitRenderData(frameData);
				invalidateRenderDirty = false;
			}
		}
		
		override protected function measure():void
		{
			if(_clipRender)
			{
				measuredWidth = _clipRender.width;
				measuredHeight = _clipRender.height;
			}
			else
			{
				measuredWidth = 0;
				measuredHeight = 0;
			}
		}
	}
}