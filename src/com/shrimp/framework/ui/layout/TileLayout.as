package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;

	/**
	 *	网格布局
	 * @author Sol
	 *
	 */
	public class TileLayout extends BaseLayout
	{
		protected var _gapX:Number=5;
		protected var _gapY:Number=5;

		private var _rowCount:int=-1;
		private var _coloumCount:int=-1;

		public function TileLayout()
		{
			super();
			type="TileLayout";
		}

		public function set gapX(s:Number):void
		{
			if (_gapX == s)
				return;

			_gapX=s;
			if (target)
			{
				layout(target);
			}
		}

		public function get gapX():Number
		{
			return _gapY;
		}

		public function set gapY(s:Number):void
		{
			if (_gapY == s)

				return;

			_gapY=s;
			if (target)
			{
				layout(target);
			}
		}

		public function get gapY():Number
		{
			return _gapY;
		}

		public function get rowCount():int
		{
			return _rowCount;
		}

		public function set rowCount(value:int):void
		{
			_rowCount=value;
			if (target)
			{
				layout(target);
			}
		}

		public function get coloumCount():int
		{
			return _coloumCount;
		}

		public function set coloumCount(value:int):void
		{
			_coloumCount=value;
			if (target)
			{
				layout(target);
			}
		}
		
		override public function layout(target:Component):void
		{
			if(!target)
				return;
			this.target=target;
			
			_measureHeight=_measureWidth=0;
			var xpos:Number=0;
			var ypos:Number=0;
			var maxH:Number=0;
			var maxW:Number=0;
			var c:int;
			var r:int;
			var child:DisplayObject;
			
			var numChildren:uint=target.numChildren;
			
			if (_coloumCount == -1 && _rowCount == -1)
			{
				_coloumCount=int(Math.sqrt(numChildren));
			}
			var totalCount:int=0;
			if (_coloumCount != -1)
			{
				_rowCount=Math.ceil(numChildren / _coloumCount);
				for (r=0; r < _rowCount; r++)
				{
					maxH=0;
					xpos=0;
					for (c=0; c < _coloumCount; c++)
					{
						if (totalCount < numChildren)
						{
							child=target.getChildAt(totalCount);
							child.x=xpos;
							child.y=ypos;
							xpos+=child.width;
							if (_measureWidth < xpos)
							{
								_measureWidth=xpos;
							}
							xpos+=_gapX;
							
							if (child.height > maxH)
							{
								maxH=child.height
							}
							
							totalCount++;
						}
					}
					
					ypos+=maxH;
					_measureHeight=ypos
					ypos+=_gapY;
				}
			}
			else
			{
				_coloumCount=Math.ceil(numChildren / _rowCount);
				
				for (c=0; c < _coloumCount; c++)
				{
					maxW=0;
					xpos=0;
					for (r=0; r < _rowCount; r++)
					{
						if (totalCount < numChildren)
						{
							child=target.getChildAt(totalCount);
							child.x=xpos;
							child.y=ypos;
							ypos+=child.height;
							if (_measureHeight < ypos)
							{
								_measureHeight=ypos;
							}
							ypos+=_gapY;
							
							if (child.width > maxW)
							{
								maxW=child.width
							}
							
							
							totalCount++;
						}
					}
					
					xpos+=maxW;
					_measureWidth=xpos
					xpos+=_gapX;
				}
			}
		}
	}
}
