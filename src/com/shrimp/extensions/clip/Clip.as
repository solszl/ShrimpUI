package com.shrimp.extensions.clip
{
	import com.shrimp.extensions.clip.core.ClipRendererManager;
	import com.shrimp.extensions.clip.core.interfaceClass.IClip;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	import com.shrimp.extensions.clip.data.ClipFrameData;
	import com.shrimp.framework.managers.WorldClockManager;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	public class Clip extends Component implements IClip
	{
		public function Clip()
		{
			super();
		}
		
		private var _isPlaying:Boolean = false;
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		private var autoPlayChanged:Boolean = false;
		private var _autoPlay:Boolean = false;
		public function get autoPlay():Boolean
		{
			return this._autoPlay;
		}
		
		public function set autoPlay($value:Boolean):void
		{
			if(this._autoPlay == $value) return;
			this._autoPlay = $value;
		}
		
		private var _autoDestroy:Boolean = false;
		public function get autoDestroy():Boolean
		{
			return this._autoDestroy;
		}
		
		public function set autoDestroy($value:Boolean):void
		{
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
				if(clipRenderer && currentFrameData)
				{
					var p:Point = this._pivot;
					if(currentFrameData.offset)
					{
						clipRenderer.move(currentFrameData.offset.x -_pivot.x, currentFrameData.offset.y -_pivot.y);
					}
					else
					{
						clipRenderer.move(-_pivot.x, -_pivot.y);
					}
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
			if(this.explicitFrameDuration == $value) return;
				
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
			if(this.repeat == 0)
			{
				cleanTimer();
			}
		}
		
		private var clipRenderDirty:Boolean = false;
		protected var _clipRender:IClipRenderer;
		public function get clipRenderer():IClipRenderer
		{
			return this._clipRender;
		}
		public function set clipRenderer($value:IClipRenderer):void
		{
			if(this._clipRender == $value) return;
			if(this._clipRender)
			{
				if(this._clipRender.self.parent)
				{
					this._clipRender.self.parent.removeChild(this._clipRender.self);
				}
				this._clipRender.destroy();
			}
			
			this._clipRender = $value;
			
			if(this._clipRender)
			{
				this.addChild(this._clipRender.self);
			}
			
			clipRenderDirty = true;
			invalidateProperties();			
		}
		
		private var clipRenderRegistKey:String = null;
		
		/**
		 * 返回注册ClipRender注册键
		 * 子类如果ClipRender类型不同可重写此方法
		 * （前提是必须用ClipRendererManager.instance.registClipRenderer注册过相应的类,如果没注册过默认返回ClipRenderer）
		 * @return 
		 */		
		protected function getClipRenderRegistKey():String
		{
			if(clipRenderRegistKey == null)
			{
				clipRenderRegistKey = getQualifiedClassName(IClip);
			}
			return clipRenderRegistKey;
		}
		
		private var _source:IClipFrameDataList;
		public function get source():IClipFrameDataList
		{
			return this._source;
		}
		
		public function set source($value:IClipFrameDataList):void
		{
			if(this._source == $value) return;
			if(_source)
			{
				_source.destroy();
			}
			this._source = $value;
			
			if(this._source && this._source.totalFrame > 0)
			{
				if(autoPlay)
				{
					play();
				}
			}
		}
		
		public function get totalFrame():int
		{
			return (source? source.totalFrame : 0)
		}
		
		private var _currentFrameIndex:int = 0;
		public function get currentFrameIndex():int
		{
			return this._currentFrameIndex;
		}
		
		/**
		 *设置当前索引 
		 * @param $value
		 */		
		private function setCurrentFrameIndex($value:int):void
		{
			if(this._currentFrameIndex == $value) return;
			
			var maxFrameIndex:int = Math.max(0, totalFrame - 1);
			
			if($value > maxFrameIndex)
			{
				_currentFrameIndex = $value % maxFrameIndex;
				
				if(repeat == -1) return;
				
				var passedLoop:int = Math.floor($value / maxFrameIndex);
				repeat -= passedLoop;
				
				if(repeat < 0)
				{
					repeat = 0;
				}
			}
			else
			{
				this._currentFrameIndex = $value;
			}
		}
		
		private var _currentFrameName:Object;
		public function get currentFrameName():Object
		{
			return this._currentFrameName;
		}
		
		/**设置当前framedata*/
		protected function setCurrentFrameData($frameData:IClipFrameData):void
		{
			if(_currentFrameData == $frameData) return;
			
			if(totalFrame > 0)
			{
				setCurrentFrameIndex(source.getFrameIndex($frameData));
			}
			
			this._currentFrameData = $frameData;
			
			if(_currentFrameData)
			{
				_currentFrameName = $frameData.frameName;
			}
			
			clipRenderDirty = true;
			invalidateProperties();
		}
		
		private var _currentFrameData:IClipFrameData;
		public function get currentFrameData():IClipFrameData
		{
			return this._currentFrameData;
		}
		
		/**
		 *一个getTimer()获取的毫秒值, 用于计算时间间隔
		 */		
		private var lastTimer:Number = 0;
		
		public function update():void
		{
			if(!isPlaying) return;
			
			/**此处设置当前帧数据*/
			setCurrentFrameData(source.getFrameDataByIndex(currentFrameIndex));
			
			/**已经过去的帧数*/
			var passedFrame:int;
			
			if(lastTimer > 0)
			{
				passedFrame = Math.floor((getTimer() - lastTimer)/ frameDuration);
			}
			
			if(passedFrame <= 0)
			{
				return;
			}
			
			/**设置当前帧Index*/
			setCurrentFrameIndex(currentFrameIndex + passedFrame);
			
			lastTimer = getTimer();
		}
		
		/**
		 *渲染 
		 * @param $frameData
		 */		
		protected function onRender($frameData:IClipFrameData):void
		{
			if(clipRenderer)
			{
				if($frameData && $frameData.offset)
				{
					clipRenderer.move($frameData.offset.x - pivot.x, $frameData.offset.y - pivot.y);
				}
				else if(pivot)
				{
					clipRenderer.move(-pivot.x, -pivot.y);
				}
				
				clipRenderer.data = $frameData;
			}
			
			if(repeat == 0)
			{
				stop();
			}
		}
		
		/**注册timer @param $startNow 立即开始*/
		protected function registTimer($startNow:Boolean):void
		{
			this._isPlaying = true;
			WorldClockManager.getInstance().doLoop(frameDuration, update);
			if($startNow)
			{
				update();	
			}
		}
		
		/**清除timer*/
		protected function cleanTimer():void
		{
			if(!isPlaying) return;
			this._isPlaying = false;
			WorldClockManager.getInstance().clearTimer(update);
		}
		
		public function play($frameName:Object=null):void
		{
			if(totalFrame < 1 || repeat == 0) 
			{
				trace("当前总帧数为0，或者repeat为0");
				return;
			}
			
			this._isPlaying = true;
			this.lastTimer = getTimer();
			
			if(!stage)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, function add2Stage($e:Event):void
				{
					$e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, add2Stage);
					startPlay($frameName);
				});
			}
			else
			{
				startPlay($frameName);
			}
		}
		
		/**
		 *startPlay 
		 * @param $e
		 */		
		private function startPlay($frameName:Object=null):void
		{
			if(frameRate == -1)
			{
				frameRate = stage.frameRate;
			}
			
			if(!isPlaying) return;
			
			if(!clipRenderer)
			{
				clipRenderer = createClipRender();
			}
			
			if($frameName && totalFrame > 0)
			{
				var cData:IClipFrameData = source.getFrameData($frameName);
				setCurrentFrameIndex(cData ? source.getFrameIndex(cData):0);
			}
			
			registTimer($frameName == null);
		}
		
		public function stop($frameName:Object=null):void
		{
			cleanTimer();
			lastTimer = getTimer();
			
			if($frameName && totalFrame > 0)
			{
				setCurrentFrameData(source.getFrameData($frameName));	
			}
		}
		
		public function pause():void
		{
			isPlaying ? stop(this.currentFrameName) : play(this.currentFrameName);
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
			
			if(_currentFrameData)
			{
				_currentFrameData = null;
			}
			
			if(_currentFrameName)
			{
				_currentFrameName = null;
			}
			
			_currentFrameIndex = -1;
		}
		
		//================================
		/**
		 *在外部没有调用 set clipRender()设置IClipRender时会调用此方法创建IClipRender 
		 * 如果在ClipRendererManager中注册了相关的IClipRenderer，请重写getClipRenderRegistKey()而不是调用此方法
		 * 子类可重写 （推荐ClipRendererManager注册后重写getClipRenderRegistKey，因为ClipRendererManager.getClipRendererInstance使用了对象池）
		 * @return 
		 */		
		protected function createClipRender():IClipRenderer
		{
			return ClipRendererManager.instance.getClipRendererInstance(getClipRenderRegistKey());
		}
		
		//================================
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(clipRenderDirty)
			{
				onRender(currentFrameData);
				
				if(repeat == 0)
				{
					autoDestroy ? destroy() : stop();
				}
				
				measure();
				
				clipRenderDirty = false;
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