package com.youbt.utils
{
	import flash.utils.describeType;
	
	public final class As2PythonUtil
	{
		
		
		
		public static const DJANGO_MODEL:String="class {0}(models.Model):\r";
		/**
		 * 
		 * @param o
		 * @return 
		 * dump a class  to django model class
		 * usage As2PythonUtil.django_ORM(SystemManager)
		 */		
		public static function django_ORM(o:Object):String
		{
				// to do implement NUMBER 
				
				var xml:XML=describeType(o)
				var classname:String=xml.@name.toString()
				var id:int=classname.indexOf("::")
				if(id>0){
					classname=classname.slice(id+2)
				}
				var output:String=StringUtil.substitute(DJANGO_MODEL,classname,123)
				var prop:XMLList=xml.child("factory");
				
            	for each(var item:XML in prop.child("variable")) {
            		var tp:String;
            		
            		if(item.@name=="created"){
            			output+="	"+item.@name+"=models.DateTimeField(auto_now_add=True)\r"
            			continue;
            		}
            		switch(item.@type.toString()){
            			case 'String':
            			tp="models.CharField(maxlength=40,blank=True,null=True,default='')";
            			break;
            			case 'int':
            			tp="models.IntegerField(blank=True,default=0)";
            			break;
            			case 'uint':
            			tp="models.IntegerField(blank=True,default=0)";
            			break;
            			case 'Number':
            			tp="models.IntegerField(blank=True,default=0)";
            			break;
            			default:
            			tp="models.CharField(maxlength=80,blank=True,null=True,default='')";
            			break;
            		}
                	output+="	"+item.@name+"="+tp+"\r"
          	}
          	return output
		}
		
		public static function google_engine_ORM(o:Object):String
		{
		  	return null
		}

	}
}