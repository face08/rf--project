package com.youbt.preloaders
{
	import flash.events.IEventDispatcher;
	
	public interface ILoadingPopupUI
	{
		/**
		 * 进度条上显示的内容 
		 * @param value
		 * 
		 */		
		function showMessage(value:String):void;
		
		/**
		 * 是否显示取消按钮 
		 * @param value
		 * 
		 */		
		function isShowCancel(value:Boolean):void;
		
		/**
		 * 自动模式(true)或者手动模式(false)
		 * @param value
		 * 
		 */		
		function isAutoModel(value:Boolean):void;
		
		/**
		 * 设定进度条位置
		 * @param value
		 * 
		 */		
		function progress(value:int):void;
		
		/**
		 *  获取监听对象
		 * @return IEventDispatcher
		 * 
		 */		
		function dispather():IEventDispatcher;
		
		/**
		 * 结束 
		 */		
		function end():void
	}
}