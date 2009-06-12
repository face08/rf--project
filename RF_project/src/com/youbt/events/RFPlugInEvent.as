package com.youbt.events
{
	public class RFPlugInEvent extends RFEvent
	{
		public function RFPlugInEvent(type:String, plugGuid:String, data:Object )
		{
			this.plugGuid = plugGuid;
			Data = data;
			super(type, isPlugin, bubbles, cancelable);
		}
		
		public var plugGuid:String;
		public var Data:Object;
		
		public static const  PLUGINEVENT_CALLBACK:String = "pluginevent_callback";
		
	}
}