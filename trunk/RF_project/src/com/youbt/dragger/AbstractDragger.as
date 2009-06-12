package com.youbt.dragger
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import com.youbt.events.DragAndDropEvent;
	import flash.events.MouseEvent;
	import com.youbt.geom.IntPoint;
	import flash.geom.Point;

	public class AbstractDragger extends Sprite
	{
		private var dropTrigger:Boolean;
		private var dragEnabled:Boolean;
		
		private var dragAcceptableInitiator:Dictionary;
		private var dragAcceptableInitiatorAppraiser:Function;
		
		public function AbstractDragger()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __mouseDown);
		}
		
		/**
		 *  添加接受可放入对像;
		 * @param com
		 * 
		 */		
		public function addDragAcceptableInitiator(com:AbstractDragger):void{
			if(dragAcceptableInitiator == null){
				dragAcceptableInitiator = new Dictionary(true);
			}
			dragAcceptableInitiator[com] = true;
		}
		
		/**
		 *  删除已存在可让此容器放入对像;
		 * @param com
		 * 
		 */		
		public function removeDragAcceptableInitiator(com:AbstractDragger):void{
			if(dragAcceptableInitiator != null){
				dragAcceptableInitiator[com] = undefined;
				delete dragAcceptableInitiator[com];
			}
		}
		
		/**
		 * 是否为此容器接受的拖曳对像; 
		 * @param com
		 * @return 
		 * 
		 */		
		public function isDragAcceptableInitiator(com:AbstractDragger):Boolean{
			if(dragAcceptableInitiator != null){
				return dragAcceptableInitiator[com] == true;
			}else{
				if(dragAcceptableInitiatorAppraiser != null){
					return dragAcceptableInitiatorAppraiser(com);
				}else{
					return false;
				}
			}
		}
		
		/**
		 * 放入检查函数; 
		 * @param func
		 * 
		 */		
		public function setDragAcceptableInitiatorAppraiser(func:Function):void{
			dragAcceptableInitiatorAppraiser = func;
		}
		
		
		/**
		 * 设置是否接受拖曳; 
		 * @param b
		 * 
		 */		
		public function setDragEnabled(b:Boolean):void{
			dragEnabled = b;
		}
		public function isDragEnabled():Boolean{
			return dragEnabled;
		}
		
		/**
		 * 是否为拖拽目标;
		 * @param b
		 * 
		 */		
		public function setDropTrigger(b:Boolean):void{
			dropTrigger = b;
		}
		public function isDropTrigger():Boolean{
			return dropTrigger;
		}
		
		
		
		/**
		 * 取 
		 * @return 
		 * 
		 */		
		public function getMousePosition():IntPoint{
	    	return new IntPoint(mouseX, mouseY);
	    }
	    
		/**
		 * 取得全局坐标; 
		 * @param rv
		 * @return 
		 * 
		 */	    
		public function getGlobalLocation(rv:IntPoint=null):IntPoint{
				var gp:Point = localToGlobal(new Point(0, 0));
				if(rv != null){
					rv.setLocationXY(gp.x, gp.y);
					return rv;
				}else{
					return new IntPoint(gp.x, gp.y);
				}
		}
		
		private function __mouseDown(e:MouseEvent):void{			
			if(isDragEnabled()){
				addEventListener(MouseEvent.MOUSE_MOVE, __mouseMove);
				addEventListener(MouseEvent.ROLL_OUT, __rollOut);
				stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUp, false, 0, true);
				pressingPoint = getMousePosition();
			}
		}
		
		private var pressingPoint:IntPoint;
		private function __mouseUp(e:MouseEvent):void{
			stopListernDragRec();
		}
		private function __mouseMove(e:MouseEvent):void{
			var mp:IntPoint = getMousePosition();
			if(mp.distanceSq(pressingPoint) > 1){
				fireDragRecognizedEvent(null);
				stopListernDragRec();
			}
		}
		private function __rollOut(e:MouseEvent):void{
			stopListernDragRec();
		}
		private function stopListernDragRec():void{
			removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMove);
			removeEventListener(MouseEvent.ROLL_OUT, __rollOut);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __mouseUp);
		}
		
		/**
		 * 触发用户想拖动事件; 
		 * @param touchedChild
		 * 
		 */		
		private function fireDragRecognizedEvent(touchedChild:AbstractDragger):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_RECOGNIZED, this, null, new IntPoint(stage.mouseX, stage.mouseY)));
		}
		
		
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragOverringEvent(dragInitiator:AbstractDragger, sourceData:SourceData, mousePos:IntPoint):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_OVERRING, dragInitiator, sourceData, mousePos, this));
		}
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragExitEvent(dragInitiator:AbstractDragger, sourceData:SourceData, mousePos:IntPoint, relatedTarget:AbstractDragger):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT, dragInitiator, sourceData, mousePos, this, relatedTarget));
		}
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragDropEvent(dragInitiator:AbstractDragger, sourceData:SourceData, mousePos:IntPoint):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_DROP, dragInitiator, sourceData, mousePos, this));
		}  
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragEnterEvent(dragInitiator:AbstractDragger, sourceData:SourceData, mousePos:IntPoint, relatedTarget:AbstractDragger):void{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_ENTER, dragInitiator, sourceData, mousePos, this, relatedTarget));
		}
			
		
	}
}