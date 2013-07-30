package com.shrimp.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 *	displayobject工具类 
	 * @author Sol
	 * 
	 */	
	public class DisplayObjectUtils
	{
		/**
		 *	克隆指定显示对象，支持movieclip等常见显示对象 
		 * @param target
		 * @param autoAdd
		 * @return 
		 * 
		 */		
		public static function clone(target:DisplayObject, autoAdd:Boolean=false):DisplayObject
		{
			var targetClass:Class=Object(target).constructor;
			var duplicate:DisplayObject=new targetClass();
			duplicate.transform=target.transform;
			duplicate.filters=target.filters;
			duplicate.cacheAsBitmap=target.cacheAsBitmap;
			duplicate.opaqueBackground=target.opaqueBackground;
			if (target.scale9Grid)
			{
				var rect:Rectangle=target.scale9Grid;
				rect.x/=20, rect.y/=20, rect.width/=20, rect.height/=20;
				duplicate.scale9Grid=rect;
			}
			if (autoAdd && target.parent)
			{
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
	}
}
