package com.shrimp.framework.utils
{

	public class ArrayList
	{
		public var itemAddCallBK:Function;
		public var itemRemoveCallBK:Function;
		public var removeAllCallBK:Function;
		public var addAllCallBK:Function;
		public var updataItemAtCallBK:Function;

		/**
		 *封装一个Array,作为List,DataGrid组件的数据源，提供三个对外更新的callBack
		 * @param source
		 *
		 */
		public function ArrayList(source:Array=null)
		{
			if (source)
			{
				_source=source;
			}
		}

		public function addItem(item:Object):void
		{
			addItemAt(item, _source.length)
		}

		public function removeItem(item:Object):void
		{
			var index:int=indexOf(item);

			removeItemAt(index)
		}

		public function removeItemAt(index:int):void
		{
			if (index >= 0 && index < _source.length)
			{
				if (itemRemoveCallBK != null)
				{
					itemRemoveCallBK(index);
				}
				_source.splice(index, 1);
			}
		}

		public function addItemAt(item:Object, index:int):void
		{
			if (index >= 0 && index <= _source.length)
			{
				_source.splice(index, 0, item)

				if (itemAddCallBK != null)
				{
					itemAddCallBK(item, index);
				}
			}
		}

		public function removeAll():void
		{
			//由于_source可能是其它array的引用，此处不能使用_source的内容进行删除，设置其length也不可以。
			//将其置为null为最好的选择，但此处将它指向一个空数组。
			_source=[];

			if (removeAllCallBK != null)
			{
				removeAllCallBK()
			}
		}

		public function addAll(list:Array):void
		{
//			for each(var item:Object in list)
//			{
//				_source.push(item)
//			}
			_source=list;

			if (addAllCallBK != null)
			{
				addAllCallBK()
			}
		}

		public function get length():int
		{
			return _source.length;
		}

		public function getItemAt(index:int):Object
		{
			if (index >= 0 && index < _source.length)
			{
				return _source[index]
			}

			return null;
		}

		public function indexOf(item:Object):int
		{
			return _source.indexOf(item)
		}

		public function updataItemAt(index:int):void
		{
			if (updataItemAtCallBK != null)
			{
				updataItemAtCallBK(index)
			}
		}

		public function contains(item:*):Boolean
		{
			return indexOf(item) >= 0;
		}

		public function get source():Array
		{
			return _source;
		}

		public function set source(value:Array):void
		{
			if (_source == value)
				return;

			removeAll();
			addAll(value)
		}
		private var _source:Array=[];
	}
}
