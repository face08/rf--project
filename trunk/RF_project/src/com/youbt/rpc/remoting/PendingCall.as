package  com.youbt.rpc.remoting {

	import flash.net.Responder;
	
	public class PendingCall {
		
		private var _conn:RemotingConnection;
		private var _serviceName:String;
		private var _methodName:String;
		private var _args:Array;
		
		public function PendingCall(conn:RemotingConnection, serviceName:String, methodName:String, args:Array) {
			_conn = conn;
			_serviceName = serviceName;
			_methodName = methodName;
			_args = args;
		}
		public function get connection():RemotingConnection{
			return _conn
		}
		public function set responder(value:Responder):void {
			var command:String = _serviceName + "." + _methodName;
			var argArray:Array = [command, value];
			argArray = argArray.concat(_args);
			var func:Function = _conn.call;
			func.apply(_conn, argArray);
		}
	}
}