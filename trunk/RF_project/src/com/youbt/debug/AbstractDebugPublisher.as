package com.youbt.debug
{
	
	[ExcludeClass]
	public class AbstractDebugPublisher implements IDebugPublisher
	{
		public function AbstractDebugPublisher()
		{
		}
		
		public function publish(debugMessage:DebugMessageVO):void
		{
			if(isPublishAble(debugMessage))
				doPublish(debugMessage);
		}
		
		protected function doPublish(debugMessage:DebugMessageVO):void
		{
			//format(debugMessage);
		}
		
		
		protected function format(debugMessage:DebugMessageVO):String
		{
			//do formatter
			return debugMessage.toString()
		}
		
		protected function isPublishAble(debugMessage:DebugMessageVO):Boolean
		{
			return true;
		}
		
		/* public function set publishFilter(filter):void
		{
		}
		public function get publishFilter():*
		{
			
		} */
	}
}