package com.youbt.debug
{
	
	[ExcludeClass]
	public class ConsolePublisher extends AbstractDebugPublisher
	{
		public function ConsolePublisher()
		{
			super();
		}
		
		override protected function doPublish(debugMessage:DebugMessageVO):void
		{
			trace(debugMessage);
		}
		
		
		
		
	}
}