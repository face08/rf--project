package com.youbt.net
{
	public interface IDownloadList
	{
		/**
		 *用于开始列表 
		 * 
		 */		
		function start():void
		
		
		/**
		 * 忽略加载状态，直接结束 
		 * 
		 */		
		function omitStop():void
		
		
		function addTask(url:String,method:int=3,id:String=null,autoStart:Boolean=true,autoretry:Boolean=true):RFLoader
		
		function addTaskObject(task:RFLoader):String
		
		function startTask(url:String):void
	}
}