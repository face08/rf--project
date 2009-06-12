package com.youbt.manager
{
	/**
	 *  可被调整接口;
	 * @author crlnet
	 * 
	 */	
	public interface IResizeable
	{
		/**
		 *	所在区域变化时; 
		 * @param width
		 * @param height
		 * 
		 */		
		function resize(width:int,height:int):void;
		
	}
}