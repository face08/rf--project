package com.youbt.core
{
	import flash.utils.getQualifiedClassName;
	[ExcludeClass]
	public class Singleton
	{
	    private static var classMap:Object = {};

	    public static function registerInstance(objcet:Object):void
    	{	
    		var interfaceName:String=flash.utils.getQualifiedClassName(objcet)
    	}

	    public static function getClass(name:Object):Class
	    {
	        return classMap[name];
	    }

  
	    public static function getInstance(interfaceName:Object):Object
	    {
	    	if(interfaceName is Class){
	    		interfaceName=flash.utils.getQualifiedClassName(interfaceName)
	    	}
	    	
	        var c:Class = classMap[interfaceName];
			if (!c)
			{
				throw new Error("No class registered for interface '" +
								interfaceName + "'.");
			}
			return new c();
	    }
	}

}
