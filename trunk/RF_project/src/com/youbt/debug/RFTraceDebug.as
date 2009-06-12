package com.youbt.debug
{
/**
* ab c
*/
		public function RFTraceDebug(user:String,message:String,...args):void
		{
			if(	DebugUtils.isDebugMode )
			{
				DebugUtils.debug(new DebugMessageVO(DebugUtils.DEBUG,user,new Date(),message,args));
			}
		}

}