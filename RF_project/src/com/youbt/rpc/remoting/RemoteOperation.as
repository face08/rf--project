package   com.youbt.rpc.remoting
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.events.ConnectionEvent;
	import com.youbt.rpc.RemoteToken;
	
	import flash.events.NetStatusEvent;
	import flash.net.Responder;
	import flash.utils.getTimer;
	
	public class RemoteOperation implements IRemoteOperation
	{
		private var _pc:PendingCall;
		
		
		public var totaltime:Number=0;
		
		
		protected function get pc():PendingCall
		{
			return _pc;
		}
		protected function set pc(value:PendingCall):void
		{
			
			totaltime=getTimer()
			_pc = value;
			initPendingCall();
		}
		
		public function RemoteOperation(sv:RemotingService = null)
		{
			
		}
		
		protected function initPendingCall():void
		{
			pc.responder=new Responder(resultHandler,errorHandler)
			pc.connection.addEventListener(NetStatusEvent.NET_STATUS,errorHandler)
			pc.connection.addEventListener(ConnectionEvent.ONEXCEPTION,exceptionHandler)
		}
		
		protected function dispose():void
		{
			totaltime=getTimer()-totaltime;
		}
		
		protected var remoteToken:RemoteToken= new RemoteToken(this);

		public function get Token():RemoteToken
		{
			return remoteToken;
		}
		public function resultHandler(o:Object):void
		{
					// to be override 
			dispose()
			Token.dispatchSuccessed("success time:"+this.totaltime,o);
		}
		
		public function errorHandler(o:Object):void
		{ 
					//trace(o.code)
					
					//
			RFTraceError(o.type)
			if(o is NetStatusEvent){
				Token.dispatchFault('failed',o.info.description);
			}else{
				RFTraceError(o.description)
				RFTraceError(o.detals)
				Token.dispatchFault('failed',o.description);
			}
			
		}
		private function exceptionHandler(e:ConnectionEvent):void
		{
			Token.dispatchFault('failed',e.type);
		}
		
	}
}