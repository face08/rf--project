package com.youbt.controls
{
	import flash.display.DisplayObject;
	
	public interface IController
	{
		function setView(view:DisplayObject):void;
		function getView():DisplayObject;
		function setModel(model:Object):void;
		function getModel():Object;
	}
}