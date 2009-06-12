package com.youbt.utils
{
	import com.youbt.manager.RFSystemManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	
	/**
	 * 文件功能辅助类;
	 * @author crlnet
	 * 
	 */	
	public class FileInfoUtil
	{
		public function FileInfoUtil()
		{
		}
		
		/**
		 * 取得应用程序目录完整路径地址; 
		 * @param applicationContainer 应用程序主容器;
		 * @return 
		 * 
		 */		
		public static function getApplicationDirectory(application:DisplayObject=null):String{
			if(application==null){
				application= RFSystemManager.getInstance();
			}
			return getDirectory(application.loaderInfo.url);
		}
		
		/**
		 * 取得一个文件上一级目录; 
		 * @param path 
		 * @return 
		 * 
		 */		
		public static function getDirectory(path:String):String{
			var pos1:int =path.lastIndexOf('\\');
			var pos:int=path.lastIndexOf('/');
			if(pos1>pos){
				pos = pos1;
			}
			path = path.slice(0,pos+1);
			return path;
		}
		
		/**
		 * 取得文件类型; 
		 * @param fileName
		 * @return 
		 * 
		 */		
		public static function getFileType(fileName:String):int{
			var index:int=fileName.lastIndexOf(".");
			if(index==-1)return FileType.UNKNOW;
			
			
			var ext:String=fileName.substr(index+1).toLowerCase();
			
			var type:int;
			
			switch(ext){
				case "swf" :
					type=FileType.SWF ;
					break;
				case "png" :
				case "jpg" :
				case "gif" :
					type=FileType.IMAGE ;
					break;
				case "xml" :
					type=FileType.XML ;
					break ;
				default :
					type=FileType.UNKNOW;
					break;
			}
			
			return type;
		}

	}
}