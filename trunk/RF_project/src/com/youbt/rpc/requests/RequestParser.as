package com.youbt.rpc.requests
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.utils.ConfigurationUtil;
	
	import flash.utils.getDefinitionByName;
	
	public class RequestParser
	{
		public function RequestParser()
		{
		}
		
		private var _definedXML:XML;
		
		public function set requestDefined(value:XML):void
		{
			_definedXML = value.copy();
		}
		
		public function get requestDefined():XML
		{
			return _definedXML;
		}
			
		
		
		/**
		 * 处理 发出的请求  
		 * @param request
		 * @return 
		 * 
		 */
		protected function processRequest(request:Request):*
		{
			var requestType:String = 	request.requestType;
			var requestParameter:Array = request.requestParameter;
			var responderItem:XML ;
			var responderClassDefined:String;
			var responderInstance:Object;
			var invokeMethodName:String
			var parms:Array = [];
			var parmsList:XMLList ;
			var responderClass:Class
			if(requestDefined.request.(@type==requestType).length()!=1)
			{
				RFTraceError('type:'+requestType+' is not defined!');
				return;
			}
			responderItem = 	requestDefined.request.(@type==requestType)[0];
			responderClass = request.preplaceResponserClass;
			if(!responderClass)
			{
				responderClassDefined = responderItem.@operation
				try{
					responderClass= getDefinitionByName(responderClassDefined) as Class;
				}catch(e:ReferenceError)
				{
					RFTraceError('type:'+requestType+',Class:'+responderClassDefined+' ReferenceError!');
				}
			}
			responderInstance =  new responderClass() ;
			invokeMethodName = responderItem.@methodName;
			parmsList= responderItem.parm;
			for each(var parm:XML  in parmsList)
			{
				var obj:Object=null;
				var parmSource:String = parm.@source;
				var parmValue:String = parm.@value;
				/* 
					embed,  embed in xml
					inline,  inline ,call method/ prop in 
					config,  by config 
					request, getParms from  
				*/
					
				switch(parmSource)
				{
					case 'request':
						parmValue in requestParameter?	obj = requestParameter[parmValue]: RFTraceError(parmValue +' is not exist in  ' + parmSource);
					break;
					case 'inline':
						if(parmValue in this)
						{
							this[parmValue] is Function?obj = (this[parmValue]as Function).call(this): obj = this[parmValue];
						}
						else{RFTraceError(parmValue +' is not exist in  ' + parmSource);}
					break;
					case 'emebed':
						obj = parmValue;
					break;
					case 'config':
						obj = ConfigurationUtil.getUnique(parmValue);
						//todo improvement 
						// to  get value form config node in config
					break;
					default:
					break;
				}
				if(obj !=null){
					parms.push(obj);
				}
				else{
					trace('some bug by define:'+parm);
				}
			}
			return 	(responderInstance[invokeMethodName] as Function ).apply(this,parms);
			
		
		}
	}
}