package com.shrimp.extensions.clip.core
{
	import com.shrimp.extensions.clip.core.interfaceClass.IClip;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	
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
			invalidateRenderDirty = true;
			invalidateProperties();
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
		
		protected var _clipRender:IClipRenderer;
		public function get clipRenderer():IClipRenderer
		{
			return this._clipRender;
		}
		public function set clipRenderer($value:IClipRenderer):void
		{
			if(this._clipRender == $value) return;
			clipChanged(this._clipRender, $value);
			this._clipRender = $value;
			invalidateRenderDirty = true;
			invalidateProperties();
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
			invalidateRenderDirty = true;
			invalidateProperties();
		}
		
		public function get totalFrame():int
		{
			return (source? source.totalFrame : 0)
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
		private function setFrameIndex($value:int):void
		{
			if(this._frameIndex == $value) return;
			
			var maxFrameIndex:int = Math.max(0, totalFrame - 1);
			
			if($value > maxFrameIndex)
			{
				_repeatCount += Math.floor($value / maxFrameIndex);
				_frameIndex = $value % maxFrameIndex;
			}
			else
			{
				_frameIndex = $value;
			}
			
			if(repeat != -1 && _repeatCount >= repeat)
			{
				_frameIndex = maxFrameIndex;
				_repeatCount = repeat;
				cleanTimer(this.frameHandler);
			}
			
			_frameData = source.getFrameData(_frameIndex);
			_frameLabel = _frameData ? _frameData.frameLabel : null;
			
			invalidateRenderDirty = true;
			invalidateProperties();
		}
		
		/**
		 *预留给外部统一调用每帧更新的方法，暂时只允许内部调用
		 */		
		public function frameHandler():void
		{
			nextFrame();
		}
		
		public function play($frame:Object=null):void
		{
			_repeatCount = 0;
			this._isPlaying = true;
			
			var index:int = 0;
			if($frame is String)
			{
				index = source.getFrameIndex($frame);
			}
			else if($frame is int)
			{
				index = int($frame);
			}
			
			/**先设置当前显示的帧索引*/
			setFrameIndex(Math.max(0, index));
		}
		
		public function stop($frame:Object=null):void
		{
			if(this.isPlaying)
			{
				cleanTimer(this.frameHandler);
				this._isPlaying = false;
			}
			
			setFrameIndex(source.getFrameIndex($frame));
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
		 *下一帧 
		 * @param $frameIndex	如果$frameIndex > -1 则nextFrame为$frameIndex+1那一帧
		 */		
		protected function nextFrame($frameIndex:int = -1):void
		{
			if(!isPlaying || totalFrame < 1) return;
			
			if($frameIndex == -1)
			{
				$frameIndex = frameIndex;
			}
			
			$frameIndex = Math.max(0, $frameIndex + 1);
			
			setFrameIndex($frameIndex);
		}
		
		/**
		 *本帧执行完毕开始渲染 
		 * @param $frameData
		 */		
		protected function commitRenderData($frameData:IClipFrameData):void
		{
			if(!isPlaying) return;
			
			if(clipRenderer)
			{
				clipRenderer.data = $frameData;
			}
			
			if(frameIndex % (totalFrame -1) == 0)
			{
				repeatOnce();
			}
			
			if(_repeatCount == repeat)
			{
				repeatComplete();
			}
			
			if(isNaN(explicitWidth) || isNaN(explicitHeight))
			{
				//如果没有外部设置尺寸此处测量一下
				measure();
			}
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
			autoDestroy ? destroy() : stop();
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
		 *创建clipRender渲染器  抽象方法，子类覆盖
		 * @return IClipRenderer
		 */		
		protected function createClipRender():IClipRenderer
		{
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