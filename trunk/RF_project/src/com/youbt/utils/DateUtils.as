package com.youbt.utils
{
	import flash.net.getClassByAlias;
	
	public class DateUtils
	{
		 public const months : Array = [
			'January',
			'February',
			'March',
			'April',
			'May',
			'June',
			'July',
			'August',
			'September',
			'October',
			'November',
			'December'
		];
		public const days : Array = [
			'Sunday',
			'Monday',
			'Tuesday',
			'Wednesday',
			'Thursday',
			'Friday',
			'Saturday'
		];
		public static const cDays:Array = [
			'星期日',
			'星期一',
			'星期二',
			'星期三',
			'星期四',
			'星期五',
			'星期六'
		];
		
		
		public static function daysInMonth(d : Date) : uint {
			var daysInMonth : Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			var i : uint = Boolean((isLeapYear) && (d.month == 1)) ? 1 : 0; 
			i += daysInMonth[d.month];
			return i;
		}
		
		public static function dayOfYear(d : Date) : uint {
			var f : Date = new Date( d.getFullYear(), 0, 1 );
			var i : Number = d.getTime() - f.getTime();
			return Math.floor(i/86400000);
		}

		public static function weekOfYear(d : Date) : uint {
			var f : Number  = 2 - new Date(d.getFullYear(), 0, 1).getDay();
			if (f < 0) f += 7;
			var m : Date  = new Date(d.getFullYear(), 0, f);
			var week : Number = Math.floor(Math.floor((d.getTime() - m.getTime()) / 86400000) / 7) + 1; 
			if (week == 0) week = weekOfYear(new Date(d.getFullYear() - 1, 11, 31));
			if (week > 52) week -= 52;
			return week;
		}

		public static function meridiem(d : Date) : String {
			return String((d.hours < 12) ? 'am' : 'pm')
		}
		
		public static function SwatchTime(d : Date) : Number {
			var i : int = ( d.getUTCHours() * 3600 ) + ( d.getUTCMinutes() * 60 ) + ( d.getUTCSeconds() ) + 3600;
			return Math.round(i/86.4);
		}
		
  		public static function TimezoneName(d : Date) : String {
			var timeZones:Array = ['IDLW', 'NT', 'HST', 'AKST', 'PST', 'MST', 'CST', 'EST', 'AST', 'ADT', 'AT', 'WAT', 'GMT', 'CET', 'EET', 'MSK', 'ZP4', 'ZP5', 'ZP6', 'WAST', 'WST', 'JST', 'AEST', 'AEDT', 'NZST'];
			var hour:Number = Math.round(12 + -(d.getTimezoneOffset() / 60));
			 if (Boolean(DateUtils.isDST(d))){
				hour--;
			}   
			
			return timeZones[hour];
		} 
		
		
		public static function isLeapYear(d : Date) : Boolean {
			return (d.fullYear % 4 == 0) ? true : false;
		}
		
		public static function IsoWeek(d : Date) : uint {
			var f : Number  = 2 - new Date(d.getFullYear(), 0, 1).getDay();
			if (f < 0) f += 7;
			var m : Date  = new Date(d.getFullYear(), 0, f);
			var week : Number = Math.floor(Math.floor((d.getTime() - m.getTime()) / 86400000) / 7) + 1; 
			if (week == 0) return d.getFullYear() - 1;
			return d.getFullYear();
		}
		
		public static function UnixTimestamp(d : Date) : Number {
			return Math.floor(d.getTime()/1000);
		}
		
		public static function isDST(d : Date) : Boolean {
			if ( new Date(d.getFullYear(), d.month, d.date).timezoneOffset > new Date(d.getFullYear(), (d.month - 6), d.date).timezoneOffset ) return true;
			return false;
		}
		/**
		*	Compares two dates and returns an integer depending on their relationship.
		*
		*	Returns -1 if d1 is greater than d2.
		*	Returns 1 if d2 is greater than d1.
		*	Returns 0 if both dates are equal.
		* 
		* 	@param d1 The date that will be compared to the second date.
		*	@param d2 The date that will be compared to the first date.
		* 
		* 	@return An int indicating how the two dates compare.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function compareDates(d1:Date, d2:Date):int
		{
			var d1ms:Number = d1.getTime();
			var d2ms:Number = d2.getTime();
			
			if(d1ms > d2ms)
			{
				return -1;
			}
			else if(d1ms < d2ms)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		
		/**
		 * auther:whh
		 * @param d 
		 * @return “2008年9月20日 11:02:32“
		 * 
		 */		
		public static function getDateString(d:Date):String
		{
			return getYeahMonthDateString(d) + " " + getTimeString(d);
		}
		
		/**
		 * auther:whh
		 * @param d
		 * @return “2008年9月20日"
		 * 
		 */		
		public static function getYeahMonthDateString(d:Date):String
		{
			var mouth:int = d.month+1;
			var date:int = d.date;
			
//			return d.fullYear.toString()+"年"+(mouth < 10 ? "0"+mouth.toString() : mouth.toString())+"月"+(date < 10 ? "0"+date.toString() : date.toString())+"日";
			return d.fullYear.toString() + "年" + mouth.toString() +"月"+ date.toString()+"日";
		}
		
		/**
		 * auther:whh
		 * @param d
		 * @return ”11:02:32“
		 * 
		 */		
		public static function getTimeString(d:Date):String
		{
			var hours:int = d.hours;
			var minutes:int = d.minutes;
			var seconds:int = d.seconds;
			return (hours < 10 ? "0"+hours.toString() : hours.toString())+":"+(minutes < 10 ? "0"+minutes.toString() : minutes.toString())+":"+ (seconds < 10 ? "0"+seconds.toString() : seconds.toString());
		}
		
		/**
		 * auther:whh
		 * @param d
		 * @return "星期六"
		 * 
		 */		
		public static function getWeek(d:Date):String
		{
			return DateUtils.cDays[d.day];
		}
		
		
		/**
		 * getOutputByType
		 * author : whh
		 * input type "yyyy年MM月dd日 hh:mm:ss ww"  return “2008年09月23日  01:31:27 星期二"
		 */		
		 
//		typeArray 记录格式	
		private static var typeArray:Array;
		public static function setOutputType(str:String):Array
		{
			var typeArray:Array = [];
			var tempChar:String;
			var char:String;
			var arr:Array;
			var num:int = str.length;
			var i:int
			for(i=0;i<num+1;i++)
			{
				char = str.charAt(i)
				if(char != tempChar)
				{
					if(arr) typeArray.push(arr);
					arr = [];
				}
				arr.push(char);
				tempChar = char;
			}
			return typeArray;
		}
		
		public static function output(d:Date,type:String = null):String
		{
			var str:String = '';
			var num:int;
			if(type) typeArray = setOutputType(type); 
			if(!typeArray) return d.toDateString()
			for each(var arr:Array in typeArray)
			{
				switch(arr[0])
				{
					case "y":
						num = (d.fullYear%100);
						if(arr.length <= 2) str += num<10 ? "0"+num.toString() : num.toString();
						else str+= d.fullYear.toString();
					break;
					case "M":
						num = d.month+1;
						if(arr.length < 2) str += num.toString();
						else str += num<10 ? "0"+num.toString() : num.toString();
					break;
					case "d":
						num = d.date;
						if(arr.length<2) str += num.toString();
						else str += num<10 ? "0"+num.toString() : num.toString();
					break;
					
					case "h":
						num = d.hours;
						if(arr.length<2) str += num.toString();
						else str += num<10 ? "0"+num.toString() : num.toString();
					break;
					
					case "m":
						num = d.minutes;
						if(arr.length<2) str += num.toString();
						else str += num<10 ? "0"+num.toString() : num.toString();
					break;
					
					case "s":
						num = d.seconds;
						if(arr.length<2) str += num.toString();
						else str += num<10 ? "0"+num.toString() : num.toString();
					break;
					
					case "w":
						str += DateUtils.cDays[d.day];
					break;
					
					default:
						str += arr.toString();
					break;
				}
			}
			
			return str;
		}
		
		public static function getTimeByType(time:int,type:String):String
		{
			var str:String
			if(!type) return "error type:"+time.toString();
			/* var timeArray:Array = getTimeByMillisecond(time);
			var d:Date = new Date(0,0,timeArray[0],timeArray[1],timeArray[2],timeArray[3],0) 
			//居然好好的 Date(time) 不用
			*/
			var d:Date = new Date(time);
			return output(d,type);
		}
		
		private static function getTimeByMillisecond(time:int):Array
		{
			var s:int = time / 1000;
			var m:int = s / 60;
			var h:int = m / 60;
			var date:int = h / 24;
			h = h%24;
			m = m%60;
			s = s%60;
			return [date,h,m,s];
		}

	}
}