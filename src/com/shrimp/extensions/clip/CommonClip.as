package com.shrimp.extensions.clip
{
	import com.shrimp.extensions.clip.core.interfaceClass.IClipDataParser;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameData;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipFrameDataList;
	import com.shrimp.extensions.clip.core.interfaceClass.IDynamicClip;
	
	/**
	 *通用clip
	 * data是数据源,可以是任何类型,如果data类型为IDynamicClip支持对帧的增删改
	 * @author yeah
	 */	
	public class CommonClip extends Clip implements IDynamicClip, IClipDataParser
	{
		public function CommonClip()
		{
			super();
		}
		
		public function addFrameDatas($additionList:Vector.<IClipFrameData>):Vector.<IClipFrameData>
		{
			if(source && source is IDynamicClip)
			{
				IDynamicClip(source).addFrameDatas($additionList);
			}
			return 	$additionList;			
		}
		
		public function removeFrameDatas($deductionList:Vector.<IClipFrameData>):Vector.<IClipFrameData>
		{
			if(source && source is IDynamicClip)
			{
				IDynamicClip(source).removeFrameDatas($deductionList);
			}
			return 	$deductionList;	
		}
		
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			
			//此处获取解析器并且利用解析器获取解析后的数据后设置source
		}
		
		public function get parserKey():String
		{
			return null;
		}
	}
}