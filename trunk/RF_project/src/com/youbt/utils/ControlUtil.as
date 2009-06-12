package com.youbt.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.text.TextFormat;
	
	public class ControlUtil
	{
		public function ControlUtil()
		{
		}
		
		/**
		 * 注销一个bitmapdata; 
		 * @param bmd
		 * 
		 */		
		public static function disposeBitmapData(bmd:BitmapData):void{
			if(bmd){
				bmd.dispose();
			}
		}
		
		/**
		 * 
		 * @param bmp
		 * @param bmd
		 * @return 
		 * 
		 */		
		public static function bindBitmapData(bmp:Bitmap,bmd:BitmapData):void{
			disposeBitmapData(bmp.bitmapData);
			bmp.bitmapData=bmd;
		}
		
		/**
		 * 创建一个对像; 
		 * @param type
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function createElementByClass(type:Class,parent:DisplayObjectContainer=null):* {
			var element:* = new type();
			if(parent){
				parent.addChild(element);
			}
			return element;
		}
		
		
		/**
		 *取得一个字体样式; 
		 * @return 
		 * 
		 */		
		public static function createTextFormat(font:String="Tahoma",size:int=12):TextFormat {
			var format:TextFormat = new TextFormat();
			format.font = font;
			format.size = size;
			format.leading=5;
			return format;
		}
		
		/**
		 * 从库下创建一个实例; 
		 * @param loader
		 * @param name
		 * 
		 */		
		public static function getInstanceFormLibrary(loader:Loader,name:String):DisplayObject{
			if(loader==null || name=="")return null;
			var domain:ApplicationDomain=loader.contentLoaderInfo.applicationDomain;
			
			if(domain.hasDefinition(name)==false){
				return null;
			}
			
			var c:Class=domain.getDefinition(name) as Class;
			
			//todo bitmap;
			return new c() as DisplayObject;
		}
		
		
		
		public static function getElementByName(parent:DisplayObjectContainer,name:String):DisplayObject{
			return SpriteUtil.getChildByName(parent,name);
		}
		
		/**
		 * 清空子集; 
		 * @param container
		 * 
		 */		
		public static function clearChildren(container:DisplayObjectContainer):void{
			SpriteUtil.clearChildren(container);
		}

	}
}