package com.shrimp.extensions.clip
{
	import com.shrimp.extensions.clip.core.AbsClip;
	import com.shrimp.extensions.clip.core.ClipRendererManager;
	import com.shrimp.extensions.clip.core.interfaceClass.IClip;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	import com.shrimp.extensions.clip.event.ClipEvent;
	import com.shrimp.framework.managers.WorldClockManager;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**每执行一帧调度**/
	[Event(name="ClipEvent_Frame", type="com.shrimp.extensions.clip.event.ClipEvent")]
	/**每执行一个循环调度**/
	[Event(name="ClipEvent_Repeat", type="com.shrimp.extensions.clip.event.ClipEvent")]
	/**播放结束（repeat==0）调度**/
	[Event(name="ClipEvent_Complete", type="com.shrimp.extensions.clip.event.ClipEvent")]
	
	public class Clip extends AbsClip
	{
		public function Clip($source:IClipFrameDataList = null)
		{
			super();
			source = $source;
		}
		
		/**
		 *调用playe()直到添加到舞台经过的时间
		 */		
		private var passedTimer:Number = 0;
		
		/**
		 *播放开始的index 
		 */		
		private var startFrameIndex:int;
		
		/**
		 *play()方法被调用过 
		 */		
		private var playCalled:Boolean = false;
		
		/**
		 *播放 
		 * @param $frame 将要播放的起始帧 (类型【String 或 int】
		 * 							如果是int型: if($frame>totalFrame-1) $frame = $frame%(totalFrame)
		 * 									this._frameIndex = $frame%(totalFrame - 1)
		 * 							如果为null 则从当前帧开始播放
		 */		
		override public function play($frame:Object=null):void
		{
			playCalled = true;
			
			if(isPlaying) return;
			
			if(totalFrame < 1 || repeat == repeatCount) 
			{
				trace("当前总帧数为0，或者已经全部播放完毕");
				playCalled = false;
				return;
			}
			
			var startFrameIndex:int = getIndexByFrameParam($frame);
			this.passedTimer = 0;
			
			if(!enablePlay)
			{
				this.passedTimer = getTimer();
				if(!stage)
				{
					this.addEventListener(Event.ADDED_TO_STAGE,add2stage);	
				}
			}
			else
			{
				enablePlayHandler();
			}
		}
		
		override public function stop($frame:Object=null):void
		{
			playCalled = false;
			super.stop($frame);
		}
		
		/**
		 *全部条件都达成
		 * @param $e
		 */		
		private function enablePlayHandler():void
		{
			if(this.frameRate == -1)			
			{
				this.frameRate = stage.frameRate;
			}
			
			var passedFrame:int; 
			
			if(passedTimer > 0)
			{
				passedTimer = getTimer() - passedTimer;
				passedFrame = Math.floor(passedTimer/this.frameDuration);
				passedTimer = getTimer();
			}
			
			if(passedFrame > 0)
			{
				startFrameIndex += passedFrame;
			}
			
			super.play(startFrameIndex);
			startFrameIndex = 0;
			
			if(repeat == repeatCount) return;
			registTimer(this.frameHandler, this.frameDuration);
		}
		
		/**
		 *有条件未达成 
		 */		
		private function unEnablePlayHandler():void
		{
			startFrameIndex = frameIndex;
			
			if(isPlaying)
			{
				this.passedTimer = getTimer();
			}
			
			cleanTimer(this.frameHandler);
		}
		
		/**
		 *是否能播放（子类可重写放入其它限制条件）
		 * 如果！stage || ！visible || alpha ＝＝０时 不会立即播放，而是等到上述条件都满足后才会真正播放
		 * 此时虽然没有播放，但是会记录一个getTimer等到上述条件都满足后 得到一个时间差/frameDuration = 这段时间经过的帧数
		 * @return 
		 */		
		protected function get enablePlay():Boolean
		{
			return (stage && visible && alpha > 0);
		}
		
		private var enablePlayDirty:Boolean = false;
		/**
		 * enablePlay延时生效
		 * @param $oldEnablePlay 变化前的 enablePlay
		 */		
		final protected function invalidateEnablePlay($oldEnablePlay:Boolean):void
		{
			if(enablePlayDirty || $oldEnablePlay == enablePlay || !playCalled) return;
			enablePlayDirty = true;
			invalidateProperties();
		}
		
		/**
		 *添加到舞台 
		 * @param $e
		 */		
		private function add2stage($e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, add2stage);
			invalidateEnablePlay(false);
		}
		
		override public function set visible(value:Boolean):void
		{
			if(super.visible == value) return;
			var oldEnablePlay:Boolean = enablePlay;
			super.visible = value;
			invalidateEnablePlay(oldEnablePlay);
		}
		
		override public function set alpha(value:Number):void
		{
			if(super.alpha == value) return;
			var oldEnablePlay:Boolean = enablePlay;
			super.alpha = value;
			invalidateEnablePlay(oldEnablePlay);
		}
		
		//=======================================================================
		
//		override protected function commitRenderData($frameData:IClipFrameData):Boolean
//		{
//			return super.commitRenderData($frameData); 
//		}
		
		override protected function enterFrame():void
		{
			super.enterFrame();
			onDispatcher(ClipEvent.FRAME);
		}
		
		override protected function repeatOnce():void
		{
			super.repeatOnce();
			onDispatcher(ClipEvent.REPEAT);
		}
		
		override protected function repeatComplete():void
		{
			onDispatcher(ClipEvent.COMPLETE);
			super.repeatComplete();
		}
		
		override protected function sourceChanged($oldSource:IClipFrameDataList, $newSource:IClipFrameDataList):void
		{
			super.sourceChanged($oldSource, $newSource);
			
			if(!isPlaying && autoPlay)
			{
				play(this.startFrameIndex);
			}
		}
		
		//=====================================================================
		override protected function registTimer($frameFunction:Function, $frameDuration:int):void
		{
			WorldClockManager.getInstance().doLoop($frameDuration, $frameFunction);
		}
		
		override protected function cleanTimer($frameFunction:Function):void
		{
			WorldClockManager.getInstance().clearTimer($frameFunction);	
		}
		
		/**
		 *在外部没有调用 set clipRender()设置IClipRender时会调用此方法创建IClipRender 
		 * 如果在ClipRendererManager中注册了相关的IClipRenderer，请重写getClipRenderRegistKey()而不是重写此方法
		 * （推荐ClipRendererManager注册后重写getClipRenderRegistKey，因为ClipRendererManager.getClipRendererInstance使用了对象池）
		 * @return 
		 */		
		override protected function createDefaultClipRender():IClipRenderer
		{
			if(!clipRenderer)
			{
				clipRenderer = ClipRendererManager.instance.getClipRendererInstance(getClipRenderRegistKey());
			}
			return clipRenderer;
		}
		
		override protected function commitProperties():void
		{
			if(enablePlayDirty)
			{
				if(playCalled)
				{
					enablePlay?enablePlayHandler():unEnablePlayHandler();
				}
				enablePlayDirty = false;
			}
			super.commitProperties();
		}
		
		//===================================================================
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
		
		/**
		 *派发事件 
		 * @param $type 类型
		 */		
		protected function onDispatcher($type:String):void
		{
			this.dispatchEvent(new ClipEvent($type));	
		}
	}
}