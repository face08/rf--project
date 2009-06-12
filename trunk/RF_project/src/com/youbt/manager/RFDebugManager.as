package  com.youbt.manager
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	public  class RFDebugManager 
	{

		
		private var ed:IEventDispatcher;
		
		//private var output:*
		public function RFDebugManager(container:DisplayObjectContainer,ed:IEventDispatcher){
			/* DisplayContent=new c()
			container.addChild(this.DisplayContent)
			DisplayContent.x=300;
			DisplayContent.y=300;
			addDrag(DisplayContent.bg)
			this.ed=ed;
			this.ed.addEventListener(RFEventString.DEBUG,debughandler)
			this.ed.addEventListener(RFEventString.NetEception,tracehandler) */
		}
	//	private function debughandler(e:RFEvent):void{
		//	(DisplayContent.sp0 as TextField).text=((e.data[1] as Number)/1024).toFixed(2).toString()+"kb/s";
		//	(DisplayContent.sp1 as TextField).text=((e.data[1] as Number)/1024).toFixed(2).toString()+"kb/s";
		//	trace(e.data)
	//	}
	//	private function tracehandler(e:RFEvent):void{
		//	(DisplayContent.output as TextField).appendText(e.data)
		//	trace(e.data)
	//	}
	}
}