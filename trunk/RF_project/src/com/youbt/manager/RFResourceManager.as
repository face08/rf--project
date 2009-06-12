package com.youbt.manager
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.debug.RFTraceWarn;
	
	import flash.display.Loader;
	/**
	 * 资源管理
	 * 用于缓存频繁使用的资源
	 * @author Ray
	 * 
	 */	
	public class RFResourceManager
	{
		/**
		 * 存储对象 
		 */		
		private static var _localmap:Object={};
		
		
		/**
		 * 根据资源id删除资源 
		 * @param resoucename
		 * 
		 */		
		public static function Delete(resoucename:String):void
		{
			_localmap[resoucename]=null
			delete _localmap[resoucename];
		}
		
		/**
		 * 保存资源 
		 * @param resoucename
		 * @param content
		 * 
		 */		
		public static function Save(resoucename:String,content:Object):void{
			_localmap[resoucename]=content
		}
		
		/**
		 * 获取资源 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function Get(id:String):Object
		{
			return _localmap[id]
		}
		
		/**
		 * 从资源库中获取类 
		 * @param resoucename
		 * @param className
		 * @return 
		 * 
		 */		
		public static function getClass(resoucename:String,className:String):Class{
			try
			{
			  return Class((_localmap[resoucename] as Object).getClass(className));
				
          	 // return (_localmap[resoucename].contentLoaderInfo as Object).applicationDomain.getDefinition(className)
          	
				
			}
			catch(e:Error)
			{
		// throw new IllegalOperationError(className + " definition not found in " + swfLib);
				RFTraceError("ResourceError",e,resoucename,className)
				// to do 统一处理
				
			}
			return null
		}
		
		
		/**
		 * 从LOADER中获取类 
		 * @param loader
		 * @param className
		 * @return 
		 * 
		 */		
		public static function getClassFromLoader(loader:Loader,className:String):Class 
		{
	        try {
	        	if(loader.contentLoaderInfo.applicationDomain.hasDefinition(className)){
	        		var obj:Object=loader.contentLoaderInfo.applicationDomain.getDefinition(className)
	        		return Class(obj)
	      			//return loader.contentLoaderInfo.applicationDomain.getDefinition(className)  as  Class;  		
	        	}else{
	        		RFTraceWarn("ResourceWarning ,class not found",loader,className)
	        		return null
	        	}
	        } catch (e:Error) {
	        	RFTraceError("ResourceError",e,loader,className)
	        }
        	return null;
   		}
   		
   		
   		public static function saveLoader(obj:Object,key:String,namespaces:String='',pe:Boolean=false):Boolean
   		{
   			if(obj is Loader){
   				
   				
   				
   				
   				if(pe){
   					
   				}else{
   					
   				}
   				
   				
   				
   				return true
   					
   			}
   			return false;
   			
   		}
   		public static function getLoader(key:String):Loader
   		{
   			return null
   			
   		}
   		
   		public static function deleteByNamespace(ns:String):void
   		{
   			
   		}
	}
}