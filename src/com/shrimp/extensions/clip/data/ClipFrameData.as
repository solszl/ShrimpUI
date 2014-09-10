package com.shrimp.extensions.clip.data
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import com.shrimp.extensions.clip.core.LazyDispatcher;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	
	/**
	 *clip帧数据基类 
	 * 根据不通的IClipRender新增逻辑 
	 * 比如:ClipRenderer对应的ClipFrameBitpmapData
	 * @author yeah
	 */	
	public class ClipFrameData extends LazyDispatcher implements IClipFrameData
	{
		public function ClipFrameData($dispatcher:EventDispatcher=null)
		{
			super($dispatcher);
		}
		
		private var _offset:Point;
		public function get offset():Point
		{
			return this._offset;
		}
		
		public function set offset($value:Point):void
		{
			this._offset = $value;
		}
		
		private var _frameName:Object;
		public function get frameName():Object
		{
			return this._frameName;
		}
		
		public function set frameName($value:Object):void
		{
			this._frameName = $value;
		}
		
		public function destroy($cleanDispather:Boolean):void
		{
		}
	}
}