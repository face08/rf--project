package com.youbt.utils
{

	public class ArrayUtil
	{
	
		/**
		 *  Ensures that an Object can be used as an Array.
		 *
		 *  <p>If the Object is already an Array, it returns the object. 
		 *  If the object is not an Array, it returns an Array
		 *  in which the only element is the Object.
		 *  As a special case, if the Object is null,
		 *  it returns an empty Array.</p>
		 *
		 *  @param obj Object that you want to ensure is an array.
		 *
		 *  @return An Array. If the original Object is already an Array, 
		 * 	the original Array is returned. Otherwise, a new Array whose
		 *  only element is the Object is returned or an empty Array if 
		 *  the Object was null. 
		 */
		public static function toArray(obj:Object):Array
		{
			if (!obj) 
				return [];
			
			else if (obj is Array)
				return obj as Array;
			
			else
			 	return [ obj ];
		}
		
		/**
		 *  Returns the index of the item in the Array.
		 * 
		 *  Note that in this implementation the search is linear and is therefore 
		 *  O(n).
		 * 
		 *  @param item The item to find in the Array. 
		 *
		 *  @param source The Array to search for the item.
		 * 
		 *  @return The index of the item, and -1 if the item is not in the list.
		 */
		public static function getItemIndex(item:Object, source:Array):int
		{
		    return index(source,item);        
		}
		
		/**
		 * 数组中是否包含此元素;
		 * @param list
		 * @param value
		 * @return 
		 * 
		 */
		public static function has(list:Array,value:Object):Boolean{
			return index(list,value)>-1;
		}
		
		/**
		 * 取得项在数组中的索引;
		 * @param list
		 * @param value
		 * @return 
		 * 
		 */		
		private static function index(list:Array,value:Object):int{
			if(list==null || value==null)return -1;
			
			var len:uint=list.length;
			for(var i:uint=0;i<len;i++){
				if(list[i]==value){
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 删除数组中的一个元素;
		 * @param list
		 * @param value
		 * @return 
		 * 
		 */		
		public static function remove(list:Array,value:Object):int{
			var index:int=index(list,value);
			list.splice(index,1);
			return index;
		}
		
		
		/**
		 * 复制一份数组;
		 * @param list
		 * @return 
		 * 
		 */		
		public static function cloneArray(list:Array) : Array
		{
		    return list.concat();
		}
        
        /**
         * 对两个数组进行比较;
         * @param a
         * @param b
         * @param strongly 对地址比较/对项比较;
         * 
         */        
        public static function equal(a:Array,b:Array,strongly:Boolean=false):Boolean{
        	if(strongly){
        		return a==b;
        	}
        	
        	var l:int=a.length;
        	if(l !=b.length)return false;
        	
        	for(var i:int=0;i<l;i++){
        		if(a[i] !=b[i])return false;
        	}
        	
        	return true;
        	
        }
        
        /**
         * 两个数组中是否拥有相同的值; 
         * @param a
         * @param b
         * @return 
         * 
         */        
        public static function hasSame(a:Array,b:Array):Boolean{
        	var l:int =a.length;
        	
        	if(l !=b.length)return false;
        	
        	for each(var item:Object in a){
        		if(has(b,item)==false)return false;
        	}
        	return true;
        }
        
        /**
         * 数组中2个交换位置 
         * @param aArray
         * @param nIndexA
         * @param nIndexB
         * 
         */        
        public static function switchElements(aArray:Array, nIndexA:Number, nIndexB:Number):void {
	      var oElementA:Object = aArray[nIndexA];
	      var oElementB:Object = aArray[nIndexB];
	      aArray.splice(nIndexA, 1, oElementB);
	      aArray.splice(nIndexB, 1, oElementA);
	    }
	    
	    public static function checkByProperty(aArray:Array,item:Object,property:String):int
	    {
	    	var i:int;
	    	for each(var o:Object in aArray){
	    		if(o[property] == item[property]) return i;
	    		i++
	    	} 
	    	return -1; 
	    }
        
	}

}
