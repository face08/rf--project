package com.youbt.net
{
	import com.youbt.debug.RFTraceWarn;
	import com.youbt.events.RFLoaderEvent;
	
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;

	public class ParallelDownloader extends DownloadList implements IDownloadList
	{
		
		/**
		 * spcific max running task
		 * 0 no limit
		 *  
		 *  
		 */		
		
		public var maxRunningTask:int=0
		


		/**
		 * specific whethe the list process timeout event
		 * true ,the list will retry the timeout task 
		 * false ,the list will dispatch the taskfailed event 
		 * 
		 */		
		public var allowTimeOut:Boolean=true;
		
		/**
		 * 
		 */		
		public var autostartStopedTask:Boolean=true;
		
		
		public function ParallelDownloader(target:IEventDispatcher=null)
		{
			_list=new Array()
			if(target){
				_ed=target
			}else{
				_ed=this
			}
		}
		
		
		/**
		 * 开始队列 
		 * 
		 */		
		override public function start():void
		{
			for each (var i:RFLoader in _list){
				if(i.status==RFLoader.QUEUED){
					if(maxRunningTask==0){
						i.load()
					}else{
						if(RunningTask<maxRunningTask){
							i.load()
							RunningTask++
						}
					}
				}
			}
			refreshList()
		}
		
		
		
		/**
		 * 停止队列 
		 * 
		 */		
		override public function omitStop():void
		{
			
		}
		
		/**
		 * 增加任务 自动生成一个RFLOADER
		 * @param url
		 * @param method  使用下载方式
		 * @param id
		 * @param autoStart
		 * @param autoretry
		 * @return 
		 * 
		 */		
		
		override public function addTask(url:String,method:int=3, id:String=null, autoStart:Boolean=true,autoretry:Boolean=true):RFLoader
		{
			
		
			
			var ld:RFLoader
			if(method==DownloadList.SWFMETHOD){
				ld=new RFSWFLoader(url,id,null,false)
			}else if(method==DownloadList.URLMETHOD){
				ld=new RFURLLoader(url,id,null,false)
			}else if(method==DownloadList.STREAMMETHOD){
				ld=new RFStreamLoader(url,id,null,false)
			}else if(method==DownloadList.SOUNDMETHOD){
				ld=new RFSoundLoader(url,id,null,false)
			}
			
			
			ld.autorety=autoretry;
			ld.addEventListener(RFLoaderEvent.PROGRESS,taskprogressHandler)
			ld.addEventListener(RFLoaderEvent.FAILED,failedHandler)
			ld.addEventListener(RFLoaderEvent.COMPLETE,taskcompleteHandler)
			
			_list.push(ld)
			
			if(autoStart){
				starttask(ld,false)
			}
			
			TotalTask=_list.length
			return ld
		}
		
		
		/**
		 * 将一个RFLOADER增加到队列中 
		 * @param task
		 * @return 
		 * 
		 */		
		override public function addTaskObject(task:RFLoader):String{
			
			
			if(maxRunningTask!=0){
				if(task.status==RFLoader.PROGRESS){
					if(RunningTask>=maxRunningTask){
						RFTraceWarn("running task gt max task");
					}
				}
				
			}
			_list.push(task)
			task.addEventListener(RFLoaderEvent.PROGRESS,taskprogressHandler)
			task.addEventListener(RFLoaderEvent.FAILED,failedHandler)
			task.addEventListener(RFLoaderEvent.COMPLETE,taskcompleteHandler)
			
			refreshList()
			
			return task.id
			
		}
		
		
		/**
		 * 开始某个任务
		 * 
		 * @param ld  可以是任务对象也可以是任务的ID
		 * @param forcestart  强制开始
		 * 
		 */		
		public function starttask(ld:Object,forcestart:Boolean=false,checklist:Boolean=false):void
		{
			var task:RFLoader
			if(ld is RFLoader){
				task=ld as RFLoader;
			}else if(ld is String){
				task=getTask(String(ld))
			}
			
			if(!task){
				return 
			}
			
			if(maxRunningTask==0){
					task.load()
			}else{
				if(RunningTask<maxRunningTask){
					task.load()
			}else if(forcestart){
					task.load()
				}
			}
			
			if(checklist){
				refreshList()
			}else{
				super.refreshList()
			}			
			
		}
		
		
		/**
		 * 清空任务列表
		 * 同时会关闭所有下载，清空所有监听
		 * 
		 */		
		
		public function clearAll():void{
			clearlist()
		}
		
		
		/**
		 * 刷新任务列表 
		 * 
		 */		
		override protected function refreshList():void{
			super.refreshList()
			if(TotalTask==CompletedTask && TotalTask!=0){
				notifyalltaskcomplete()
			}else{
				if(FailedTask+CompletedTask== TotalTask && FailedTask!=0){
					notifytaskend()
					return;
				}
				if(QueuedTask>0){
					for each(var ld:RFLoader in _list){
						if(ld.status==RFLoader.QUEUED){
							if(maxRunningTask==0){
								ld.load()
							}else {
								if(RunningTask<maxRunningTask){
									ld.load()
									RunningTask++
								}else{
									break;
								}
								
							}
						}
					}
				}
				if(autostartStopedTask){
					if(StopTask>0){
						for each(var mld:RFLoader in _list){
							if(mld.status==RFLoader.STOP){
								if(maxRunningTask==0){
									mld.load()
								}else {
									if(RunningTask<maxRunningTask){
										mld.load()
										RunningTask++
									}else{
										break;
									}
								}
							}
						}
					}
				}
			}
		}
		
		
		/**
		 * 通知所有任务完毕 
		 * 
		 */		
		override protected function notifyalltaskcomplete():void{
			super.notifyalltaskcomplete()
		}
		
		
		/**
		 * 某个任务超时 
		 * @param e
		 * 
		 */		
		private function timeoutHandler(e:RFLoaderEvent):void
		{
			if(allowTimeOut){
				(e.currentTarget as RFLoader).status=RFLoader.QUEUED
			}else{
				super.failedHandler(e)
			}
			refreshList()
		}
		
		
		override protected function taskprogressHandler(e:RFLoaderEvent):void{
			super.taskprogressHandler(e)
		}
		override protected function failedHandler(e:RFLoaderEvent):void{
			super.failedHandler(e)
			refreshList()
		}
		override protected function taskcompleteHandler(e:RFLoaderEvent):void{
			super.taskcompleteHandler(e)
			refreshList()
		}
		override public function toString():String{
			return "["+flash.utils.getQualifiedClassName(this)+"]TotalTask:"+TotalTask
			+" QueuedTask:"+this.QueuedTask+" RunningTask:"+this.RunningTask+" CompleteTask:"+this.CompletedTask
		}
		
	}
	
	
}