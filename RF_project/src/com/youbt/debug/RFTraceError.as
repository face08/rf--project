package com.youbt.debug
{

		public function RFTraceError(message:String , ...args):void
		{
			if(DebugUtils.isDebugMode)
			{
				DebugUtils.debug(new DebugMessageVO(DebugUtils.ERROR,'system',new Date(),message,args));
			}
		}


}