package  com.youbt.rpc.http
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.rpc.RemoteToken;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	public class HttpRemoteOperation 
	{
		
		protected var remoteToken:RemoteToken= new RemoteToken(this);
		
		public var totaltime:Number=0;
		
		public function HttpRemoteOperation(){
			
			remoteToken.addEventListener(RFLoaderEvent.COMPLETE,resultHandler)
			remoteToken.addEventListener(RFLoaderEvent.FAILED,errorHandler)
		}
		
		protected function start():void
		{
			totaltime=getTimer()	
		}
		
		protected function dispose():void
		{
			totaltime=getTimer()-totaltime
		}
		
		public function get Token():RemoteToken
		{
			return remoteToken;
		}
		public function resultHandler(e:RFLoaderEvent):void
		{
			Token.dispatchSuccessed('success',e.result);
		}
		
		public function errorHandler(e:RFLoaderEvent):void
		{ 
					
			Token.dispatchFault('failed',e.result);
		}
		
	}
}