package  com.youbt.rpc.requests
{
	import com.youbt.rpc.RemoteToken;
	
	/**
	 *  异步请求
	 * 所有的 http/ amf 请求 ，都以此为父类  
	 * @author eas
	 * 
	 */
	public class AsyncRequest extends Request
	{
		/**
		 * 构造函数  
		 * @param type
		 * @param args
		 * 
		 */
		public function AsyncRequest(...args)
		{
				_requestParameter = args;
		}
		
		
		/**
		 * 调用  
		 * @return 
		 * 
		 */
		override public function invoke():RemoteToken
		{
			if((invokerFunction as Object) == null)
			{
				throw new Error('invokerFunction undefined!');
				return null;
			}
			return invokerFunction.call(this,this);
		}
		
		
		protected function get invokerFunction():Function
		{
			return null;
		} 
		
	}
}