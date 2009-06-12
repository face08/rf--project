package com.youbt.dragger{

	import flash.display.Sprite;
	
	public interface IDropMotion{
		
		/**
		 * Starts the drop motion and remove the dragObject from its parent when motion is completed.
		 * @param dragInitiator the drag initiator
		 * @param dragObject the display object to do motion
		 */
		function startMotionAndLaterRemove(dragInitiator:AbstractDragger, dragObject:Sprite):void;
		
		/**
		 * A new drag is started, so the last motion should be stopped if it is still running.
		 */
		function forceStop():void;
			
	}
}