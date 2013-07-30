package com.shrimp.framework.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 *	用来抓去当前场景的快照，并返回bitmapdata 
	 * @author Sol
	 * 
	 */	
	public class ImageSnapshot
	{
		public static const MAX_BITMAP_DIMENSION:int=2880;

		/**
		 *  A utility method to grab a raw snapshot of a UI component as BitmapData.
		 *
		 *  @param source An object that implements the
		 *    <code>flash.display.IBitmapDrawable</code> interface.
		 *
		 *  @param matrix A Matrix object used to scale, rotate, or translate
		 *  the coordinates of the captured bitmap.
		 *  If you do not want to apply a matrix transformation to the image,
		 *  set this parameter to an identity matrix,
		 *  created with the default new Matrix() constructor, or pass a null value.
		 *
		 *  @param colorTransform A ColorTransform
		 *  object that you use to adjust the color values of the bitmap. If no object
		 *  is supplied, the bitmap image's colors are not transformed. If you must pass
		 *  this parameter but you do not want to transform the image, set this parameter
		 *  to a ColorTransform object created with the default new ColorTransform() constructor.
		 *
		 *  @param blendMode A string value, from the flash.display.BlendMode
		 *  class, specifying the blend mode to be applied to the resulting bitmap.
		 *
		 *  @param clipRect A Rectangle object that defines the
		 *  area of the source object to draw. If you do not supply this value, no clipping
		 *  occurs and the entire source object is drawn.
		 *
		 *  @param smoothing A Boolean value that determines whether a
		 *  BitmapData object is smoothed when scaled.
		 *
		 *  @return A BitmapData object representing the captured snapshot.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function captureBitmapData(source:IBitmapDrawable, matrix:Matrix=null, colorTransform:ColorTransform=null, blendMode:String=null, clipRect:Rectangle=null, smoothing:Boolean=false):BitmapData
		{
			var data:BitmapData;
			var width:int;
			var height:int;

			var normalState:Array;

			if (source != null)
			{
				if (source is DisplayObject)
				{
					width=DisplayObject(source).width;
					height=DisplayObject(source).height;
				}
				else if (source is BitmapData)
				{
					width=BitmapData(source).width;
					height=BitmapData(source).height;
				}
			}

			// We default to an identity matrix
			// which will match screen resolution
			if (!matrix)
				matrix=new Matrix(1, 0, 0, 1);

			var scaledWidth:Number=width * matrix.a;
			var scaledHeight:Number=height * matrix.d;
			var reductionScale:Number=1;

			// Cap width to BitmapData max of 2880 pixels
			if (scaledWidth > MAX_BITMAP_DIMENSION)
			{
				reductionScale=scaledWidth / MAX_BITMAP_DIMENSION;
				scaledWidth=MAX_BITMAP_DIMENSION;
				scaledHeight=scaledHeight / reductionScale;

				matrix.a=scaledWidth / width;
				matrix.d=scaledHeight / height;
			}

			// Cap height to BitmapData max of 2880 pixels
			if (scaledHeight > MAX_BITMAP_DIMENSION)
			{
				reductionScale=scaledHeight / MAX_BITMAP_DIMENSION;
				scaledHeight=MAX_BITMAP_DIMENSION;
				scaledWidth=scaledWidth / reductionScale;

				matrix.a=scaledWidth / width;
				matrix.d=scaledHeight / height;
			}

			// the fill should be transparent: 0xARGB -> 0x00000000
			// only explicitly drawn pixels will show up
			data=new BitmapData(scaledWidth, scaledHeight, true, 0x00000000);
			data.draw(source, matrix, colorTransform, blendMode, clipRect, smoothing);

			return data;
		}
		
		public static function clipTransparent(bpd:BitmapData):BitmapData
		{
			bpd.threshold(bpd, bpd.rect, new Point(0, 0), "<=", 0x10000000, 0, 0xff000000);
			var newRect:Rectangle=bpd.getColorBoundsRect(0xf0000000, 0x00000000, false);
			var traget:BitmapData=new BitmapData(newRect.width, newRect.height);
			traget.copyPixels(bpd, newRect, new Point(0, 0));
			return traget;
		}
	}
}