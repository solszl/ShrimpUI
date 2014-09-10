package com.shrimp.extensions.clip.core
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import com.shrimp.extensions.clip.core.interfaceClass.IClip;
	import com.shrimp.extensions.clip.core.interfaceClass.IClipRenderer;
	import com.shrimp.extensions.clip.render.ClipRenderer;

	public class ClipRendererManager extends RecycleManger
	{
		/**
		 * $renderClass字典
		 */		
		private var renderDic:Dictionary;
		
		/**
		 *注册 ClipRenderer
		 * @param $host		使用$renderClass实例的类
		 * @param $renderClass
		 */		
		public function registClipRenderer($host:Class, $renderClass:Class):void
		{
			if(!renderDic)
			{
				renderDic = new Dictionary();
			}
			
			renderDic[getQualifiedClassName($host)] = $renderClass;
		}
		
		/**
		 *获取cliprender的实例 
		 * @param $host		使用$renderClass实例的类的完全限定名
		 * @return 
		 */		
		public function getClipRendererInstance($hostName:String):IClipRenderer
		{
			var renderInstance:IClipRenderer = getValue($hostName) as IClipRenderer;
			
			if(!renderInstance)
			{
				if($hostName in renderDic)
				{
					var c:Class = renderDic[$hostName];
					renderInstance = new c();
				}
				else
				{
					renderInstance = new ClipRenderer();
				}
			}
			
			return renderInstance;
		}
		
		
		
		/**
		 *初始化 
		 */		
		private function init():void
		{
			registClipRenderer(IClip, ClipRenderer);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//==================================
		
		public function ClipRendererManager()
		{
			if(_instance)
			{
				throw new Error("单利类不能被重复初始化");
			}
			
			init();//待定
		}
		
		
		private static var _instance:ClipRendererManager;

		public static function get instance():ClipRendererManager
		{
			if(!_instance)
			{
				_instance = new ClipRendererManager();
			}
			return _instance;
		}

		
	}
}