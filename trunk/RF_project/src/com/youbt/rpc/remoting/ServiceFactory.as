package com.youbt.rpc.remoting {
	import com.youbt.debug.RFTraceSummary;
	

  public class ServiceFactory {

    private static var _instance:ServiceFactory;

    private var _gatewayUrl:String;
    private var _serviceMap:Object;

    public function ServiceFactory(arg:ServiceFactoryArgs) {
      	_gatewayUrl = arg.gatewayUrl;
     	 _serviceMap = new Object();
    }

    public static function getInstance(gatewayUrl:String):ServiceFactory {
     	 if (!_instance) {
     		  _instance = new ServiceFactory(new ServiceFactoryArgs(gatewayUrl));
      	}
      	return _instance;	
    }

    public function getService(serviceName:String,gatwayUrl:String=null):RemotingService {
    		var cacheKey:String
    	  if(gatwayUrl){
    	  	 cacheKey =gatwayUrl + serviceName;
    	  }else{
    	  	 cacheKey = _gatewayUrl + serviceName;
    	  	 gatwayUrl=_gatewayUrl
    	  }
    	
      	  var service:RemotingService = _serviceMap[cacheKey];
    	  if (service) {
       		 return service;
    	  }
     	 var conn:RemotingConnection = getConnectionFromExistingService(cacheKey);
    	  if (conn) {
    	    service = new RemotingService(null, serviceName, conn);
   		   } else {
    	    service = new RemotingService(gatwayUrl, serviceName);
     	  }	
     		 _serviceMap[cacheKey] = service;
   		   return service;
    }

    private function getConnectionFromExistingService(key:String):RemotingConnection {
      for each (var service:RemotingService in _serviceMap) {
      	RFTraceSummary(key,"????")
      	if(service.connection.gatewayUrl==key){
      		 return service.connection as RemotingConnection;
      	}
      }
      return undefined;
    }

  }


}

class ServiceFactoryArgs {

  public var gatewayUrl:String;	

  public function ServiceFactoryArgs(gatewayUrl:String) {
    this.gatewayUrl = gatewayUrl;
  }

}
