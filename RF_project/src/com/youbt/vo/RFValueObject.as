package com.youbt.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * RFValueObject
	 * 
	 * 用于实现可以出发Event.CHANGE的vo
	 * 
	 * 使用方法  实现一个继承RFValueObject的vo;
	 * 
	 * 如下方式，实现一个userName的属性，修改该属性让该vo 输出一个Event.CHANGE事件。
	 * 
	 * public function set userName(value:String):void
	 * {
	 * 		valueStorageObject.userName = value;
	 * }
	 * 		
	 * public function get userName():String
	 * {
	 * 		return valueStorageObject.userName ;
	 * }
	 *  
	 * @author eas
	 * 
	 */
	public class RFValueObject implements IValueObject
	{
		private var eventDispatcher:IEventDispatcher;
		
		public function RFValueObject()
		{
			eventDispatcher = new EventDispatcher(this);
		}
		
		public function get storageData():Object
		{
			if(!_valueStorageObject)
				return {};
			return _valueStorageObject.data;
		}
		
		
		private var _valueStorageObject:ValueStorageObject;
		protected function get valueStorageObject():ValueStorageObject
		{
			if(!_valueStorageObject)
			{
				_valueStorageObject = new ValueStorageObject(eventDispatcher);
			}
			return _valueStorageObject;
		}
		
		
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type,listener,useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
		
	}
}