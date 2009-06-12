package com.youbt.rpc.remoting
{
	public interface IRemoteOperation
	{ 
		function resultHandler(o:Object):void
		function errorHandler(o:Object):void
	}
}