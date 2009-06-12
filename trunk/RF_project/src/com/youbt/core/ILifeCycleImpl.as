package com.youbt.core
{
	import flash.events.Event;
	
	public interface ILifeCycleImpl
	{
		function initialize():void
		function start():void
		function sleep():void
		function dispose(event:Event=null):void
		
		function get initialized():Boolean
		function set initialized(value:Boolean):void
		
	}
}