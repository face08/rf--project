package com.youbt.manager
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.events.RFPlugInEvent;
	import com.youbt.net.RFLoader;
	import com.youbt.net.RFSWFLoader;
	import com.youbt.plugins.RFPlugIn;
	import com.youbt.rpc.RemoteToken;
	
	import flash.display.LoaderInfo;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * RF插件管理器 
	 * @author eas
	 * 
	 */
	public class RFPlugInManager extends EventDispatcher
	{
		public function RFPlugInManager()
		{
			if(_instance)
				throw new Error('RFPlugInManager is a Singleton');
		}
		
		private static var _instance:RFPlugInManager;
		public static function getInstance():RFPlugInManager
		{
			if(!_instance)
			{
				_instance = new RFPlugInManager();
				
			}	
			return _instance;
		}
		
		/**
		 *存储plugin定义  xml
		 */
		private var _pluginDefineStore:Dictionary = new Dictionary;
		
		/**
		 * 存贮插件载入的loader 
		 */
		private var _pluginLoaderInfoStore:Dictionary = new Dictionary;
		
		/**
		 * 存储plugin new出来的实例
		 * 以 guid为key 
		 */
		private var _pluginInstatnceStore:Dictionary = new Dictionary();
		
		/**
		 * 输入plugins 定义的xml 
		 * @param xml
		 * 
		 */		
		public function setPlugInDefine(xml:XML):void
		{
			for each(var child:XML in xml.children())
			{
				var guid:String =String(child.guid) ;
				_pluginDefineStore[guid] = child.copy();
			}
		}
		
		/**
		 * 检查所给guid的plugin 定义是否存在，
		 * @param guid
		 * @return 
		 * 
		 */		
		public function isPlugInDefineExist(guid:String):Boolean
		{
			if(_pluginDefineStore[guid] == null || _pluginDefineStore[guid] == undefined)
			{
				return false;
			}else
			{
				return true;
			}
		}
		
		/**
		 * 检查所给guid的plugin实例是否可用 
		 * @param guid
		 * @return 
		 * 
		 */
		public function isPlugInInstanceAvailable(guid:String):Boolean
		{
			if(_pluginLoaderInfoStore[guid] == null || _pluginLoaderInfoStore[guid] == undefined)
			{
				return false;
			}else
			{
				return true;
			}
		}
		
		
		public function cancelLoadPlugin():void
		{
			if(pluginLoader)
			{
				pluginLoader.cancel();
			}		
		}
		
		private var pluginLoader:RFLoader
		/**
		 * 载入plugin， 如果plugin swf没有载入，需要先载入 
		 * @param guid
		 * @return 
		 * 
		 */
		public function loadPlugIn(guid:String):RemoteToken
		{
			if(isInlinePlugin(guid))
			{
				var rt:RemoteToken = new RemoteToken('LoadInLinePlugOperation');
					setTimeout(setInlinePlugIn,100,guid,rt);
				return rt;
			}
			
			var token:RemoteToken = new RemoteToken('LoadPlugOperation');
			
			var path:String = getPlugInSwfPath(guid);
			
			pluginLoader = new RFSWFLoader(path,guid,null,false,false,true)
		//	pluginLoader=new RFStreamLoader(path,guid,null,true)
			pluginLoader.addEventListener(RFLoaderEvent.COMPLETE,onComplete);
			pluginLoader.addEventListener(RFLoaderEvent.FAILED,onFailed);
			pluginLoader.addEventListener(RFLoaderEvent.PROGRESS,onProgress);
			function onProgress(event:RFLoaderEvent):void
			{
				token.dispatchProgress(event);
			}
			function onComplete(event:RFLoaderEvent):void
			{
				
				
				_pluginLoaderInfoStore[guid] = event.loaderinfo;
				
				pluginLoader.removeEventListener(RFLoaderEvent.COMPLETE,onComplete);
				pluginLoader.removeEventListener(RFLoaderEvent.FAILED,onFailed);
				token.dispatchEvent(event);
				token.dispatchSuccessed();
				pluginLoader.dispose()
			}
			function onFailed(event:RFLoaderEvent):void
			{
				pluginLoader.removeEventListener(RFLoaderEvent.COMPLETE,onComplete);
				pluginLoader.removeEventListener(RFLoaderEvent.FAILED,onFailed);
				RFTraceError(event.toString());
				token.dispatchFault();	
				pluginLoader.dispose()
			}
			pluginLoader.load();
			return token;
		}
		
		public function setInlinePlugIn(guid:String,token:RemoteToken):void
		{
			var loadInfo:LoaderInfo = 	RFSystemManager.getInstance().stage.loaderInfo;
			_pluginLoaderInfoStore[guid] = loadInfo;
			token.dispatchSuccessed();
		}
		
		
		
				
		/**
		 * 获取guid对应的plugin的className 
		 * @param guid
		 * @return 
		 * 
		 */
		public function getPlugInClassName(guid:String):String
		{
			if(!isPlugInDefineExist(guid))
				return '';
			var plugDef:XML = _pluginDefineStore[guid] as XML;
			var obj:XMLList= plugDef.className;
			
			return obj.toString();
		}
		
		/**
		 * 获取 plugIn指定swf的地址 
		 * @param guid
		 * @return 
		 * 
		 */
		public function getPlugInSwfPath(guid:String):String
		{
			if(!isPlugInDefineExist(guid))
				return '';
				var plugDef:XML = _pluginDefineStore[guid] as XML;
			var obj:XMLList= plugDef.path;
			
			return obj.toString();
		}
		
		public function isInlinePlugin(guid:String):Boolean
		{
			var plugDef:XML = _pluginDefineStore[guid] as XML;
			if ('isInline' in plugDef)
			{
				return String(plugDef['isInline']) == 'true';
			}
			return false;
		}
		
		/**
		 * 获取plugin实例 
		 * @param guid
		 * @return 
		 * 
		 */		
		public function getPlugInInstance(guid:String):RFPlugIn
		{
			if(!isPlugInInstanceAvailable(guid))
			{
				throw new Error('PlugIn Loader'+guid+' not been loaded');
			}
			var refClass:Class = getClass(_pluginLoaderInfoStore[guid] as LoaderInfo , getPlugInClassName(guid));
			var refPlugiN:RFPlugIn = new refClass as RFPlugIn;
			
			return refPlugiN;
		}
		
	
		public function getSingletonPlugInInstance(guid:String):RFPlugIn
		{
			if(!(guid in _pluginInstatnceStore))	
			{
				_pluginInstatnceStore[guid] = getPlugInInstance(guid);
			}
			return _pluginInstatnceStore[guid] as RFPlugIn;
		}

		
		/**
		 * 提供一组guid，让pluginManager全部下载完毕等候使用 
		 * @param guids
		 * 
		 */		
		public function getPlugInsReady(guids:Array):void
		{
			
		}
		
		/**
		 * 提供一组guid，让plugInManager清除他们。
		 * 先清除实例，再清除loader。 
		 * @param guids
		 * 
		 */
		public function getPlugInsClear(guids:Array):void
		{
			
		}
		
		////////////////////////////////////////////////////////
		// plug in store implements
		// 
		////////////////////////////////////////////////////////
		
		
		private var _pluginsDataStore:Dictionary  = new Dictionary();

		/**
		 * 保存 物件，以key为对应 
		 * @param key
		 * @param value
		 * 
		 */
		public function setItem(plugins:Object,key:String, value:Object):void
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid == '')
				{return;}
			else{
				if(_pluginsDataStore[guid]==undefined)
					{_pluginsDataStore[guid] =new Dictionary();}
				_pluginsDataStore[guid][key] = value;
			}
		}
		
		/**
		 * 获取key对应的物件 
		 * @param key
		 * @return 
		 * 
		 */
		public function getItem(plugins:Object, key:String):Object
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid == '')
				{return null}
			else{
				return _pluginsDataStore[guid][key] ;
			}
		}
		
		/**
		 * 移除 key对应的item 
		 * @param key
		 * 
		 */
		public function removeItem(plugins:Object , key:String):void
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid != '')
			{
				 _pluginsDataStore[guid][key] =null;
				 delete _pluginsDataStore[guid][key];
			}
		}
		
		/**
		 * 清空所有已经存贮的内容 
		 * 
		 */		
		public function resetStoreItems(plugins:Object):void
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid != '')
			{
				 _pluginsDataStore[guid] =null;
				 delete _pluginsDataStore[guid];
			}
		}
		
		/**
		 * 回调 
		 * plugin 发送事件到 platform的方法 
		 * @param plugins
		 * @param type
		 * @param arguments
		 * 
		 */
		public function callBack(plugins:Object , type:String, arguments:Object):void
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid!='')
			{
				var event:RFPlugInEvent = new RFPlugInEvent(RFPlugInEvent.PLUGINEVENT_CALLBACK,guid,[type,arguments]);
				this.dispatchEvent(event);
			}
		}
		
		
		public function callPlugin(plugins:Object , type:String, arguments:Object):void
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid!='')
			{
				var event:RFPlugInEvent = new RFPlugInEvent(type,guid,arguments);
				this.dispatchEvent(event);
			}
		}
		
		public var sendFms:Function;
		
		/**
		 * plugin 调用 platform的发送fms方法，来发送fms消息。
		 * 该方法发出的fms方法，会被回送到相同guid定义的plugin实例 中，使用receiveFMSChannel方法。
		 *  
		 * @param plugins
		 * @param data
		 * 
		 */
		public function sendFMSChannel(plugins:Object , data:Object):void
		{
			var guid:String =  getPlugInGuid(plugins);
			if(guid!='')
			{
				sendFms.call(this,{guid:guid,data:data})		
				//send to fms
			}
		}
		
		/**
		 * platform接受到回调fms讯息之后，回调给plugin
		 * data 格式为
		 * {guid：pluginguid , data: 数据OBJ} 
		 * @param data
		 * 
		 */
		public function receiveFMSChannel(data:Object):void
		{
			var guid:String = data['guid'];
			if(!guid)
				return;
			if(!(guid  in _pluginInstatnceStore))
				return;
			var rfplugin:RFPlugIn = _pluginInstatnceStore[guid]
			rfplugin.receiveFMSChannel(data['data']); 
		}
		
		internal function getClass(loader :LoaderInfo,className : String) : Class 
		{
			try 
			{
				return loader.applicationDomain.getDefinition(className) as Class;
			} catch (e : Error) 
			{
				throw new IllegalOperationError(className + " definition not found in " + loader);
				return  getDefinitionByName('flash.display.MovieClip') as Class;
				
			}
			return null;
		}


		internal function getPlugInGuid(plugin:Object):String
		{
			var guid:String = '' ;
			for(var pluginGuid:String in  _pluginInstatnceStore)
			{
				if(_pluginInstatnceStore[pluginGuid] == plugin)
				{
					guid = pluginGuid;
					break;
				}
				
			}
			return guid;
		}
		
		
		

	}
}