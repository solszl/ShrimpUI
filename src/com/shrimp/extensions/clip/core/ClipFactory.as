package com.shrimp.extensions.clip.core
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import com.shrimp.extensions.clip.core.interfaceClass.IClip;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipDataParser;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;

	/**
	 *clip工厂 
	 * @author yeah
	 */	
	public class ClipFactory extends RecycleManger
	{
		/**
		 *创建Clip
		 * @param $class
		 * @param $data
		 * @return 
		 */		
		public function create($class:Class, $data:Object = null):IClip
		{
			var key:String = getQualifiedClassName($class);
			var clip:IClip = getValue(key) as IClip;
			
			if(!clip)
			{
				clip = new $class() as IClip;
			}
			
			if(clip)
			{
				setClip(clip, $data);
				
				clip.addEventListener(Event.REMOVED_FROM_STAGE, function recycleClip($e:Event):void
				{
					clip.stop();
					clip.removeEventListener(Event.REMOVED_FROM_STAGE, recycleClip);
					recycle(key, $e.currentTarget);
				});
			}
			
			return clip;
		}
		
		/**
		 *设置clip 
		 * @param $clip
		 * @param $data
		 */		
		private function setClip($clip:IClip, $data:Object):void
		{
			if($clip is IClipDataParser)
			{
				IClipDataParser($clip).data = $data;
			}
			else if(!setOther($clip, $data) && $data is IClipFrameDataList)
			{
				$clip.source = IClipFrameDataList($data);
			}
		}		
		
		/**
		 *如果还有其他类型的子类可覆盖 
		 * @param $clip
		 * @return 
		 */		
		protected function setOther($clip:IClip, $data:Object):Boolean
		{
			return false;
		}
		
		
		
		//========================================
		public function ClipFactory()
		{
			super();
		}
		
		private static var _instance:ClipFactory;

		public static function get instance():ClipFactory
		{
			if(!_instance)
			{
				_instance = new ClipFactory(); 
			}
			return _instance;
		}

	}
}