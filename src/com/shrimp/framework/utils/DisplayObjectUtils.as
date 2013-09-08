package com.shrimp.framework.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Point;
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

		/**
		 *	获取指定点下的所有组件 并以array形式 返回 
		 * @param obj	根容器，通常都是取stage
		 * @param pt	指定点
		 * @param arr	返回的数组
		 * 
		 */		
		public static function getObjectsUnderPoint(obj:DisplayObject, pt:Point, arr:Array):void
		{
			if (!obj.visible)
				return;
			if (obj is Stage || obj.hitTestPoint(pt.x, pt.y, true))
			{
				if (obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
					arr.push(obj);
				if (!(obj is DisplayObjectContainer))
				{
					return;
				}
				var doc:DisplayObjectContainer=obj as DisplayObjectContainer;
				if (!doc.mouseChildren)
				{
					return;
				}
				if (doc.numChildren)
				{
					var n:int=doc.numChildren;
					for (var i:int=0; i < n; i++)
					{
						try
						{
							var child:DisplayObject=doc.getChildAt(i);
							getObjectsUnderPoint(child, pt, arr);
						}
						catch (e:Error)
						{
							//another sandbox?
						}
					}
				}

			}
		}
		
		public static function getDisplayBmd(target:DisplayObject):BitmapData
		{
			var bmd:BitmapData = new BitmapData(target.width,target.height,true,0xFFFFFF);
			bmd.draw(target);
			return bmd;
		}
	}
}
