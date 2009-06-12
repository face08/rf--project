package com.youbt.utils
{
	import flash.utils.ByteArray;
	
	
	/**
	 *  对像辅类，主要对像内属性值的提取;
	 * @author crlnet
	 * 
	 */	
	public class ObjectUtil
	{
		public function ObjectUtil()
		{
		}
		
		public static function getString(value:Object,defaultValue:String=""):String{
			if(value==null){
				return defaultValue;
			}
			
			//因为数字的0也等于空字符串;
			if(value is String && value==""){
				return defaultValue;
			}
			
			return value.toString();
		}
		
		public static function getBoolean(value:Object):Boolean{
			return Boolean(value);
		}
		
		
		public static function getInt(value:Object,defaultValue:int=-1):int{
			if(value==null){
				return defaultValue;
			}
			return int(value);
		}
		
		public static function getNumber(value:Object ,defaultValue:Number=-1):Number{
			if(value==null){
				return defaultValue;
			}
			
			return Number(value);
		}
		
		
		/**
		 * 深度复制; 
		 * @param obj
		 * @return 
		 * 
		 */		
		public static function deepClone(obj:Object):Object{
			var byt:ByteArray=new ByteArray();
			byt.writeObject(obj);
			byt.position=0;
			return byt.readObject();
		}

	}
}