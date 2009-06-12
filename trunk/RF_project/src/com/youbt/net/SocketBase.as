package com.youbt.net
{
    import com.youbt.debug.RFTraceSummary;
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.Socket;
    import flash.system.Security;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    /**
     * socket 连接基础类 
     * @author eas
     * 
     */
    public class SocketBase extends Socket
    {

        private var host : String;

        private var port : int;

        private var sPort : int;

        private var ed : IEventDispatcher;

        private var debug : Boolean = false;

        private var SentBytes : int;

        private var ReceivedBytes : int;

        private var timer : Timer;

        private var header : Boolean = false;

        private var sbuffer : ByteArray = new ByteArray();

        private var readeBuffer : ByteArray = new ByteArray();

        private var msgLength : uint;
        
        

        /**
         * constructor 
         * @param sPort
         * @param ed
         * @param debug
         * 
         */
        public function SocketBase(sPort : int,ed : IEventDispatcher,debug : Boolean = false)
        {
            this.sPort = sPort;
            this.ed = ed;
            this.debug = debug;
            this.addEventListener(Event.CONNECT, onConnect);
            this.addEventListener(flash.events.ProgressEvent.SOCKET_DATA, onData);
            this.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onIOError);
            this.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            this.addEventListener(Event.CLOSE, onClose);
        }

        override public function connect(host : String, port : int) : void
        {
        	
        	if(decoder==null){
	        	throw new Error("U must specify a decoder before connecting");
	        }
        	
            this.host = host;
            this.port = port;
            if(sPort != 0)
            {
                var str : String = "xmlsocket://" + host + ":" + sPort;
                Security.loadPolicyFile(str);
            }
            super.connect(host, port);
        }

        public function disconnect() : Boolean
        {
            if(this.connected)
            {
                this.close();
                return true;
            }else {
                return false;
            }
        }

        public function send(ba : ByteArray) : void
        {
            if(connected)
            {
                this.writeInt(ba.length);
                this.writeBytes(ba);
                this.flush();
                RFTraceSummary(ba.length + '字节的数据被发送');
                SentBytes += (ba.length + 1);
            }else {
                //	 to do send buffer
                /* RFTraceSummary('send buffer');
                sbuffer.writeBytes(ba, 0, 1);
                sbuffer.writeByte(ba.length + 1);
                sbuffer.writeBytes(ba, 1, 0);
                try
                {
                    this.writeBytes(sbuffer);
                }catch(e : Error)
                {
                    trace("send buffer", sbuffer.length);
                } */
            }
        }

        private function onTimeEvent(e : TimerEvent) : void
        {
            //	ed.dispatchEvent(new RFEvent(RFEventString.DEBUG,[0,SentBytes,ReceivedBytes]))
            SentBytes = 0;
            ReceivedBytes = 0;
        }
        
        

        private function onConnect(event : Event) : void
        {	
            if(debug && timer == null)
            {
                timer = new Timer(1000);
                timer.addEventListener(TimerEvent.TIMER, onTimeEvent);
                timer.start();
            }
            if(ed)
				ed.dispatchEvent(event);
            RFTraceSummary('连接 socket服务器成功');
        }

        /**
         * 接收到数据  
         * @param event
         * 
         */
        private function onData(event : ProgressEvent = null) : void
        {
            RFTraceSummary(this.bytesAvailable + "Bytes in receive buffer");
            this.ReceivedBytes += this.bytesAvailable;
			if(!connected)
				return;
            if(this.header == false)
            {
                msgLength = this.readInt()
                this.header = true;
            }
            
            if(this.header)
            {
                if(this.bytesAvailable >= msgLength)
                {
                	this.readeBuffer = new ByteArray(); 
                    this.readBytes(readeBuffer, 0, msgLength);
                    decoder.decode(readeBuffer);
                    msgLength=0
                    this.header = false;
                    if(this.bytesAvailable > 3)
                    { 
                        this.onData();
                    }			
                } 
            }
        }
        
		public var decoder:IDecoder

        private function onIOError(event : IOErrorEvent) : void
        {
            if(debug && timer != null)
            {
                timer.removeEventListener(TimerEvent.TIMER, onTimeEvent);
                timer.stop();
                timer = null;
            }
            if(ed)
				ed.dispatchEvent(event);
			
            RFTraceSummary('发生io错误');
        }			

        /**
         *  发生 安全错误
         * @param event
         * 
         */
        private function onSecurityError(event : SecurityErrorEvent) : void
        {
            if(debug && timer != null)
            {
                timer.removeEventListener(TimerEvent.TIMER, onTimeEvent);
                timer.stop();
                timer = null;
            }
//            if(ed)
//				ed.dispatchEvent(event);

            RFTraceSummary('发生 安全错误 ');
        }	

        /**
         *  断开socket服务器连接 
         * @param event
         * 
         */
        private function onClose(event : Event) : void
        {
            if(debug && timer != null)
            {
                timer.removeEventListener(TimerEvent.TIMER, onTimeEvent);
                timer.stop();
                timer = null;
            }
            if(ed)
				ed.dispatchEvent(event);
				
            RFTraceSummary('断开socket服务器连接 ');
        }
    }
}