package com.shrimp.framework.managers
{
	import com.greensock.TweenMax;
	import com.shrimp.framework.core.shrimp_internal;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 *	声音管理类
	 * @author Sol
	 *
	 */
	public class SoundManager extends EventDispatcher
	{
		private static var _instance:SoundManager;
		private static var soundPool:Dictionary;
		private static var soundChannelPool:Dictionary;

		private var sound:Sound;
		private var defaultVolume:Number=1.0;

		public function SoundManager()
		{
			super();
			if (_instance)
				throw new Error("SoundManager can not be construct");

			init();
		}

		public static function getInstance():SoundManager
		{
			if (!_instance)
				_instance=new SoundManager();

			return _instance;
		}

		private function init():void
		{
			soundPool=new Dictionary();
			soundChannelPool=new Dictionary();
		}

		/**
		 *	播放声音 
		 * @param url 音乐路径
		 * @param repeat	重复次数
		 * @param volume	声音音量大小
		 * @param len	声音从无到有的缓动时间 如0.5 则表示0.5秒后，从0达到volume值
		 * 
		 */		
		public function play(url:String, repeat:int=1, volume:Number=-1, len:Number=0):void
		{
			if (soundChannelPool[url])
			{
				shrimp_internal::play(url, repeat, volume, len);
			}
			else
			{
				sound=new Sound();
				sound.load(new URLRequest(url), new SoundLoaderContext(1000, true));
				sound.addEventListener(Event.COMPLETE, onSoundLoaded);
				sound.addEventListener(IOErrorEvent.IO_ERROR, soundCompleteListener);
			}

			function onSoundLoaded(event:Event):void
			{
				sound.removeEventListener(Event.COMPLETE, onSoundLoaded);
				soundPool[url]=sound;
				shrimp_internal::play(url, repeat, volume, len);
			}

			function soundCompleteListener(evt:Event):void
			{
				trace(evt);
			}
		}

		/**
		 *	停止指定音乐 
		 * @param url
		 * 
		 */		
		public function stop(url:String):void
		{
			if(!soundPool[url])
				return;
			
			if(!soundChannelPool[url])
				return;

			(soundChannelPool[url] as SoundChannel).stop();
		}
		
		/**
		 *	全部停止 
		 * 
		 */		
		public function stopAll():void
		{
			for each(var sc:SoundChannel in soundChannelPool)
			{
				sc.stop();
			}
		}
		
		shrimp_internal function play(url:String, repeat:int=1, volume:Number=-1, len:Number=0):void
		{
			if (!soundPool[url])
				return;

			if (soundChannelPool[url])
			{
				(soundChannelPool[url] as SoundChannel).stop();
			}
			var channel:SoundChannel=(soundPool[url] as Sound).play(0, repeat!=-1?repeat:int.MAX_VALUE);
			soundChannelPool[url]=channel;
			if (len == 0)
			{
				channel.soundTransform=new SoundTransform((volume != -1) ? volume : defaultVolume);
			}
			else
			{
				channel.soundTransform=new SoundTransform(0);
				TweenMax.to(channel, len, {volume: (volume != -1) ? volume : defaultVolume})
			}
		}
	}
}
