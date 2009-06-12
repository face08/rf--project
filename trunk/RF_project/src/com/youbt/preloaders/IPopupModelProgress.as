package com.youbt.preloaders
{
	import flash.events.IEventDispatcher;
	
	public interface IPopupModelProgress
	{
		/**
		 *  增加一个进度显示任务
		 * @param msg  显示信息
		 * @param id     标示
		 * @param mode 模式 -1,0  , 0为自动模式。-1为手动模式
		 * @param cancelAble 是否可以取消  
		 * 
		 */
		function show(msg:String="Please wait...",id:String='1',mode:int=-1,cancelAble:Boolean=false):IEventDispatcher
		/**
		 * 修改 一个进度
		 * @param id 标示
		 * @param loadedBytes  	载入 字节
		 * @param totalBytes    总字节
		 * @param speed 		下载速度
		 */
		function progress(id:String, loadedBytes:int, totalBytes:int, speed:Number = -1):void

		/**
		 * 多线下载任务，完成其中的某个下载任务 
		 * 用于显示 (10/20) 
		 * 
		 * @param id  标示 
		 * @param completeThreads  完成的任务数
		 * @param totalThreads   总任务数
		 * 
		 */
		function threadChange(id:String , completeThreads:int , totalThreads:int):void
		
		/**
		 * 取消某个 id的显示 
		 * @param id
		 * 
		 */
		function cancel(id:String = null):void
		
		/**
		 * 完成 某个 id
		 * @param id
		 * 
		 */
		function hide(id:String):void
	}
}