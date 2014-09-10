package com.shrimp.extensions.clip.core
{
	import flash.utils.Dictionary;

	/**
	 *回收管理器 
	 * @author yeah
	 */	
	public class RecycleManger
	{
		
		/**回收利用 字典*/
		private var recycleDic:Dictionary = new Dictionary();
		
		/**
		 *回收 
		 * @param $key 类别
		 * @param $value
		 */		
		public function recycle($key:String, $value:Object):void
		{
			var dic:Dictionary;
			if($key in recycleDic)
			{
				dic = recycleDic[$key];
			}
			else
			{
				recycleDic[$key] = dic = new Dictionary(true);
			}
			
			dic[$value] = true;
		}
		
		/**
		 *获取 
		 * @param $key
		 * @return 
		 */		
		public function getValue($key:String):Object
		{
			var dic:Dictionary;
			if($key in recycleDic)
			{
				dic = recycleDic[$key];
			}
			
			var obj:Object;
			for(obj in dic)
			{
				delete dic[obj];
				break;
			}
			
			var isEmperty:Boolean = false;
			for each(var xxoo:Object in dic)
			{
				isEmperty = true;
				break;
			}
			
			if(isEmperty)
			{
				delete recycleDic[$key];
			}
			
			return obj;
		}
		
		public function RecycleManger()
		{
		}
	}
}