package com.youbt.net
{
	import com.youbt.debug.RFTraceWarn;
	import com.youbt.events.RFDownloadListEvent;
	import com.youbt.events.RFLoaderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;


	[Event(name="taskcomplete", type="com.youbt.events.RFDownloadListEvent")]
	
	[Event(name="taskfailed", type="com.youbt.events.RFDownloadListEvent")]
	
	[Event(name="taskprogress", type="com.youbt.events.RFDownloadListEvent")]
	
	[Event(name="listcomplete", type="com.youbt.events.RFDownloadListEvent")]

	public class DownloadList extends EventDispatcher implements IDownloadList
	{
		
		protected var _ed:IEventDispatcher;
		protected var _list:Array
				
		public var TotalTask:int=0;
		public var CompletedTask:int=0;
		public var RunningTask:int=0;
		public var FailedTask:int=0;
		public var QueuedTask:int=0;
		public var AbortedTask:int=0;
		public var StopTask:int=0;
		
		
		/**
		 * LOADER 加载 ，支持SWF,PNG,JPEG,GIF 
		 */		
		public static var SWFMETHOD:int=0;
		
		/**
		 * URLLOADER  
		 */		
		public static var URLMETHOD:int=1;
		
		/**
		 * MP3 
		 */		
		public static var SOUNDMETHOD:int=2
		
		/**
		 * 二进制文件，可以断点续传，如果是LOADER不支持的内容，则抛出BYTEARRAY 
		 */		
		public static var STREAMMETHOD:int=3;
		
		
		public function DownloadList(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function start():void
		{  // to be override
		}
		
		public function omitStop():void
		{  // to be override
		}
		
		public function addTask(url:String,method:int=3, id:String=null, autoStart:Boolean=true,autoretry:Boolean=true):RFLoader
		{
			  // to be override
			  return null
		}
		public function addTaskObject(task:RFLoader):String{
			return null
		}
		
		public function startTask(url:String):void{
			 // to be override
		}
		
		/**
		 * Clear download list 
		 * 
		 */		
		public function clearlist():void{
			for each (var task:RFLoader in _list){
				task.dispose()
				task.removeEventListener(RFLoaderEvent.PROGRESS,taskprogressHandler)
				task.removeEventListener(RFLoaderEvent.FAILED,failedHandler)
				task.removeEventListener(RFLoaderEvent.COMPLETE,taskcompleteHandler)
			}
			_list=[]
			TotalTask=0
			CompletedTask=0
			FailedTask=0
			RunningTask=0
			QueuedTask=0
			AbortedTask=0
			StopTask=0;
			
		}
		/**
		 * GET download list 
		 * @return 
		 * 
		 */		
		public function getAllTask():Array{
			return _list
		}
		/**
		 * get a specific task by task id 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getTask(id:String):RFLoader{
			for each (var task:RFLoader in _list){
				if(task.id==id)
					return task
			}
			return null
		}
		/**
		 * abort specific task by task id 
		 * @param id
		 * 
		 */		
		public function abortTask(id:String):void{
			var task:RFLoader=getTask(id)
			if(task){
				task.status=RFLoader.ABORTED;
				refreshList()
			}
			
				
		}
		/**
		 *  refresh status of all the tasks 
		 * 
		 */		
		protected function refreshList():void{
			var ct:int=0
			var qt:int=0
			var ft:int=0;
			var rt:int=0
			var at:int=0
			var st:int=0;
			for each (var i:RFLoader in _list){
				if(i.status==RFLoader.COMPLETE){
					ct++
				}else if(i.status==RFLoader.QUEUED){
					qt++
				}else if(i.status==RFLoader.FAULT){
					ft++
				}else if(i.status==RFLoader.PROGRESS){
					rt++
				}else if(i.status==RFLoader.ABORTED){
					at++
				}else if(i.status==RFLoader.STOP){
					st++
				}
			}
			TotalTask=_list.length
			CompletedTask=ct
			FailedTask=ft
			RunningTask=rt
			QueuedTask=qt
			StopTask=st;
			AbortedTask=at;
			/* if(TotalTask==CompletedTask){
				notifytaskcomplete()
			} */
		}
		
		/**
		 * 
		 * 
		 */		
		protected function notifyalltaskcomplete():void{
			dispatchEvent(new RFDownloadListEvent(RFDownloadListEvent.LISTCOMPLETE,
				false,false,null,0,0,TotalTask,CompletedTask))
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		protected function taskprogressHandler(e:RFLoaderEvent):void{
			dispatchEvent(new RFDownloadListEvent(RFDownloadListEvent.TASKPROGRESS,
			false,false,e.id,e.bytesLoaded,e.bytesTotal,TotalTask,CompletedTask,null,e.url))
			
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		protected function failedHandler(e:RFLoaderEvent):void{
			RFTraceWarn("downloadlist taskfailed",e.result,e.url)
			dispatchEvent(new RFDownloadListEvent(RFDownloadListEvent.TASKFAILED,
			false,false,e.id,0,0,TotalTask,CompletedTask,e.result,e.url))
		}
		/**
		 * 
		 * @param e
		 * 
		 */		
		protected function taskcompleteHandler(e:RFLoaderEvent):void{
			
			dispatchEvent(new RFDownloadListEvent(RFDownloadListEvent.TASKCOMPLETE,
			false,false,e.id,e.bytesLoaded,e.bytesTotal,TotalTask,CompletedTask,e.result,e.url,e.loaderinfo))	
			
		}
		protected function notifytaskend():void
		{
			dispatchEvent(new RFDownloadListEvent(RFDownloadListEvent.LISTEND,
				false,false,null,0,0,TotalTask,CompletedTask))
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			if(_ed){
				if(_ed!=this){
					_ed.dispatchEvent(event)		
				}
			}
			return super.dispatchEvent(event)
		}
		
		
		
	}
}