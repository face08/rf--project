package com.youbt.dragger{

	import flash.display.*;
	
	public class DefaultDragImage implements IDraggingImage{
		
		private var image:Shape;
		private var width:int;
		private var height:int;
		
		public function DefaultDragImage(dragInitiator:DisplayObject){
			width = dragInitiator.width;
			height = dragInitiator.height;
			
			image = new Shape();
		}
		
		public function getDisplay():DisplayObject
		{
			return image;
		}
		
		public function switchToRejectImage():void
		{
			image.graphics.clear();
			var r:Number = Math.min(width, height) - 2;
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = width;
			var h:Number = height;
			
			var e:Number=5;
			
			
			var g:Graphics = image.graphics;
			g.beginFill(0x333333);	
			g.drawRoundRect( x, y, w, h,e,e);
		}
		
		public function switchToAcceptImage():void
		{
			image.graphics.clear();
			var g:Graphics = image.graphics;
			g.beginFill(0x333333);	
			g.drawRect(0, 0, width, height);
		}
		
	}
}