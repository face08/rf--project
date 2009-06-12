package com.youbt.rpc
{
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;

	/**
	 * 异步操作令牌
	 *  
	 * @author eas
	 * 
	 */
	public class AsyncToken extends EventDispatcher
	{
		public function AsyncToken(target:IEventDispatcher=null)
		{
			super(target);
		}
		
	}
}