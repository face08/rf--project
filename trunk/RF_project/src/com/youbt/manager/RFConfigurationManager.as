package com.youbt.manager
{
	import com.youbt.debug.RFTraceError;
	
	import flash.utils.Dictionary;
	
	/**
	 * 具体请查看
	 * com.youbt.utils.ConfigurationUtil
	 * 
	 * 
	 * @author eas
	 * <config>
	 * 		<prefixs>
	 * 			<prefix name='res_prefix' value='xxx'/>
	 * 		</prefixs>
	 * 		<resources>
	 * 			<resource name='ui'  value='assets/UILib.swf'/>
	 * 			<resource name='bui' value='assets/BasicUI.swf'/>
	 * 			<resource name='eui' value='assets/EntranceUI.swf'/>
	 * 		</resources>
	 * 		<!-- service define -->
	 * 		<services>
	 * 			<service name='getTicket' type='http' value='data/currentTicket.xml'/>
	 * 		</services>
	 * </config>
	 */
	public class RFConfigurationManager
	{
		public function RFConfigurationManager(sf:singlonForce)
		{
			configuration = new Dictionary();
		}
		
		/**
		 * PREFIX 包 locaname。
		 * 如果需要修改xml，可在此处修改 
		 */
		public static var RF_CONFIG_PREFIXS_TAG_NAME:String = 'prefixes';
		
		/**
		 * service 包localname; 
		 */		
		public static var RF_CONFIG_SERVICES_TAG_NAME:String ='services';
		/**
		 * 资源 tag localname 
		 */
		public static var RF_CONFIG_RESOURCES_TAG_NAME:String ='resources';
		
//		/**
//		 * PK 加载时间限制 单位：秒(在规定时间内没有加载完的用户将被踢出游戏) 
//		 */
//		public static var PK_LOAD_TIME_LIMIT:String ='PKLoadTimeLimit';
		
		private static var _instance:RFConfigurationManager;
		public static function getInsatnce():RFConfigurationManager
		{
			if(!_instance)
				_instance = new RFConfigurationManager(new singlonForce());
			return _instance;
		}
		
		private  var configuration:Dictionary;
		private var configuration_xml:XML;
		
		/**
		 * 初始化 配置文件 
		 * @param xml
		 * 
		 */
		public  function initializeConfiguration(xml:XML):void
		{
			getInsatnce();
			
			for each(var element:XML  in xml.elements())
			{
				if(!_instance.configuration[element.localName()])
				{
					_instance.configuration[element.localName()] = element;
				}else
				{
					var tmp:XML = _instance.configuration[element.localName()] as XML;
					for each(var element_item:XML  in element.elements())
					{
						var name:String =String( element_item.@name);
						var obj:XMLList = tmp.children().(@name==name);
						if(obj.length()==0)
						{
							tmp.appendChild(element_item);	
						}else
						{
							//相同的xml名称节点已经存在
							RFTraceError('Xml node '+name+' exist');
						}
					}
					_instance.configuration[element.localName()] = tmp;
				}
			}	
			if(!configuration_xml)
				configuration_xml = new XML();
			
			configuration_xml .appendChild(xml.copy());
			_isConfigExist = true;
		}
		
		/**
		 * 配置文件是否存在 
		 */
		private var _isConfigExist:Boolean = false;
		public  function get isConfigExist():Boolean
		{
			
			return _isConfigExist;
		}
		
		/**
		 * 根据 类型名称获取xml 
		 * @param nodeName
		 * @return 
		 * 
		 */
		public function getItemNameListByNodeLocalName(nodeName:String):Array
		{
			var tmp:Array = new Array();
			if(!_isConfigExist)
				return tmp;
			if(!(nodeName in configuration))
				return tmp;
			
			var items:XMLList  = XML(_instance.configuration[nodeName]).children()
			
			for each(var item:XML  in items)
			{
				tmp.push(item.@name);
			}
			return tmp;
		}
		
		/**
		 * 根据定义的prefix 获取完整的url
		 * @param pars
		 * @return 
		 * 
		 */
		private function generateFullURLValue(pars:XML):XML
		{
			if(pars.@name==null)
				return pars;
			
			if(pars.@prefix.toString().length==0)
				pars.@url = pars.@value;
			else
			{
				var prefixName:String = pars.@prefix.toString();
				var prefix:String = getItemValue(RF_CONFIG_PREFIXS_TAG_NAME,prefixName);
				pars.@url = prefix+ pars.@value.toString();
			}
			return pars;
		}
		
		/**
		 * 获取item的value； 
		 * @param nodeName
		 * @param attributeName
		 * @return 
		 * 
		 */
		private function getItemValue(nodeName:String,attributeName:String):String
		{
			if(!_isConfigExist)
				return '';
			if(!(nodeName in   configuration))
				return '';
			var nodexml:XMLList = XML(configuration[nodeName]).children();
			return XML(nodexml.(@name ==attributeName)).@value.toString();
		}
		
		/**
		 * 获取item的url 
		 * @param nodeName
		 * @param attributeName
		 * @return 
		 * 
		 */
		public function getItemURL(nodeName:String, attributeName:String):String
		{
			if(!_isConfigExist)
				return '';
			if(!(nodeName in   configuration))
				return '';
			var nodexml:XMLList = XML(configuration[nodeName]).children();
			if(nodexml.(@name==attributeName).length()==0)
				return '';
			else{
				return generateFullURLValue(XML(nodexml.(@name ==attributeName))).@url.toString();
			}
		}
		
		/**
		 * 获取对应item的 xml 
		 * @param nodeName
		 * @param attributeName
		 * @return 
		 * 
		 */
		private function getItemXML(nodeName:String,attributeName:String):XML
		{
			var tmp:XML = new XML();
			if(!_isConfigExist)
				return tmp;
			if(!(nodeName in configuration))
				return tmp;
			var nodexml:XMLList =XML( configuration[nodeName]).children();
			if(nodexml.(@name==attributeName).length()==0)
				return null;

			tmp = XML(nodexml.(@name==attributeName));
			tmp = generateFullURLValue(tmp)
			return tmp;
			
		}
		
		public function setPrefixValue(name:String,value:String):void
		{
			if(!_isConfigExist)
				return;
			var tmp:XML = getItemXML('prefixes',name);
			
			tmp.@value = value;
			
		}
		
	}
}class singlonForce{}