package com.youbt.resources
{
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.rpc.RemoteToken;
	
	public class ResourceToken extends RemoteToken
	{
		public function ResourceToken(name:String='')
		{
			addEventListeners()
			super("Resourece Operation"+name)
		}
		
		private function addEventListeners():void{
			
			
			addEventListener(RFLoaderEvent.COMPLETE,completeHandler,false,0,true)
		}
		private function completeHandler(e:RFLoaderEvent):void{
			
			removeEventListener(RFLoaderEvent.COMPLETE,completeHandler)
			
		}
		public var data:Object
		
		
	}
}