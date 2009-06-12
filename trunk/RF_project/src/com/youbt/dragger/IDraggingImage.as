package com.youbt.dragger{

	import flash.display.DisplayObject;

	public interface IDraggingImage{
	
		/**
		 * Returns the display object for the representation of dragging.
		 */
		function getDisplay() : DisplayObject ;
		
		/**
		 * Paints the image for accept state of dragging.(means drop allowed)
		 */
		function switchToAcceptImage() : void ;
		
		/**
		 * Paints the image for reject state of dragging.(means drop not allowed)
		 */
		function switchToRejectImage() : void ;	
	}
}