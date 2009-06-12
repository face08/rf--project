package com.youbt.containers
{
	import com.youbt.core.UIComponent;
	
	import flash.events.Event;

	public class Container extends UIComponent
	{
		public function Container()
		{
			super();
		}
		
		
		private var _autoLayout:Boolean=false;
		
		override public function initialize():void{
			DisplayContent=this
			initialized=true;
		}
		
		public function set autoLayout(value:Boolean):void{
			if(value==_autoLayout)
				return;
			_autoLayout=value
			if(value){
				if(stage){
					stage.addEventListener(Event.RESIZE,stageresizehandler)
				}else{
					addEventListener(Event.ADDED_TO_STAGE,addedtostagehandler)
				}
			}else{
				if(stage)
					stage.removeEventListener(Event.RESIZE,stageresizehandler)
				
			}
		}
		public function get autoLayout():Boolean{
			return _autoLayout
		}
		
		private function stageresizehandler(e:Event=null):void{
			//  to do : better way...
			if(stage){
				graphics.clear()
				graphics.moveTo(0,0)
				graphics.lineTo(stage.stageWidth,stage.stageHeight)
			}
			
		}
		private function addedtostagehandler(e:Event):void{
			if(_autoLayout){
				stageresizehandler()
				stage.addEventListener(Event.RESIZE,stageresizehandler)
			}else{
				stage.removeEventListener(Event.RESIZE,stageresizehandler)
			}
			removeEventListener(Event.ADDED_TO_STAGE,addedtostagehandler)
		}
	}
}