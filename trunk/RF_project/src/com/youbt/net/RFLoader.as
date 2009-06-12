package com.youbt.net
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.debug.RFTraceWarn;
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.utils.NameUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;


	[Event(name="complete", type="com.youbt.events.RFLoaderEvent")]
	[Event(name="failed", type="com.youbt.events.RFLoaderEvent")]
	[Event(name="progress", type="com.youbt.events.RFLoaderEvent")]
	[Event(name="timeout", type="com.youbt.events.RFLoaderEvent")]

	public class RFLoader extends EventDispatcher implements ILoader
	{

		protected var _counter:int;
		protected var _request:URLRequest
		
		protected var _ed:IEventDispatcher;
		protected var isLoading:Boolean=false
		public var status:int
		
		
		/**
		 * 檢測超時 
		 */		
		public var checktimeout:Boolean=true
		
		/**
		 * 失敗自動重試 
		 */		
		public var autorety:Boolean=false
		
		/**
		 * 超時時間（秒） 
		 */		
		public var timeout:int=5
		
		/**
		 * 任務開始的時間 
		 */		
		public var startTime:Number
		
		/**
		 * 任務使用的時間
		 */		
		public var elapsedTime:Number
		
		/**
		 * 當前1秒的速度 如果檢測超時未開啟，則無法獲取當前速度
		 */		
		public var currentSpeed:Number=0;
		
		/**
		 * 平均速度 
		 */		
		public var avarageSpeed:Number=0;
		
		/**
		 * 重試次數 
		 */		
		public var triedcount:int=0
		
		/**
		 * 最大重试次数 
		 */		
		public var maxtry:int=3
			
		
		public var id:String;
		public var url:String;
		
		
//		public var argument:Object
		
	
		public function RFLoader(url:String,id:String=null,ed:IEventDispatcher=null){
		
		  this.status=STOP
		  if(!id){
		  	this.id=NameUtil.createUniqueName(this)
		  }else{
		  	this.id=id
		  }
		  if(!ed){
		  	_ed=this;
		  }else{
		  	_ed=ed
		  }
		  this.url=url;
		}
		
		
		public function get EventDispatcher():IEventDispatcher{
			return _ed
		}
		
		
		/**
		 * 开始加载 
		 * 
		 */		
		public function load():void{
		 
		  if(status!=timeout){
		  	status=PROGRESS
		  }
          _counter=0;
          if(checktimeout){
          	if(!timer){
          		timer=new Timer(1000,0);
          		timer.start() 
          	}
          	timer.addEventListener(TimerEvent.TIMER,timeouthandler)
          }
         
          
		}
		
		
		/**
		 * 重試 
		 * 
		 */		
		protected function retey():void
		{	
			triedcount++
			RFTraceWarn("auto retry "+triedcount+"/"+maxtry,this.url)
			status=TIMEOUT
			autocancel()
			load()
			
		}
		
		private static var timer:Timer
		
		protected function get byteLoaded():Number
		{
			//subclass must override this
			return 0;
		}
		
		
		
		private function timeouthandler(e:TimerEvent):void{
			if(_counter>timeout){
				if(autorety){
					if(status==PROGRESS){
						if(triedcount<maxtry){
							retey()
						}else{
							timer.removeEventListener(TimerEvent.TIMER,timeouthandler)
							dispatchEvent(new RFLoaderEvent(RFLoaderEvent.TIMEOUT,false,false,0,0,id,'',url))
						}
						return;
					}else if(status==TIMEOUT){
						timer.removeEventListener(TimerEvent.TIMER,timeouthandler)
						dispatchEvent(new RFLoaderEvent(RFLoaderEvent.TIMEOUT,false,false,0,0,id,'',url))
					}
				}else{
					timer.removeEventListener(TimerEvent.TIMER,timeouthandler)
					dispatchEvent(new RFLoaderEvent(RFLoaderEvent.TIMEOUT,false,false,0,0,id,'',url))
				}
			}
			_counter++;
			currentSpeed=(byteLoaded-downloaded)/1000
			downloaded=byteLoaded
			
			
		}		
		private var downloaded:Number=0;
		
		
		/**
		 * 自動取消 
		 * 
		 */		
		protected function autocancel():void
		{
			_counter=0
			timer.removeEventListener(TimerEvent.TIMER,timeouthandler)
		}

		protected function initialize():void{

		}
		protected function remove():void{
			
		   if(timer){
		   	 timer.removeEventListener(TimerEvent.TIMER,timeouthandler);
		   }
		}
		public function dispose():void
		{
			
		}
		
		
		/**
		 * 取消 
		 * 
		 */		
		public function cancel():void
		{
			
			status=ABORTED;
			_counter=0
			timer.removeEventListener(TimerEvent.TIMER,timeouthandler)
		}
		
		protected function onHttp(e:HTTPStatusEvent):void{
			
		}
		protected  function onResult(e:Event):void
        {
        	status=COMPLETE
          	
          	
        }
        protected function onStatus(e:HTTPStatusEvent):void{
			
		}
        
	    protected  function onFault(e:Event,txt:String=''):void
        {	
        	status=FAULT
        	if(e is SecurityErrorEvent){
        		txt=(e as SecurityErrorEvent).text
        	}
        	
        	if(e is IOErrorEvent){
        		txt=(e as IOErrorEvent).text
        	}
       		dispatchEvent(new RFLoaderEvent(RFLoaderEvent.FAILED,false,false,0,0,id,txt,url))
       		RFTraceError("加载错误",txt)
            remove() 
        } 
        protected function onProgress(e:ProgressEvent):void{
        	_counter=0;
        	var now:Date = new Date();
			var elapsedTime:Number = now.getTime() - this.startTime;
		 	avarageSpeed = (e.bytesLoaded / elapsedTime);
         	dispatchEvent(new RFLoaderEvent(RFLoaderEvent.PROGRESS,false,false,e.bytesLoaded,e.bytesTotal,id,null,url))
        }
        protected function onOpen(e:Event):void
        {
			startTime = new Date().getTime();
        }
        
        override public function dispatchEvent(event:Event):Boolean
        {
        	if(_ed){
        		if(_ed!=this){
        			_ed.dispatchEvent(event)
        		}
        	}
        	return super.dispatchEvent(event)
        }
        
        
        /**
         * 在队列中如果未开始，则标记为STOP 
         */        
        public static var STOP:int=0;
		/**
		 * 在队列中排队 
		 */        
		public static var QUEUED:int=1;
		
		/**
		 * 下载中 
		 */		
		public static var PROGRESS:int=2;
		
		/**
		 * 超时 
		 */		
		public static var TIMEOUT:int=3;
		
		/**
		 * 失败 
		 */		
		public static var FAULT:int=4;
		
		/**
		 * 完成 
		 */		
		public static var COMPLETE:int=5;
		
		/**
		 * 取消 
		 */		
		public static var ABORTED:int=6;
        
	}
}