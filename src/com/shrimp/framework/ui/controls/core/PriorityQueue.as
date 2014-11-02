package com.shrimp.framework.ui.controls.core
{
	public class PriorityQueue
	{
		private var priorityArr:Array = [];
		
		/**	constructor*/
		public function PriorityQueue()
		{
		}
		
		public function sortElements():void
		{
			priorityArr.sortOn("nestLevel",Array.NUMERIC);
		}
		
		public function get length():Number
		{
			return priorityArr.length;
		}
		
		public function get minNestLevelElement():Component
		{
			return priorityArr.shift();
		}
		
		public function get maxNestLevelElement():Component
		{
			return priorityArr.pop();	
		}
		
		public function addElement(comp:Component):void
		{
			if(priorityArr.indexOf(comp)>=0)
			{
				return;
			}
			
			priorityArr.push(comp);
		}
	}
}