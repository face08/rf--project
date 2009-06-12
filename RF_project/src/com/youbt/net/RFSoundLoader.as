package com.youbt.net
{

	import com.youbt.events.RFLoaderEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class RFSoundLoader extends RFLoader implements ILoader
	{
		public function RFSoundLoader(url:*, id:String=null, ed:IEventDispatcher=null,autostart:Boolean=false)
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
		}
		private var _loader:Sound
		
		override protected function initialize():void{
	   	  _loader = new Sound()
	      if(!_request){
          	_request = new URLRequest(url); 
       	  }
          
		}
		override protected function remove():void{
		  super.remove()
		  _loader.removeEventListener(flash.events.Event.COMPLETE,onResult);
		  _loader.removeEventListener(flash.events.ProgressEvent.PROGRESS,onProgress);
		  _loader.removeEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
		  _loader.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
		  _loader.removeEventListener(flash.events.Event.OPEN,onOpen)
		}
		override public function dispose():void
		{
			_loader=null
			_ed=null
		}
		override public function load():void{
		
			super.load()
		    _loader.addEventListener(flash.events.Event.COMPLETE, onResult);
	        _loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR,onFault);
	        _loader.addEventListener(flash.events.ProgressEvent.PROGRESS,onProgress)
	        _loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR,onFault)
	        _loader.addEventListener(flash.events.Event.OPEN,onOpen)
			_loader.load(_request);
		}
		override protected function onResult(e:Event):void{
			super.onResult(e)
			dispatchEvent(new RFLoaderEvent(RFLoaderEvent.COMPLETE,false,false,e.currentTarget.bytesLoaded,e.currentTarget.bytesTotal,id,e.currentTarget,url))
			remove()
		}
		
		override protected function autocancel():void
		{
			if(_loader){
				try{
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
			 _loader = new Sound()
		}
		override public function cancel():void
		{
			if(_loader){
				try{
					_loader.close()
				}catch(e:Error){
					
				}
			}
			dispatchEvent(new RFLoaderEvent(RFLoaderEvent.CANCELED,false,false,0,0,id,null,url))
			remove()
		}
		override protected function get byteLoaded():Number
		{
			return _loader.bytesLoaded
		}
	}
}