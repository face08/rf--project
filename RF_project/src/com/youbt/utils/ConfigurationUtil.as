package com.youbt.utils
{
	import com.youbt.manager.RFConfigurationManager;
	
	/**
	 *  RF 配置文件功能类
	 * 默认配置文件格式如下：
	 *	<config>
	 * 		<prefixes>
	 * 			<prefix name='res_prefix0' value='xxx/'/>
	 * 			<prefix name='res_prefix1' value='http://localhost/xxx/'/>
	 * 		</prefixes>
	 * 		<resources>
	 * 			<resource name='ui' prefix='res_prefix' value='assets/UILib.swf'/>
	 * 			<resource name='bui' value='assets/BasicUI.swf'/>
	 * 			<resource name='eui' value='assets/EntranceUI.swf'/>
	 * 		</resources>
	 * 		<services>
	 * 			<service name='getTicket' type='http' prefix='res_prefix' value='data/currentTicket.xml'/>
	 * 		</services>
	 * </config> 
	 * 
	 * @author eas
	 * 使用方法 载入xml，
	 * 用initConfigXML 输入xml。
	 * 用其他方法呼出内容。
	 * 
	 * 
	 */
	public class ConfigurationUtil
	{
		public function ConfigurationUtil()
		{
		}
		
		
		
		private static  var _configManager:RFConfigurationManager;
		
		private static function  getConfigManager():RFConfigurationManager
		{
			if(!_configManager)
				{_configManager = RFConfigurationManager.getInsatnce();}
			return _configManager;
		
		}  
		
		/**
		 * 倒入xml 
		 * @param xml
		 * 
		 */
		public static  function initConfigXML(xml:XML):void
		{
			getConfigManager().initializeConfiguration(xml);	
		}
		
		/**
		 * 获取可用资源列表 
		 * @return 
		 * 
		 */
		public static function get resourceList():Array
		{
			return getConfigManager().getItemNameListByNodeLocalName(RFConfigurationManager.RF_CONFIG_RESOURCES_TAG_NAME);
		}
		
		/**
		 * 获取可用的服务列表 
		 * @return 
		 * 
		 */
		public static function get serviceList():Array
		{
			
			return getConfigManager().getItemNameListByNodeLocalName(RFConfigurationManager.RF_CONFIG_SERVICES_TAG_NAME);	
		}
		
		/**
		 *  获取 可用的前缀列表 
		 * @return 
		 * 
		 */
		public static function get prefixList():Array
		{
			return getConfigManager().getItemNameListByNodeLocalName(RFConfigurationManager.RF_CONFIG_PREFIXS_TAG_NAME);
		}
		
		/**
		 *  根据资源名字获取资源绝对Url 
		 * @param resName
		 * @return 
		 * 
		 */		
		public static function getResource(resName:String):String
		{
		
			return getConfigManager().getItemURL(RFConfigurationManager.RF_CONFIG_RESOURCES_TAG_NAME,resName);
		}
		
		/**
		 * 获取服务的url 
		 * @param serviceName
		 * @return 
		 * 
		 */
		public static function getService(serviceName:String):String
		{
			return getConfigManager().getItemURL(RFConfigurationManager.RF_CONFIG_SERVICES_TAG_NAME,serviceName);
		}
		
		/**
		 * 根据name获取前缀 
		 * @param perfixName
		 * @return 
		 * 
		 */
		public static function getPrefix(perfixName:String):String
		{
			return getConfigManager().getItemURL(RFConfigurationManager.RF_CONFIG_PREFIXS_TAG_NAME,perfixName);
		}
		
		/**
		 * 如果你的资源/服务/前缀名称是唯一的，可以直接从这里拉到。 
		 * @param uname
		 * @return 
		 * 
		 */
		public static function getUnique(uname:String):String
		{
			var s1:String=	getResource(uname);
			if(s1.length!=0)
				return s1;
			s1=	getService(uname);
			if(s1.length!=0)
				return s1;
			s1= getPrefix(uname);
				return s1;
			
		}
		
		/**
		 * 修改某个 perfix 的 value 
		 * @param name  perfix 的名字，不能操作不存在的内容
		 * @param value  value
		 * 
		 */
		public static function setPrefixValue(name:String,value:String):void
		{
			getConfigManager().setPrefixValue(name,value);
		}
	}
}