package com.youbt.manager
{
	import com.youbt.containers.Container;
	import com.youbt.controls.TitledWindow;
	import com.youbt.core.IUIComponent;
	import com.youbt.core.UIComponent;
	
	import flash.display.DisplayObject;

	public class RFPopUpManagerImpl 
	{
		
		public function RFPopUpManagerImpl():void{
		}
		public function createPopUp(parent:Container, className:*, modal:Boolean=false, childList:String=null):DisplayObject
		{
			if(className is Class){
			var window:DisplayObject=new className()
			}
       		addPopUp(window, parent, modal, childList);
     	    return window; 
		}
		
		public function addPopUp(window:DisplayObject, p:Container, modal:Boolean=false, childList:String=null):void
		{
			if(window is IUIComponent)
				IUIComponent(window).isPopUp=true
			p.addChild(window)
			if(modal){ 
				if(window is TitledWindow){
					(window as TitledWindow).showmodal()
				}
			}
			
		}
		
		public function centerPopUp(popUp:DisplayObject,parent:DisplayObject=null):void
		{
			var p:DisplayObject
			if(parent){
				p=parent
			}else{
				p=popUp.parent
			}
			
			if(!p)
				return
			if(popUp is UIComponent){
				popUp.x=int((p.width-(popUp as UIComponent).measureWidth)/2)
				popUp.y=int((p.height-(popUp as UIComponent).measureHeight)/2)
			}else{
				popUp.x=int((p.width-popUp.width)/2)
				popUp.y=int((p.height-popUp.height)/2)
			}
			
		}
		
		public function removePopUp(popUp:DisplayObject):void
		{
			if(popUp is IUIComponent)
				IUIComponent(popUp).isPopUp=false
			
			if(!popUp.parent)
				return;
			
			popUp.parent.removeChild(popUp)
			if(popUp is TitledWindow)
				(popUp as TitledWindow).hidemodal()
		}
		
		public function bringToFront(popUp:DisplayObject):void
		{
			if(!popUp.parent)
				return
			//if(popUp.parent is Container)
				
		}
		
	}
}