package com.youbt.debug
{

		public function RFTraceSummary(message:String,...args):void
		{
			if(DebugUtils.isDebugMode)
			{
				DebugUtils.debug(new DebugMessageVO(DebugUtils.SUMMARY,'system',new Date(),message,args));
			}
		}

}