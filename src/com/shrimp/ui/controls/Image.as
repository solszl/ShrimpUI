package com.shrimp.ui.controls
{
	import com.shrimp.ui.controls.core.Component;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	public class Image extends Component
	{
		private var _img:Bitmap;
		public function Image(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		override protected function createChildren():void
		{
			super.createChildren();
			_img=new Bitmap();
			addChildAt(_img,0);
		}
	}
}