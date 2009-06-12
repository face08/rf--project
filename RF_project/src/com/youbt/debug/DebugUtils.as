package com.youbt.debug
{
	import flash.utils.Dictionary;
	
	/**
	 * Debug 调试工具配置
	 * 
	 * 使用方法
	 * DebugUtils.isDebugMode=true;  //使用debug模式， 必须开启，否则不做任何处理
	 * DebugUtils.isConsoleOutput = true; //使用控制台输出
	 * DebugUtils.SetCurrentUser('dan'); //设定用户为‘dan’，其他用户不输出
	 * DebugUtils.SetDebugLevel(DebugUtils.DEBUG); //设定调试等级为debug，则比debug低的等级都会输出， 如error, warn,summay,debug
	 * RFTraceDebug('dan','f'); //会输出
	 * RFTraceDebug('xx','fcc'); //不输出
	 * 
	 * @author eas
	 * 
	 */
	public class DebugUtils
	{
	
		public static var isDebugMode:Boolean = false;
		
		public static const NONE:int =0;
		public static const ERROR:int= 1;
		public static const WARN:int=2;
		public static const SUMMARY:int = 3;
		public static const DEBUG:int = 4
		public static const ALL:int=5;

		public static const ALL_USER:String='*';
		public static const NONE_USER:String ='/';		
		
		private static var opname:String =NONE_USER;
		private static var CurrentLevel:int =SUMMARY;
		public static   function  SetDebugLevel(level:int):void
		{
			CurrentLevel = level;			
		}
		public static function  SetCurrentUser(user:String):void
		{
			opname = user;
			if((user==NONE_USER)&&(CurrentLevel>3))
			{
				CurrentLevel=3;	
			}
		}
		/**
		 * 图形化的输出界面 
		 * @param value
		 * 
		 */		
		public static function set isPanelOutput(value:Boolean):void
		{
			if(value)
			{
				if(!publishers['panel']){
					registePublisher('panel',new PanelDebugPublisher());
				}
				
			}	else
			{
				publishers['panel'] = null;
				delete publishers['panel']
			}
		}
		/**
		 * 控制台输出 
		 * @param value
		 * 
		 */		
		public static function set isConsoleOutput(value:Boolean):void
		{
			if(value)
			{
				if(!publishers['console']){
					registePublisher('console',new ConsolePublisher());
				}
			}	else
			{
				publishers['console'] = null;
				delete publishers['console']
			}
		}
		

		internal static function debug(debugMsessage:DebugMessageVO):void
		{
			if(debugMsessage.level>CurrentLevel)
				return;
			if(CurrentLevel>=4)
			{
				if(debugMsessage.level==4 && opname==NONE_USER)
					return;
				if(debugMsessage.level==4 && opname!=ALL_USER && opname!= debugMsessage.owner)
					return;
			}
							
			for each(var publisher:IDebugPublisher in publishers)
			{
				publisher.publish(debugMsessage);	
			}
		}
		
		internal static var publishers:Dictionary = new Dictionary();
		
		public static function registePublisher(name:String, publisher:IDebugPublisher):void
		{
			if(name in publishers){
				if(publishers[name]){
					return;
				}
			}
			publishers [name ] = publisher;
		}
		
		

		
		
		

	}
}