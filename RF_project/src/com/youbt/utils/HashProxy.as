package com.youbt.utils
{
	import com.youbt.debug.RFTraceWarn;
	
	import flash.external.ExternalInterface;
	
	/**
	 * 浏览器 hash代理 
	 * @author eas
	 * 
	 */
	public class HashProxy
	{
		
		private static function initJS():void
		{
			if(!_isReady	)
			{
				 var isAvailable:Boolean = ExternalInterface.available;
				 if(!isAvailable)
				{
					RFTraceWarn('ExternalInterface is not available!');
					return ;
				}
				var xml:XML = 
<value>
<![CDATA[
function getHash()
{ 
	return location.hash;
}
function setHashX(str,pageTitle)
{
 	document.title =pageTitle;
	str = (str == "_") ? "" : str;
	var uName = navigator.userAgent;
	if (uName.indexOf("Safari") > -1)
	{
		location.hash = str;
	}else
	{
		location.hash = "#"+str;
	}
	document.currentHref =location.href;
}
function setHashAndFocusX(str,p)
{	
	setHashX(str,p);
};
]]>
</value>
				 ExternalInterface.call('eval',xml.text().toString());
				
			}
		}
		private static var _isReady:Boolean = false;
		
		/**
		 * 获取当前浏览器 中的 hash值 
		 * @return 
		 * 
		 */
		public static function getHash():String
		{
			 var isAvailable:Boolean = ExternalInterface.available;
			if(!isAvailable)
			{
				RFTraceWarn('ExternalInterface is not available!');
				return '';
			}
			initJS();
			var returnStr:String = '';
			var str :String = ExternalInterface.call('eval','getHash()');
			if(str)
				returnStr= str.replace('#','');
			return returnStr;
		}
		
		/**
		 * 写到浏览器中当前的 hash 
		 * @param pageTitle   页面标题
		 * @param locationHash  hash
		 * 
		 */
		public static function setHash(pageTitle:String,locationHash:String):void
		{
			 var isAvailable:Boolean = ExternalInterface.available;
			if(!isAvailable)
			{
				RFTraceWarn('ExternalInterface is not available!');
				return ;
			}
			initJS();
			ExternalInterface.call("eval",'setHashAndFocusX("'+locationHash+'","'+pageTitle+'")');
			trace("title:",pageTitle,"\tlocationHash:",locationHash);										
		}
		
		
		public static function reLoad():void
		{
			 var isAvailable:Boolean = ExternalInterface.available;
			if(!isAvailable)
			{
				RFTraceWarn('ExternalInterface is not available!');
				return ;
			}
			ExternalInterface.call('window.location.replace(window.location.href)');
		}
	}
}