package com.shrimp.framework.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 *	对bitmap进行了一次封装， 使其支持横向、纵向三宫格，九宫格等操作
	 * @author Sol
	 *
	 */
	public class AdvancedBitmap extends Bitmap
	{
		private var _smoothing:Boolean;

		private var _originBMD:BitmapData;
		private var _scale9Grid:Rectangle;
		
		private var _usescale9Rect:Boolean;
		public function AdvancedBitmap(bitmapData:BitmapData=null)
		{
			super(bitmapData);
			if(bitmapData)
			{
				this._originBMD = bitmapData.clone();
			}
		}

		public function set originBMD(value:BitmapData):void
		{
			if(this._originBMD == value)
				return;
			this._originBMD = value;
		}
		
		public function get originBMD():BitmapData
		{
			return this._originBMD;
		}
		
		/**是否平滑处理*/
		override public function get smoothing():Boolean
		{
			return _smoothing;
		}

		override public function set smoothing(value:Boolean):void
		{
			super.smoothing=_smoothing=value;
		}
		
		public function set scale9Rect(rect:Rectangle):void
		{
			if(_scale9Grid && rect && _scale9Grid.equals(rect))
				return;
			
			_scale9Grid = rect;
			
			_usescale9Rect=rect != null;
			
			if (_usescale9Rect == false && _originBMD)
			{
				_originBMD.dispose();
				return;
			}
		}
		
		public function get scale9Rect():Rectangle
		{
			return this._scale9Grid;
		}
		
		public function resizeBitmap(w:Number, h:Number):BitmapData
		{
			var bmpData:BitmapData=new BitmapData(w, h, true, 0x00000000);
			
			var rows:Array=[0, _scale9Grid.top, _scale9Grid.bottom, _originBMD.height];
			var cols:Array=[0, _scale9Grid.left, _scale9Grid.right, _originBMD.width];
			
			var dRows:Array=[0, _scale9Grid.top, h - (_scale9Grid.height - _scale9Grid.bottom), h];
			var dCols:Array=[0, _scale9Grid.left, w - (_scale9Grid.width - _scale9Grid.right), w];
			
			var origin:Rectangle;
			var draw:Rectangle;
			var mat:Matrix=new Matrix();
			
			
			for (var cx:int=0; cx < 3; cx++)
			{
				for (var cy:int=0; cy < 3; cy++)
				{
					origin=new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw=new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a=draw.width / origin.width;
					mat.d=draw.height / origin.height;
					mat.tx=draw.x - origin.x * mat.a;
					mat.ty=draw.y - origin.y * mat.d;
					bmpData.draw(_originBMD, mat, null, null, draw, true);
				}
			}
			
			return bmpData;
		}
	}
}
