package com.youbt.plugins
{
	import com.youbt.core.RFSprite;
	import com.youbt.events.RFEvent;
	import com.youbt.manager.RFSystemManager;


	public class RFPlugAppContainer extends RFSprite
	{
		public function RFPlugAppContainer()
		{
			
			RFSystemManager.getInstance().addEventListener(RFEvent.INITIALIZE,initHandler);
			/* if(isPlug())
			{
				trace('app run in plug mode');
				return;
			}else
			{
				startSinglonMode();
			} */
		}
		
		protected function initHandler(e:RFEvent):void
		{
			RFSystemManager.getInstance().removeEventListener(RFEvent.INITIALIZE,initHandler);
			
			_isPlugin=e.isPlugin;
			
			RFSystemManager.getInstance().dispatchEvent(new RFEvent(RFEvent.CREATION_COMPLETE))
		}
		
		private var _isPlugin:Boolean=false;
		
		public function isPlug():Boolean
		{
		/* 	if(!loaderInfo )
			{return false;}
			return loaderInfo.loaderURL != loaderInfo.url; */
			return _isPlugin;
		}
		
		public function startSinglonMode():void
		{
			throw new Error('this function should been overrid');
		}
		
	}
}