package com.youbt.events
{
	import flash.events.Event;
	
	public class ConnectionEvent extends Event
	{
	
		public static const ONDATA:String="ondata"
		public static const ONCONNECTED:String="onconnect"
		public static const ONEXCEPTION:String="onexception"
		public static const ONDISCONNECT:String="ondisconnect";
		public static const ONLOSTCONNECT:String="onlostconnect";
		
		
		public var data:Object;
		public var source:String;
		public function ConnectionEvent(type:String,source:String=null,data:Object=null)
		{
			super(type);
			this.source=source
			this.data=data;
			
			
		}
		override public  function clone():Event {
			return new ConnectionEvent(type,source,data)
		}

	}
}