package com.youbt.manager
{
	import com.youbt.controls.AbstractPanel;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 用于侦听全局事件调出的面板工厂接口;
	 * @author crlnet
	 * 
	 */	
	public interface IPanelFactory
	{
		
		/**
		 * 创建一个面板; 
		 * @return 
		 * 
		 */		
		function newInstance():AbstractPanel;
		
		/**
		 * 开始侦听; 
		 * 
		 */		
		function startListener():void;
		/**
		 *清理侦听; 
		 * 
		 */		
		function clearListener():void;
		
		/**
		 * 注销当前工厂类,及其创建的面板; 
		 * 
		 */		
		function dispose():void;
		
		/**
		 * 工厂创建的面板的父容器; 
		 * @param container
		 * 
		 */		
		function setContainer(container:DisplayObjectContainer):void
	}
}