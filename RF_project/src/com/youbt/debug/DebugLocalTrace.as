package com.youbt.debug
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	/**
	 * 用 LocalConnection 输出 debug 信息
	 * @author zww
	 * 
	 */
	public class DebugLocalTrace extends AbstractDebugPublisher
	{
		private static var isConnected:Boolean=true;
		private static var conn:LocalConnection;
		public function DebugLocalTrace()
		{
			super();
		}
		
		public static function doTrace(msg:String):void{
			if(!isConnected){
				return;
			}
			
			if(!conn){
				conn=new LocalConnection;
				start();
			}
			conn.send("musicxx_LC","msgHandler",msg);
		}
		
		private static function onStatus(e:StatusEvent):void{
			switch(e.level){
				case "status":
					trace('DebugLocalTrace 成功连接');
				break;
				case "error":
					isConnected=false;
					sleep();
					trace('DebugLocalTrace 连接出错');
				break;
			}
		}
		
		override protected function doPublish(debugMessage:DebugMessageVO):void{
			
		}
		
		public static function sleep():void{
			conn.removeEventListener(StatusEvent.STATUS,onStatus);
		}
		
		public static function start():void{
			conn.addEventListener(StatusEvent.STATUS,onStatus);
		}
		
		
	}
}