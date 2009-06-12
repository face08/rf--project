package com.youbt.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	
	public interface IUIComponent extends IEventDispatcher
	{
		function get enabled():Boolean;
		function set enabled(value:Boolean):void
		function get isPopUp():Boolean;
		function set isPopUp(value:Boolean):void
		function get owner():DisplayObjectContainer
		function set owner(value:DisplayObjectContainer):void
		function get initialized():Boolean
		function set initialized(value:Boolean):void
		
		
		//-----------
		//-------------
		function initialize():void
		function owns(displayobjcet:DisplayObject):Boolean
	}
}