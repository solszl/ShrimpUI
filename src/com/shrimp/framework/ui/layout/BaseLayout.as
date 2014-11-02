package com.shrimp.framework.ui.layout
{
	import com.shrimp.framework.ui.controls.Button;
	import com.shrimp.framework.ui.controls.core.Component;
	
	import flash.display.DisplayObject;

	public class BaseLayout extends AbstractLayout
	{
		public function BaseLayout()
		{
			super();
		}

		override public function layout(target:Component):void
		{
			if (!target)
				return;

			this.target=target;

			_measureWidth=0;
			_measureHeight=0;

			var i:int=0;
			var child:DisplayObject;
			var numChildren:uint=target.numChildren;
			for (i=0; i < numChildren; i++)
			{
				child=target.getChildAt(i);
				var cw:Number=child.width + child.x
				if (cw > _measureWidth)
				{
					_measureWidth=cw;
				}

				var ch:Number=child.height + child.y;
				if (ch > _measureHeight)
				{
					_measureHeight=ch;
				}
			}

			var acW:Number=isNaN(target.explicitWidth) ? _measureWidth : target.explicitWidth;
			var acH:Number=isNaN(target.explicitHeight) ? _measureHeight : target.explicitHeight;
			for (i=0; i < numChildren; i++)
			{
				child=target.getChildAt(i);
				if (child is Component)
				{
					var comp:Component=child as Component;
					if (comp.left != null || comp.right != null || comp.top != null || comp.bottom != null)
					{
						if (comp.left != null && comp.right != null)
						{
							comp.setActualSize(target.width - int(comp.left) - int(comp.right), target.explicitHeight);
							comp.x=int(comp.left);
						}
						else
						{
							if (comp.left != null)
							{
								comp.x=int(comp.left);
							}
							if (comp.right != null)
							{
								comp.x=target.width - comp.width - int(comp.right);
							}
						}

						if (comp.top != null && comp.bottom != null)
						{
							comp.setActualSize(comp.explicitWidth, target.height - int(comp.top) - int(comp.bottom));
							comp.y=int(comp.top);
						}
						else
						{
							if (comp.top != null)
							{
								comp.y=int(comp.top);
							}
							if (comp.bottom != null)
							{
								comp.y=target.height - comp.height - int(comp.bottom);
							}
						}
					}

					if (!isNaN(comp.horizontalCenter))
					{
						comp.x=((acW - comp.width) >> 1) + comp.horizontalCenter;
					}

					if (!isNaN(comp.verticalCenter))
					{
						comp.y=((acH - comp.height) >> 1) + comp.verticalCenter;
					}
				}
			}
//			target.invalidateSize();
			target.width = measureWidth;
			target.height = measureHeight;
//			target.invalidateDisplayList();
		}

		override public function get measureHeight():Number
		{
			return Math.max(_measureHeight, 0);
		}

		override public function get measureWidth():Number
		{
			return Math.max(_measureWidth, 0);
		}
	}
}
