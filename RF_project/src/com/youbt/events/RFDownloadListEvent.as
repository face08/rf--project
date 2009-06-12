package com.youbt.events
{
	import flash.display.LoaderInfo;
	import flash.events.Event;

	public class RFDownloadListEvent extends Event
	{
		
		/**
		 * 新任务加入队列
		 */		
		public static const TASKADDED:String = "taskadded";
		/**
		 * 任务完成  返回 id 加载内容 url
		 */		
		public static const TASKCOMPLETE:String = "taskcomplete"
		/**
		 * 任务失败  返回 id url
		 */		
		public static const TASKFAILED:String = "taskfailed"
		/**
		 * 任务进度  返回 id 加载字节/总字节 任务载数量/任务队列数量
		 */		
		public static const TASKPROGRESS:String = "taskprogress"
		/**
		 * 队列完成 返回  已加载数量/队列数量 
		 */		
		public static const LISTCOMPLETE:String = "listcomplete"
		
		/**
		 * 队列结束 有错误 
		 */		
		public static const LISTEND:String="listend";
		
		public var taskid:String
		
		public var taskbyteloaded:int;
		
		public var taskbytetotal:int;
		
		public var totaltask:int
		
		public var loadedtask:int
		
		public var content:Object
		
		public var url:String;
		
		public var arguments:Object
		
		public var loaderinfo:LoaderInfo;
		
		public function RFDownloadListEvent(type:String, bubbles:Boolean=false,
		 cancelable:Boolean=false,
		 taskid:String=null,
		 taskbyteloaded:int=0,
		 taskbytetotal:int=0,
		 totaltask:int=0,
		 loadedtask:int=0,
		 content:Object=null,
		 url:String=null,
		 arguments:Object=null,
		 loaderinfo:LoaderInfo=null
		 )
		{
			super(type, bubbles, cancelable);
			this.taskid=taskid
			this.taskbyteloaded=taskbyteloaded
			this.taskbytetotal=taskbytetotal
			this.totaltask=totaltask
			this.loadedtask=loadedtask
			this.content=content
			this.url=url
			this.arguments=arguments
			this.loaderinfo=loaderinfo
			
			
		}
		
		override public  function clone():Event {
			return new RFDownloadListEvent(type,bubbles,cancelable,taskid,taskbyteloaded,taskbytetotal,totaltask,loadedtask,content,url,arguments,loaderinfo);
		}
		
	}
}