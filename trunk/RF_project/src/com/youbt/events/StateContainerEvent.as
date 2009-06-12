package com.youbt.events
{
	import flash.events.Event;

	public class StateContainerEvent extends Event
	{
		public static const SWITCH_TO_STATE:String = 'StateManagerEvent_SwitchToState';
		public static const SWITCHED_TO_STATE:String = 'StateManageEvent_SwitchedToState';


		public var StateName:String
		public function StateContainerEvent(type:String, stateName:String=null)
		{
			StateName = stateName;
			super(type, true,false);
		}
		
		override public function clone():Event
		{
			return new StateContainerEvent(type,StateName);
		} 
		
	}
}