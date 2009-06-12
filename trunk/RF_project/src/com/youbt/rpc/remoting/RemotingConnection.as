package  com.youbt.rpc.remoting{

 	import com.youbt.debug.RFTraceError;
 	import com.youbt.events.ConnectionEvent;
 	
 	import flash.events.IOErrorEvent;
 	import flash.events.NetStatusEvent;
 	import flash.events.SecurityErrorEvent;
 	import flash.net.NetConnection;
 	import flash.net.ObjectEncoding;

	public class RemotingConnection extends NetConnection 
	{
		public function RemotingConnection(gatewayUrl:String, objectEncoding:uint=3)
		{
			this.objectEncoding = objectEncoding;
    	  	addEventListener(NetStatusEvent.NET_STATUS,onNetConnectionCallFailed);
		  	addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		  	addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
  		  	if (gatewayUrl) 
     			connect(gatewayUrl);
      	 }

	    public function get gatewayUrl():String {
	    	return uri;
	    }

   		private function onNetConnectionCallFailed(e:NetStatusEvent):void
		{
			//RFSystemManager.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.ONEXCEPTION,e.info.type))
			//dispatchEvent(new ConnectionEvent(ConnectionEvent.ONEXCEPTION,e.info.type))
			RFTraceError("远程方法呼叫失败，请检查相关AMFSERVICE 文件",e.type,e.info.description)
			
		}
	
		private function onIOError(e:IOErrorEvent):void
		{
			//RFSystemManager.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.ONEXCEPTION,e.type,e))
			dispatchEvent(new ConnectionEvent(ConnectionEvent.ONEXCEPTION,e.type,e))
			RFTraceError('远程方法呼叫失败，发生IO错误，请检查');
		}
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			//RFSystemManager.getInstance().dispatchEvent(new ConnectionEvent(ConnectionEvent.ONEXCEPTION,e.type,e))
			dispatchEvent(new ConnectionEvent(ConnectionEvent.ONEXCEPTION,e.type,e))
			RFTraceError('远程方法呼叫失败，发生安全错误，请检查安全域设置')
		}

	    public function setCredentials(username:String, password:String):void
	    {
	      if (objectEncoding == ObjectEncoding.AMF0) {
	        addHeader("Credentials", false, {userid: username, password: password});
		  } else {
	        addHeader("credentialsUsername", false, username);
		    addHeader("credentialsPassword", false, password);
		  }
	    }

  }
}
