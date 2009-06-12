package com.youbt.events
{
	import flash.events.Event;
	
	public class PanelEvent extends Event
	{
		public static const SHOW:String="panel_show";
		public static const HIDE:String="panel_hide";
		
		public static const CLOSE:String="panel_close";
		
		public static const MOTION_FINISHED:String="panel_motion_finished";
		public function PanelEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}

	}
}