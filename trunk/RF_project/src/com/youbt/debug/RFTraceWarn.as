package com.youbt.debug
{

		public function RFTraceWarn(message:String,...args):void
		{
			if(DebugUtils.isDebugMode)
			{
				DebugUtils.debug(new DebugMessageVO(DebugUtils.WARN,'system',new Date(),message,args));
			}	
		}

}