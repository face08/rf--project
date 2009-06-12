package com.youbt.debug
{
	
	[ExcludeClass]
	public class DebugMessageVO extends Object
	{
		public function DebugMessageVO(level:int,owner:String,time:Date , message:String ,args:Array)
		{
			this.level = level;
			this.owner = owner;
			this.time = time;
			this.message =message;
			this.data = args;	
		}
		
		public var level:int;
		
		public var owner:String;
		
		public var time:Date;
		
		public var message:String;
		
		public var data:Array ;
		
		public function toString():String
		{
			var argst:String='';
			for (var i:int = 0;  i <data.length  ;i++)
			{
				argst +=' @arg'+(i+1)+':' + data[i];
			}
			var levelStr:String;
			switch(level)
			{
				case DebugUtils.DEBUG:
					levelStr = '开发调试_'+ owner;
				break;
				case DebugUtils.ERROR:
					levelStr = '错误';
				break;
				case DebugUtils.WARN:
					levelStr ='警告';
				break;
				case DebugUtils.SUMMARY:
					levelStr = '摘要';
				break;
			}
			return '['+getTimeString(time)+'][Lv'+level+':'+levelStr+']'+message + argst;
		}
		
		public static function getTimeString(dt:Date):String
		{
			
			return /*dt.getFullYear()+'/'+String(dt.getMonth()+1)+'/'+dt.getDate()+','*/dt.getHours()+':'+dt.getMinutes()+"'"+dt.getSeconds()+"'"+dt.getMilliseconds();
		}
	}
}