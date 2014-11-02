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
//			priorityArr.sort(sortFun);
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
		
		/** @private 对UIComponent的实例 根据nestLevel属性进行排序 **/
		private function sortFun(ui1:Component,ui2:Component):Number
		{
			if(ui1.nestLevel>ui2.nestLevel){	
				return 1;
			}else if(ui1.nestLevel==ui2.nestLevel){
				return 0;
			}else if(ui1.nestLevel<ui2.nestLevel){
				return -1;
			}
			return 0;
		}
	}
}