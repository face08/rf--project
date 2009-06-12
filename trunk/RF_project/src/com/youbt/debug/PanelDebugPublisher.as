package com.youbt.debug
{
	import com.youbt.manager.RFSystemManager;
	
	public class PanelDebugPublisher extends AbstractDebugPublisher
	{
		public function PanelDebugPublisher()
		{
			super();
			
			DebugConsole.init(RFSystemManager.getInstance().stage)
		}
		
		override protected function doPublish(debugMessage:DebugMessageVO):void
		{
			
			switch(debugMessage.level)
			{
				case DebugUtils.DEBUG:
					DebugConsole.trace(debugMessage.toString());
				break;
				case DebugUtils.ERROR:
					DebugConsole.trace("<FONT COLOR='#FF0000'>"+debugMessage.toString()+"</FONT>");
				break;
				case DebugUtils.WARN:
					DebugConsole.trace("<FONT COLOR='#FFFF00'>"+debugMessage.toString()+"</FONT>");
				break;
				case DebugUtils.SUMMARY:
					DebugConsole.trace(debugMessage.toString());
				break;
			}
			
			
			
		}
	}
}