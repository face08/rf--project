package com.youbt.preloaders
{
	import flash.events.Event;

	public class ModelProgressCancelEvent extends Event
	{
		public static const PROGRESS_CANCEL:String = 'PROGRESS_CANCEL';
		public function ModelProgressCancelEvent(progressId_:String)
		{
			super(PROGRESS_CANCEL,false,false);
			progressId = progressId_;
		}
		
		public var progressId:String;
		
	}
}