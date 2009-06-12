package com.youbt.events
{
	import flash.events.Event;
	
	public class UIComponentEvent extends Event
	{
		
		public static const START:String = 'UIComponentEvent_Start';
		public static const SLEEP:String = 'UIComponentEvent_Sleep';
		public static const INITIALIZED:String='UIComponentEvent_Initialized';
		
		public var Data:* ;
		public function UIComponentEvent(type:String, data:* = null)
		{
			Data = data;
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new UIComponentEvent(type,Data);
		}
		
	}
}