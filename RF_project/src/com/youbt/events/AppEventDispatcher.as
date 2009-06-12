package com.youbt.events
{
	import com.youbt.debug.RFTraceWarn;
	import com.youbt.manager.RFSystemManager;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AppEventDispatcher extends EventDispatcher
	{
		public function AppEventDispatcher()
		{
			if(_instance)
				RFTraceWarn("Singleton error");
				
			_sys=RFSystemManager.getInstance()
		}
		
		private static var _instance:AppEventDispatcher
		public static function getInstance():AppEventDispatcher{
			if(!_instance)
				_instance=new AppEventDispatcher
			return _instance
		}
		private var _sys:RFSystemManager;
		
		override public function dispatchEvent(event:Event):Boolean{
			if(_sys.checkEvent(event)){
				return super.dispatchEvent(event)
			}
			return false
		}
	}
}