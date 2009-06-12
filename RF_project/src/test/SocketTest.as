package test
{
		
	
	import com.youbt.net.IDecoder;
	import com.youbt.net.SocketBase;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;


	/**
	 * SOCKETBASE的基本用法  
	 * @author Administrator
	 * 
	 */	
	public class SocketTest implements IDecoder
	{
		public function SocketTest()
		{
			registerClassAlias("com.musicxx.vo.CommandInfo",SocketCommandInfo);
			
			
			var _ed:EventDispatcher = new EventDispatcher
			socket = new SocketBase(spost,_ed);
			socket.addEventListener(Event.CONNECT,connectHandler)
			socket.decoder = this
			socket.connect(host,post);
			
			
		}
		private var socket:SocketBase 
		
		private var host:String ="192.168.1.7";// "61.160.207.221";//
		private var spost:int = 8848;
		private var post:int = 9998;
		private var userName:String = "whh";
		private var passWord:String = "123456";
		public function decode(buffer : ByteArray) : void
        {
        	try{
            	var remoteObj : Object = buffer.readObject();
            	 trace(remoteObj,remoteObj.data.value)
            }catch(e:Error){
            	trace(e)
            }
            
            sendMsg()
           
//            var event : SocketBaseEvent = new SocketBaseEvent(SocketBaseEvent.ON_DATA, remoteObj as SocketCommandInfo);
//            _socketEventDispatcher.dispatchEvent(event);
        }
		
		private function connectHandler(e:Event):void
		{
			sendMsg()
		}
		
		private var slience:Boolean=true
		
		
		private function sendMsg():void
		{
			
			if(slience)
				return;
				
			var arr:String=''
			
			for(var i:int=0;i<10+Math.random()*50;i++){
				arr+=i.toString()
			}
			var vo:SocketCommandInfo=new SocketCommandInfo()
			
			
			vo.data.value=arr
			
			var ba:ByteArray=new ByteArray()
			
			ba.writeObject(vo)
			
			socket.send(ba)
			
			
		}

	}
}
class SocketCommandInfo
    {

        public function SocketCommandInfo()
        {
        }

        /**
         * 命令类型 
         */		
        public var command : String = '1';

		public var ctype:String;
        
		/**
		 * 游戏ticket
		 */
		public var gticket:String;

        /**
         * 承载的数据 
         */
        public var data : Object = {};

        /**
         * 本地发送时间  
         */
        public var timestamp : int = new Date().getTime();
    }