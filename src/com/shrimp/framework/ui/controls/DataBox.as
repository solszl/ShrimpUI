package com.shrimp.framework.ui.controls
{
	import com.shrimp.framework.interfaces.IItemRenderer;
	import com.shrimp.framework.ui.container.Box;
	import com.shrimp.framework.utils.ArrayList;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	public class DataBox extends Box
	{
		public function DataBox(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			mouseChildren=true;
			addEventListener(MouseEvent.CLICK, onMouseClick,false,0,true);
		}
		
		protected function onMouseClick(e:MouseEvent):void
		{
			var item:DisplayObject = e.target as DisplayObject;
			while(true)
			{
				if(item is IItemRenderer)
				{
					break;
				}
				else
				{
					item = item.parent
					if(item==null)
					{
						return;
					}
				}
			}
			
			var index:int=-1;
			if (item.parent == this)
			{
				index=getChildIndex(item);
			}
		}
		
		private var _itemPool:Array=[];
		
		public var renderCall:Function;
		public var disposeCall:Function;
		public var onChangeCallBK:Function;
		
		
		protected var _itemRender:IFactory;
		protected var _selectedIndex:int=-1;
		private var _dataProvider:ArrayList;
		private var _dataProvierChanged:Boolean=false;
		private var _listItemClassChanged:Boolean=false;
		
		public function get dataProvider():ArrayList
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:ArrayList):void
		{
			if (value == _dataProvider)
				return;
			
			//移除上一个——dataProvider的回调
			if (_dataProvider)
			{
				_dataProvider.itemAddCallBK=null;
				_dataProvider.itemRemoveCallBK=null;
				_dataProvider.removeAllCallBK=null;
				_dataProvider.addAllCallBK=null;
				_dataProvider.updataItemAtCallBK=null;
			}
			
			_dataProvider=value;
			
			if (_dataProvider)
			{
				_dataProvider.itemAddCallBK=addItemAt;
				_dataProvider.itemRemoveCallBK=removeItemAt;
				_dataProvider.removeAllCallBK=removeAll;
				_dataProvider.addAllCallBK=addAll;
				_dataProvider.updataItemAtCallBK=updataItemAt;
			}
			//			else
			//			{
			selectedIndex=-1;
			//			}
			
			_dataProvierChanged=true;
			
			invalidateProperties();
			invalidateSize();
		}
		
		public function get itemRender():IFactory
		{
			return _itemRender;
		}
		
		public function set itemRender(value:IFactory):void
		{
			if (_itemRender == value)
				return;
			
			_itemRender=value;
			_listItemClassChanged=true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			if (_dataProvierChanged || _listItemClassChanged)
			{
				var itemR:IItemRenderer;
				
				//如果ItemClass变了,则清空之前的item池。
				if(_listItemClassChanged)
				{
					_itemPool.length = 0;
					while (numChildren > 0)
					{
						itemR =removeChildAt(0) as IItemRenderer;
						itemR.dispose();
					}
				}
				
				if(_dataProvider)
				{
					for (var i:int=0; i < _dataProvider.length; i++)
					{
						var item:IItemRenderer=createItemRender(_dataProvider.getItemAt(i),i);
						
						if(!contains(DisplayObject(item)))
						{
							addChild(DisplayObject(item));
						}
					}
					//回收多余的item.
					var removeCount:int = numChildren - dataProvider.length;
					if(removeCount >0)
					{
						while(numChildren != dataProvider.length)
						{
							itemR =removeChildAt(numChildren-1) as IItemRenderer;
							itemR.dispose();
							if(disposeCall!=null)
							{
								disposeCall(item,item.data)
							}
							
							//如果ItemClass变了，则不对item进行回收。
							if(!_listItemClassChanged)
							{
								_itemPool.push(itemR);
							}
						}
					}
				}
					//当dataprivider为null时回收所有的item；
				else
				{
					while (numChildren > 0)
					{
						itemR =removeChildAt(0) as IItemRenderer;
						itemR.dispose();
						if(disposeCall!=null)
						{
							disposeCall(item,item.data)
						}
						
						//如果ItemClass变了，则不对item进行回收。
						if(!_listItemClassChanged)
						{
							_itemPool.push(itemR);
						}
					}	
				}
				
				_dataProvierChanged = false;
				_listItemClassChanged= false;
				
				invalidateSize();
				invalidateDisplayList();
			}
			
			if(_selectedIndexChanged || _selectedIndexChangedManually)
			{
				if (_selectedIndex >= 0 && _dataProvider != null&& _selectedIndex < _dataProvider.length)
				{
					//选中当前选中的item
					if(_selectedIndex < numChildren &&　_selectedIndex　> -1)
					{
						Object(getChildAt(_selectedIndex)).selected = true;
					}
				}
				else
				{
					_selectedIndex=-1;
				}
				
				//使用setSelectedIndex是不会派发change事件
				if(!_selectedIndexChangedManually)
				{
					if(hasEventListener(Event.SELECT))
					{
						dispatchEvent(new Event(Event.SELECT));
					}
					
					if(onChangeCallBK != null)
					{
						onChangeCallBK(selectedItem);
					}
				}
				
				_selectedIndexChanged = false;
				_selectedIndexChangedManually = false;
			}
		}
		
		private var _selectedIndexChanged:Boolean = false;
		private var _selectedIndexChangedManually:Boolean = false;
		public function set selectedIndex(value:int):void
		{
			if(value == _selectedIndex) return;
			
			//取消前一个选中的item的选中状态
			if(_selectedIndex < numChildren &&　_selectedIndex　> -1)
			{
				Object(getChildAt(_selectedIndex)).selected = false;
			}
			
			_selectedIndex = value;
			
			_selectedIndexChanged = true;
			invalidateProperties();
			invalidateSize();
		}
		
		/**
		 * 使用此方法不会派发SELECT事件 
		 * @param value
		 * 
		 */		
		public function setSelectedIndex(value:int):void
		{
			if(value == _selectedIndex) return;
			
			//取消前一个选中的item的选中状态
			if(_selectedIndex < numChildren &&　_selectedIndex　> -1)
			{
				Object(getChildAt(_selectedIndex)).selected = false;
			}
			
			_selectedIndex = value;
			
			_selectedIndexChangedManually = true;
			invalidateProperties();
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get selectedItem():Object
		{
			if (_dataProvider == null)
			{
				return null;
			}
			
			if (_selectedIndex >= 0 && _selectedIndex < _dataProvider.length)
			{
				return _dataProvider.getItemAt(_selectedIndex);
			}
			return null;
		}
		
		public function set selectedItem(item:Object):void
		{
			var index:int=_dataProvider.indexOf(item);
			
			selectedIndex=index;
		}
		
		/**
		 *	此方法会先检查已有的child，并将其利用，
		 *  不够用的话再去看对象池，还不够的话就新建。
		 * 
		 * @param data 数据
		 * @param index 索引
		 * @return 
		 * 
		 */		
		protected function createItemRender(data:Object,index:int):IItemRenderer
		{
			var item:IItemRenderer;
			if(index< numChildren)
			{
				item = IItemRenderer(getChildAt(index));
				item.dispose();
			}
			else
			{
				item = _itemPool.length > 0 ? _itemPool.pop() : _itemRender.newInstance();
			}
			item.index = index;
			item.data=data;
			
			if(renderCall != null)
			{
				renderCall(item,data);
			}
			
			return item;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(!(child is IItemRenderer))
			{
				throw new Error("Can not add any child except the one implemented IItemRender!");
			}
			return super.addChild(child);
		}
		
		private function addAll():void
		{
			_dataProvierChanged=true;
			
			invalidateProperties();
		}
		
		private function addItem(item:Object):void
		{
			addChild(DisplayObject(createItemRender(item,_dataProvider.length)));
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function addItemAt(item:Object, index:int):void
		{
			addChildAt(DisplayObject(createItemRender(item,index)), index);
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		private function removeAll():void
		{
			_dataProvierChanged=true;
			selectedIndex=-1;
			
			invalidateProperties();
		}
		
		private function removeItemAt(index:int):void
		{
			var item:IItemRenderer=removeChildAt(index) as IItemRenderer;
			
			//如果删除的正好是当前选中的，则将_selectedIndex置为-1；
			if (index == _selectedIndex)
			{
				selectedIndex=-1;
			}
			
			_itemPool.push(item);
			
			item.dispose();
			if(disposeCall!=null)
			{
				disposeCall(item,item.data)
			}
			
			invalidateDisplayList();
		}
		
		private function updataItemAt(index:int):void
		{
			if (index >= 0 && _dataProvider != null && index < _dataProvider.length)
			{
				IItemRenderer(getChildAt(index)).data = _dataProvider.getItemAt(index);
			}
		}
	}
}