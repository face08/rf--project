package com.youbt.dragger{
	
	import flash.display.Sprite;
	
	public class DirectlyRemoveMotion implements IDropMotion{
		
		public function startMotionAndLaterRemove(dragInitiator:AbstractDragger, dragObject:Sprite):void
		{
			if(dragObject.parent != null){
				dragObject.parent.removeChild(dragObject);
			}
		}
		
		public function forceStop():void{
		}	
	}
}