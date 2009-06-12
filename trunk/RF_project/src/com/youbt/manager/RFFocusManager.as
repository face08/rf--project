package com.youbt.manager
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	
	
	/**
	 *  简单版;
	 * @author crlnet
	 * 
	 */	
	public class RFFocusManager
	{
		private var stage:Stage;
		
		public var lastFocus:InteractiveObject;
		
		public function RFFocusManager()
		{
			getStage();
		}
		
		private static var instance:RFFocusManager;
		public static function getInstance():RFFocusManager{
			if(instance==null){
				instance=new RFFocusManager();
				instance.setFocusRectEnable(false);
			}
			return instance;
		}
		
		
		public function setFocusRectEnable(bool:Boolean):void{
			stage.stageFocusRect=bool;
		}
		
		
		public function setFocus(value:InteractiveObject):void{
			//if()
			
			stage.focus=value;
			
			
		}
		
		public function getFocus():InteractiveObject{
			return stage.focus;
		}
		
		
		public function getStage():Stage{
			if(stage==null){
				stage=RFSystemManager.ApplicationContainer.stage;
			}
			return stage;
		}

	}
}