package com.youbt.manager
{
	
	import com.youbt.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	

	/**
	 * RFDragManager 用于管理所有拖曳操作
	 * 
	 * 			
	 * @see com.youbt.events.RFEvent
	 */	
	
	[ExcludeClass]
	public class RFDragManagerImpl
	{
		private static var _w:Number;
		private static var _h:Number;
		private static var _s:Stage;
		private static var _isDraging:Boolean=false;
		private static var _Draged:Sprite;
		private static var _listener:Object;
		private static var _drop:IDroppable;
		
		
		public function RFDragManagerImpl()
		{
			_w=RFSystemManager.getInstance().stage.stageWidth;
			_h=RFSystemManager.getInstance().stage.stageHeight;
			RFSystemManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP,onForceStopDrag);
		
		}
		private function onForceStopDrag(e:MouseEvent):void{
			if(_isDraging){
				RFDragManager.stopDrag()
			}
		}
		
		/**
		 * 开始拖曳 
		 * @param d  拖曳的对象
		 * @param r  可拖曳的范围
		 * @param t  lockcentre
		 * @param listener
		 * @param drop
		 * 
		 */		
		public function startDrag(d:Sprite,r:Rectangle=null,t:Boolean=false,listener:Object=null,drop:IDroppable=null):void{
			
			if(_isDraging && _listener){
				_listener.onStopDrag()
			}
			_listener=listener;
			_drop=drop
			var drag:Sprite;
			if(r==null){
				var dw:Number
				var dh:Number
				if(d is UIComponent){
					dw=(d as UIComponent).measureWidth
					dh=(d as UIComponent).measureHeight
					drag=(d as UIComponent).DisplayContent
				}else{
					dw=d.width
					dh=d.height
					drag=d
				}
				var a:Rectangle=new Rectangle(0,0,_w-dw,_h-dh)
				drag.startDrag(t,a)
			}else{
				if(r.equals(new Rectangle)==true)r=null;
				
				d.startDrag(t,r)	
				drag=d			
			}
			drag.cacheAsBitmap=true
			_Draged=d;
			_isDraging=true
		}
		
		/**
		 *  停止拖曳
		 *  
		 */		
		public function stopDrag():void{
			
			if(_drop){
				if(_drop.AcceptDrop()){
					_isDraging=false
					if(_Draged!=null){
					_Draged.stopDrag()
			 		}
			 		if(_listener){
					_listener.onStopDrag()	
					}
				}
			}else{
				_isDraging=false
				if(_Draged!=null){
					_Draged.stopDrag()
			 	} 
			 	if(_listener){
				_listener.onStopDrag()	
				}
			}
			
		}
		
		public function get isDraging():Boolean{
			return _isDraging;
		}

	}
}

