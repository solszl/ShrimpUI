package com.shrimp.framework.utils
{
	import com.shrimp.framework.managers.StageManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
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
			var bmd:BitmapData=new BitmapData(target.width, target.height, true, 0xFFFFFF);
			bmd.draw(target);
			return bmd;
		}

		/**
		 *	返回一个九宫格
		 * @param source	原图数据
		 * @param rect	缩放的矩形
		 * @param w	缩放后的宽
		 * @param h	缩放后的高
		 * @return 缩放后的图像数据
		 *
		 */
		public static function scale9Bmd(source:BitmapData, rect:Rectangle, w:Number, h:Number):BitmapData
		{
			if (source == null)
			{
				return new BitmapData(w, h, true, 0x000);
			}

			if (source.width == w && source.height == h)
			{
				return source;
			}
			
			if((w<rect.left+source.width - rect.right)||h<rect.top+source.height-rect.bottom)
			{
				return source;
			}
			
			var m:Matrix=new Matrix();
			var result:BitmapData=new BitmapData(w, h, true, 0x000000);
			var origin:Rectangle;
			var draw:Rectangle;
			//缩小
			if (source.height > h && source.width > w)
			{
				m.identity();
				m.scale(w / source.width, h / source.height);
				draw=new Rectangle(0, 0, w, h);
				result.draw(source, m, null, null, draw, true);
			}
			//放大
			else
			{
				var rows:Array=[0, rect.top, rect.bottom, source.height];
				var cols:Array=[0, rect.left, rect.right, source.width];
				var newRows:Array=[0, rect.top, h - (source.height - rect.bottom), h];
				var newCols:Array=[0, rect.left, w - (source.width - rect.right), w];
				for (var cx:int=0; cx < 3; cx++)
				{
					for (var cy:int=0; cy < 3; cy++)
					{
						origin=new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
						draw=new Rectangle(newCols[cx], newRows[cy], newCols[cx + 1] - newCols[cx], newRows[cy + 1] - newRows[cy]);
						m.identity();
						m.a=draw.width / origin.width;
						m.d=draw.height / origin.height;
						m.tx=draw.x - origin.x * m.a;
						m.ty=draw.y - origin.y * m.d;
						result.draw(source, m, null, null, draw, true);
					}
				}
			}

			return result;
		}
		
		/**
		 *	根据传入的点,返回该点下所有显示对象 
		 * @param xpos	横坐标
		 * @param ypos	纵坐标
		 * @return 	返回该点层级对应关系的组件列表
		 * 
		 */		
		public static function getUnderObjects(xpos:Number,ypos:Number):Array
		{
			var arr:Array = [];
			DisplayObjectUtils.getObjectsUnderPoint(StageManager.stage,new Point(xpos,ypos),arr);
			return arr;
		}
	}
}
