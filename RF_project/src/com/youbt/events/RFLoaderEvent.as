package  com.youbt.events
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class RFLoaderEvent extends ProgressEvent
	{
		
		
		public static const COMPLETE:String = "rf_complete";
		public static const FAILED:String = "rf_failed";
		public static const TIMEOUT:String = "rf_timeout";
		public static const PROGRESS:String = "rf_progress";
		public static const CANCELED:String = "rf_canceled";
		public static const AUTORETRY:String="rf_autoretry";
		 
		
		
		public function RFLoaderEvent(type:String, bubbles:Boolean=false,
										 cancelable:Boolean=false, 
										 bytesLoaded:uint=0, bytesTotal:uint=0,id:String=null,result:Object=null,url:String=null,loaderinfo:LoaderInfo=null,
										 arg:Object=null)
		{
			super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
			this.result=result
			this.id=id
			this.url=url
			this.loaderinfo=loaderinfo
			this.arg=arg;
		}
		
		public var result:Object
		public var id:String
		public var url:String
		public var loaderinfo:LoaderInfo
		public var arg:Object;
		
		override public function clone():Event
		{
		return new RFLoaderEvent(type, bubbles, cancelable,
							bytesLoaded, bytesTotal, id,result,url,loaderinfo,arg);
		}
		override public function toString():String{
			return this.id+"_"+super.toString()
		}
	}
}