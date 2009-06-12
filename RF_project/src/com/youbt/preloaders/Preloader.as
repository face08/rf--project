package  com.youbt.preloaders
{
	import com.youbt.debug.RFTraceSummary;
	import com.youbt.events.RFEvent;
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.manager.RFSystemManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	[Frame(factoryClass="com.youbt.manager.RFSystemManager")]
	
/**
 *  The Preloader class is used by the SystemManager to monitor
 *  the download and initialization status of a RF application.
 *
 *  <p>The Preloader class instantiates a download progress bar, 
 *  which must implement the IPreloaderDisplay interface, and passes download
 *  and initialization events to the download progress bar.</p>
 *
 *  @see com.youbt.manager.RFSystemManager
 */
	
	
	public class Preloader extends MovieClip 
	{
		public function Preloader()
		{
			super();
			RFTraceSummary("Preloader created attt",this.currentFrame)
			addEventListener(Event.ADDED_TO_STAGE,addedHandler)
		}
		private function addedHandler(e:Event):void{
			initialize()
		}
		
		protected function initialize():void{
			stage.addEventListener(Event.RESIZE,stageresizeHandler)
			RFSystemManager.getInstance().addEventListener(RFLoaderEvent.PROGRESS,loadprogressHandler)
			RFSystemManager.getInstance().addEventListener(RFLoaderEvent.COMPLETE,loadcompleteHandler)
			RFSystemManager.getInstance().addEventListener(RFEvent.PREINITIALIZE,preinitHandler)
			RFSystemManager.getInstance().addEventListener(RFEvent.INIT_PROGRESS,initprogressHandler)
			RFSystemManager.getInstance().addEventListener(RFEvent.INIT_COMPLETE,initcompleteHandler)
			RFSystemManager.getInstance().addEventListener(RFEvent.CREATION_COMPLETE,createcompleteHandler)
			
		}
	
		protected function createcompleteHandler(e:RFEvent):void{
			removeListeners()
		}
		private function removeListeners():void
		{
			if(stage){
				stage.removeEventListener(Event.RESIZE,stageresizeHandler)
			}
			RFSystemManager.getInstance().removeEventListener(RFLoaderEvent.PROGRESS,loadprogressHandler)
			RFSystemManager.getInstance().removeEventListener(RFLoaderEvent.COMPLETE,loadcompleteHandler)
			RFSystemManager.getInstance().removeEventListener(RFEvent.PREINITIALIZE,preinitHandler)
			RFSystemManager.getInstance().removeEventListener(RFEvent.INIT_PROGRESS,initprogressHandler)
			RFSystemManager.getInstance().removeEventListener(RFEvent.INIT_COMPLETE,initcompleteHandler)
			RFSystemManager.getInstance().removeEventListener(RFEvent.CREATION_COMPLETE,createcompleteHandler)
		}
		protected function loadprogressHandler(e:RFLoaderEvent):void{
			// to be override
		}
		
		protected function loadcompleteHandler(e:RFLoaderEvent):void{
			// to be override
			
		}

		protected function preinitHandler(e:RFEvent):void{
			// to be override
		}
		protected function initprogressHandler(e:RFEvent):void{
			// to be override
		}
		
		protected function initcompleteHandler(e:RFEvent):void{
			// to be override
		}
		protected function stageresizeHandler(e:Event):void{
			// to be override
		}
		
		public function dispose():void
		{
			removeListeners()
		}
	}
}