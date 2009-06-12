package com.youbt.net
{
	import com.youbt.events.RFLoaderEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	
	
	public class RFSWFLoader extends RFLoader implements ILoader
	{
		public function RFSWFLoader(url:String,id:String=null,ed:IEventDispatcher=null,autostart:Boolean=false,refresh:Boolean=false,
		useCurrentDomain:Boolean=false)
		{
			_refresh=refresh
			_useCurrentDomain=useCurrentDomain
			super(url,id,ed)
			initialize()
			if(autostart){
				 load()
			}
			
		}
		
		private var _loader:Loader
		private var _refresh:Boolean
		private var _useCurrentDomain:Boolean
		
		
		override protected function initialize():void{
	   	  _loader = new Loader;
	      _request = new URLRequest(url); 
	      if(_refresh){
	      		var varb:URLVariables=new URLVariables()
	     	 	varb.random=Math.random()
	      		_request.data=varb;
	      }
	      
	      	      	
	      _lc=new LoaderContext()
         // _lc.applicationDomain=ApplicationDomain.currentDomain
         	 if(_useCurrentDomain){
          		_lc.checkPolicyFile=true
          		_lc.applicationDomain=ApplicationDomain.currentDomain
          	 }
		}
		private var _lc:LoaderContext
		
		public function set applicationDomain(value:ApplicationDomain):void
		{
			_lc.applicationDomain=value
		}
		override protected function remove():void{
		  super.remove()
		  if( _loader){
		  	
		  	  _loader.contentLoaderInfo.removeEventListener(Event.OPEN,onOpen)
		 	  _loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE,onResult);
			  _loader.contentLoaderInfo.removeEventListener(flash.events.ProgressEvent.PROGRESS,onProgress);
			  _loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
			  _loader.contentLoaderInfo.removeEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS,onHttp);
  	  	  }
  	  	
  		  
		}
		override public function dispose():void
		{
		  _loader=null;
  		  _ed=null; 
  		  _request=null
		}
		override public function load():void{
			super.load()
			_loader.contentLoaderInfo.addEventListener(Event.OPEN,onOpen)
          	_loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onResult);
	      	_loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
	      	_loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS,onProgress)
	      	_loader.contentLoaderInfo.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS,onHttp);
			_loader.load(_request,_lc)
		}
		override protected function onResult(e:Event):void{
			super.onResult(e)
			remove()
			dispatchEvent(new RFLoaderEvent(RFLoaderEvent.COMPLETE,false,false,e.currentTarget.bytesLoaded,e.currentTarget.bytesTotal,id,Loader(e.currentTarget.loader),this.url,LoaderInfo(e.currentTarget)))	
			
		}
		override protected function autocancel():void
		{
			if(_loader){
				try{
					_loader.unload()
					_loader.close()
		  			 _loader.removeEventListener(flash.events.Event.COMPLETE,onResult);
		  			_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onProgress);
		  			_loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
		  			_loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
		  			_loader.removeEventListener(flash.events.Event.OPEN,onOpen)
		  			_loader=null
		  			_loader=null
				}catch(e:Error){
					
				}
			}	
			initialize()
		}
		override public function cancel():void
		{
			if(_loader){
				try{
					_loader.unload()
					_loader.close()
					_loader.removeEventListener(flash.events.Event.COMPLETE,onResult);
		  			_loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onProgress);
		  			_loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
		  			_loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
		  			_loader.removeEventListener(flash.events.Event.OPEN,onOpen)
		  			_loader=null
				}catch(e:Error){
					
				}
			}	
			dispatchEvent(new RFLoaderEvent(RFLoaderEvent.CANCELED,false,false,0,0,id,null,url))
			remove()
			
		}
		override protected function get byteLoaded():Number
		{
			if(_loader){
				if(_loader.contentLoaderInfo){
					return _loader.contentLoaderInfo.bytesLoaded;
				}
			}
			return 0;
		}
		
	/* 	override protected function onProgress(e:ProgressEvent):void
		{
			super.onProgress(e)
			if(this.byteLoaded>50000 && triedcount<2){
				retey()
				
			}
			
		} */
	}
}