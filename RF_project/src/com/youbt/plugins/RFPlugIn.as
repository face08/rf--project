package com.youbt.plugins
{
	import com.youbt.core.ILifeCycleImpl;
	import com.youbt.core.RFSprite;
	import com.youbt.debug.RFTraceSummary;
	import com.youbt.events.UIComponentEvent;
	import com.youbt.manager.RFPlugInManager;
	
	import flash.events.Event;
	
	
	/**
	 * RFPlugin 初始化完成 
	 */
	[Event(name="initialized",type="com.youbt.events.UIComponentEvent")]
	
	/**
	 * RFPlugin 启动
	 */	
	[Event(name="start",type="com.youbt.events.UIComponentEvent")]
	
	/**
	 * RFPlugin 休眠 
	 */	
	[Event(name="sleep",type="com.youbt.events.UIComponentEvent")]
	
	/**
	 * RFPlugins 
	 * @author eas
	 * 
	 */	
	public class RFPlugIn extends RFSprite implements ILifeCycleImpl
	{
		public function RFPlugIn()
		{
			_plugInManager = RFPlugInManager.getInstance();
		}
		
		
		private var _plugInManager:RFPlugInManager;
		
		/**
		 * 初始化 
		 * 
		 */		
		public function initialize():void
		{
			RFTraceSummary('plugin initialize');
			initialized =true;
			
		}
		
		private var _arguments:Object ={};
		public function set Arguments(value:Object):void
		{
			_arguments = value;	
		}
		
		public function get Arguments():Object
		{
			return _arguments;	
		}
		
		public function runtimeArgument(key:String,value:Object):void
		{
			throw new Error('fu');
		}
		
		/**
		 * 启动 
		 * 
		 */
		public function start():void
		{
			RFTraceSummary('plugin start()');
			dispatchEvent(new UIComponentEvent(UIComponentEvent.START));
		}
		
		/**
		 * 休眠 
		 * 
		 */
		public function sleep():void
		{
			RFTraceSummary('sleep');
			dispatchEvent(new UIComponentEvent(UIComponentEvent.SLEEP));
		}
		/**
		 * 
		 *  撤掉销毁
		 */		
		
		public function dispose(e:Event=null):void{
			
			RFTraceSummary("dispose");
			// todo 
			// pluginmanager 使用Loader.unload() 请求彻底删除Plugin
			//this.removeEventListener(Event.UNLOAD,dispose)
		}
		 
		public function end():void
		{
			sleep();
			if((parent)&&(parent.contains(this)))
			{
				parent.removeChild(this);
			}
		}
		
		private var _initialized:Boolean = false;
		public function get initialized():Boolean
		{
			return _initialized;
		}
		public function set initialized(value:Boolean):void
		{
			_initialized = value;
			if(_initialized){
				dispatchEvent(new UIComponentEvent(UIComponentEvent.INITIALIZED));
			}
		}

		////////////////////////////////////////////////////////
		// plug in store implements
		// 
		////////////////////////////////////////////////////////


		/**
		 * 保存 物件，以key为对应 
		 * @param key
		 * @param value
		 * 
		 */
		public function setItem(key:String, value:Object):void
		{
			_plugInManager.setItem(this,key,value);
		}
		
		/**
		 * 获取key对应的物件 
		 * @param key
		 * @return 
		 * 
		 */
		public function getItem(key:String):Object
		{
			return _plugInManager.getItem(this,key);
		}
		
		/**
		 * 移除 key对应的item 
		 * @param key
		 * 
		 */
		public function removeItem(key:String):void
		{
			
		}
		
		/**
		 * 清空所有已经存贮的内容 
		 * 
		 */		
		public function resetStoreItems():void
		{
		}
		
		public function callBack(type:String, arguments:Object):void
		{
			_plugInManager.callBack(this,type,arguments);
		}
		
		public function callPlugin(type:String , arguments:Object):void
		{
			_plugInManager.callPlugin(this,type,arguments);
		}
		
		public function receiveFMSChannel(data:Object):void
		{
			throw new Error('fucl');
		}
		
		public function sendFMSChannel(data:Object):void
		{
			_plugInManager.sendFMSChannel(this,data);
		}
	}
}