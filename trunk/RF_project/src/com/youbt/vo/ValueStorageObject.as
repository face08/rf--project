package com.youbt.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;


    
	dynamic internal class ValueStorageObject extends Proxy implements IValueObject
	{
		
		protected var _ieventDispatcher:IEventDispatcher;
		
		public function ValueStorageObject(ie:IEventDispatcher)
		{
			_ieventDispatcher = ie;	
		}
		
		private var _data:Object = {}
		
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_data[name] = value;
			if(hasEventListener(Event.CHANGE))
				dispatchEvent(new Event(Event.CHANGE));
	    }
	    
		override flash_proxy function getProperty(name:*):*
		{
			return _data[name];
		} 
		
		public function get data():Object
		{
			return _data;
		}
		
		//*******************************************
		//Ieventdispatcher impl
		//*******************************************

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_ieventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_ieventDispatcher.removeEventListener(type, listener,useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _ieventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _ieventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _ieventDispatcher.willTrigger(type);
		}
		
	}
}