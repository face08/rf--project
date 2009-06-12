package com.youbt.preloaders
{
	import com.youbt.core.UIComponent;
	
	import flash.display.Shape;
	import flash.text.TextField;

	public class ProgressBar extends UIComponent
	{
		
		public function ProgressBar(skin:Class=null)
		{
			_skin=skin
		}
		
		protected var _skin:Class;
		
		override public function initialize():void
		{
		}
		public function progress(progressobj:Object):void{
			
		}
		
		
		
	}
}