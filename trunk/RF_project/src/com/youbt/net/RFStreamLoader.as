package com.youbt.net
{
	import com.youbt.debug.RFTraceWarn;
	import com.youbt.events.RFLoaderEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class RFStreamLoader extends RFLoader
	{
		public function RFStreamLoader(url:*, id:String=null, ed:IEventDispatcher=null,autostart:Boolean=false,refresh:Boolean=false,
		useCurrentDomain:Boolean=true)
		{
			var _url:String
			if(url is URLRequest){
				_request=url
				_url=_request.url;
			}else{
				_url=url
			}
			super(_url, id, ed);
			initialize()
			if(autostart){
				 load()
			}
			this.useCurrentDomain=useCurrentDomain
			timeout=8;
		}
		private var useCurrentDomain:Boolean=true
		private var _loader:URLStream;
		override protected function initialize():void{
	   	  _loader = new URLStream()
	      if(!_request){
          	_request = new URLRequest(url);
          //	_request.requestHeaders.push(new URLRequestHeader("Ranged","bytes=166018-"));
       	  }
       	  ba=new ByteArray()
		}
		
		
		
		
		private var range:Number=0;
		private var ba:ByteArray;
		
		public var resume:Boolean=true;
		
						
		override public function load():void
		{
			super.load()
		   _loader.addEventListener(Event.OPEN,onOpen)
	   	   _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
       	   _loader.addEventListener(flash.events.Event.COMPLETE, onResult);
	   	   _loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
	   	   _loader.addEventListener(flash.events.ProgressEvent.PROGRESS,onInitialProgress,false,1)
	   	   _loader.addEventListener(flash.events.ProgressEvent.PROGRESS,onProgress)
	   	   _loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
	   	   
	   	   if(resume && siteSupport){
				if(range!=0){
					var par:URLVariables=new URLVariables()
					_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onInitialProgress)
					par.range=range
					_request.method=URLRequestMethod.POST
					_request.data=par;
				}
			}
	   	   
		   _loader.load(_request);
		}
		
		private function packagebytearray():void
		{
			var sa:ByteArray=new ByteArray()
			if(!_loader){
				return
			}
			if(_loader.bytesAvailable>0)
			{
				_loader.readBytes(sa)
			}
			ba.writeBytes(sa)
			
			range=ba.length;
			
		}
		
		override protected function remove():void{
		  super.remove()
	 	  if(_loader){
		  	_loader.removeEventListener(Event.OPEN,onOpen)
		  	_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
		  	_loader.removeEventListener(flash.events.Event.COMPLETE,onResult);
		  	_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onProgress);
		  	_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onInitialProgress)
		  	_loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
		  	_loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
		  } 
		}
		override public function dispose():void
		{
			
			if(_loader){
				try{
					_loader.close()
				}catch(e:Error){
				}
			}
			remove()
			_loader=null
			_ed=null
			if(result){
				if(result.contentLoaderInfo){
					result.contentLoaderInfo.removeEventListener(Event.COMPLETE,dispatchSuccess)
				}
			} 
			result=null
		}
		override protected function onResult(e:Event):void{
			
			packagebytearray()
			 
			if(ba.length == 0){
				onFault(e,"stream length = 0")
			}else{
				result=new Loader()
				result.contentLoaderInfo.addEventListener(Event.COMPLETE,dispatchSuccess,false,0,true)
				result.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError)
				if(useCurrentDomain){
						var context:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
						result.loadBytes(ba,context)
					}else{
						result.loadBytes(ba)
				}
			}
			if(_loader){
				_loader.removeEventListener(flash.events.Event.COMPLETE,onResult);
			}
			
		}
		private function ioError(e:IOErrorEvent):void
		{
			result.contentLoaderInfo.removeEventListener(Event.COMPLETE,dispatchSuccess)
			result.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError)
			super.onResult(null) 
			dispatchEvent(new RFLoaderEvent(RFLoaderEvent.COMPLETE,false,false,bytestotal,byteLoaded,id,ba,url))
		}
		
		
		private var result:Loader
		private function dispatchSuccess(e:Event=null):void
		{
			super.onResult(null) 
			if(e){
				result.contentLoaderInfo.removeEventListener(Event.COMPLETE,dispatchSuccess)
				dispatchEvent(new RFLoaderEvent(RFLoaderEvent.COMPLETE,false,false,bytestotal,ba.length,id,result,url,null,ba))
			}
			
			
			remove()
		}
		
		
		
		override protected function retey():void
		{
			
			
			if(siteSupport){
				packagebytearray()
				RFTraceWarn("自动重试断点续传",range)
			}else{
				RFTraceWarn("自动重试不支持断点续传")
			}
			 
			super.retey()
			
		}
		
		
		override protected function onProgress(e:ProgressEvent):void
		{
			
			
			/* if(e.bytesTotal==0 && resume){
				RFTraceWarn("文件大小未知，不进行支持断点续传");
				resume=false;
			} */
			
			
			
			if(e.bytesTotal==bytestotal && siteSupport && triedcount>0){
				siteSupport=false
				RFTraceWarn("检测发现站点不支持断点续传");
			}
			
			if(_loader.bytesAvailable+ba.length>=bytestotal && bytestotal!=0){
				onResult(null)
				return;
			}
			
		 	/*  if(_loader.bytesAvailable>int(bytestotal/10) && triedcount<2){
				//trace(bytestotal,byteLoaded)
				retey()
				e.bytesLoaded=ba.length
			}else{
				e.bytesLoaded=ba.length+e.bytesLoaded;
			} */
			
			e.bytesLoaded=ba.length+e.bytesLoaded;
			e.bytesTotal=bytestotal;
			super.onProgress(e)
		}
		private var siteSupport:Boolean=true;
		
		override protected function autocancel():void
		{
			if(_loader){
		  		_loader.removeEventListener(Event.OPEN,onOpen)
		  		_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,onStatus);
		 	 	_loader.removeEventListener(flash.events.Event.COMPLETE,onResult);
		  		_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onProgress);
		  		_loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
		 	 	_loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
		 	 	if(_loader.connected){
		 	 		_loader.close()
		 	 	}
		 	 	_loader=null
			  }
			 _loader = new URLStream()
		}
		override public function cancel():void{
			if(_loader){
				_loader.close()
			}
			dispatchEvent(new RFLoaderEvent(RFLoaderEvent.CANCELED,false,false,0,0,id,null,url))
			remove()
		}
		
		override protected function get byteLoaded():Number
		{
			if(_loader){
				return _loader.bytesAvailable+ba.length
			}
			return ba.length
		}
		
	/* 	private var _bt:int=0;
		private function set  bytestotal(vl:int):void
		{
			_bt=vl	
		}
		
		private function get  bytestotal():int
		{
			return _bt;
		} */
		private var bytestotal:int=0;
		
		private function onInitialProgress(e:ProgressEvent):void
		{
			_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onInitialProgress)
			bytestotal=e.bytesTotal
			
		}
		
		override protected function onFault(e:Event, txt:String=''):void
		{
			super.onFault(e,txt)
		}
	}
}