package com.youbt.manager
{

	import com.youbt.containers.Container;
	
	import flash.display.DisplayObject;
	

	public class RFPopupManager {
		private static  var impl:RFPopUpManagerImpl=new RFPopUpManagerImpl  ;
		public static  function createPopUp(parent:Container,className:Object,modal:Boolean=false,childList:String=null):DisplayObject{
			return impl.createPopUp(parent,className,modal,childList);
		}
		public static function addPopUp(window:DisplayObject, parent:Container, modal:Boolean=false, childList:String=null):void {
			impl.addPopUp(window,parent,modal,childList)
		}
		public static  function centerPopUp(popUp:DisplayObject,parent:DisplayObject=null):void {
			impl.centerPopUp(popUp,parent);
		}
		public static  function removePopUp(popUp:DisplayObject):void {
			impl.removePopUp(popUp);
		}
		public static  function bringToFront(popUp:DisplayObject):void {
			impl.bringToFront(popUp);
		}
	}
}