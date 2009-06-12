package com.youbt.controls
{
import com.youbt.manager.RFDragManager;
import com.youbt.manager.RFSystemManager;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
	
	public class AeroTitleWindow extends TitledWindow
	{
		public function AeroTitleWindow()
		{
			super();
			if(!bmpcache)
				bmpcache=new BitmapData(RFSystemManager.PopupContainer.width,RFSystemManager.PopupContainer.height,true)
		}
		public function showeffect():void{
		}
		
		public var popup:DisplayObject;
		/* override public function set DisplayContent(value:*):void{
			
			
		} */
		private var _aerorez:Rectangle
		
		public function set AeroArea(r:Rectangle):void{
			_aerorez=r
		}
		
		public function get AeroArea():Rectangle{
			if(_aerorez){
				return new Rectangle(rect.x+_aerorez.x,rect.y+_aerorez.y,_aerorez.width,_aerorez.height)
			}else{
				return rect
			}
			this.rect
		}
		override public function addDrag(e:InteractiveObject,flag:Boolean=true):void {
			super.addDrag(e,flag)
			if(!shape){
			shape=new Shape()
			shape.y=550
			RFSystemManager.CursorContainer.addChild(shape)
			shape.filters=[blur]
			}
		}
		override public function onDrag(e:MouseEvent):void {
			if (e.type == MouseEvent.MOUSE_DOWN) {
				RFDragManager.startDrag(DisplayContent as Sprite);
				RFSystemManager.getInstance().stage.addEventListener(Event.ENTER_FRAME,onDraging)
			} else if (e.type == MouseEvent.MOUSE_UP) {
				RFDragManager.stopDrag();
				RFSystemManager.getInstance().stage.removeEventListener(Event.ENTER_FRAME,onDraging)
			}
		}
		private var blur:BlurFilter=new BlurFilter()
		private var shape:Shape
		private static var bmpcache:BitmapData
		private static var mt:Matrix=new Matrix(1.005,0,0,1.005)
		
		protected function onDraging(e:Event):void{
			
			var rec:Rectangle=AeroArea
			bmpcache.lock()
			bmpcache.draw(RFSystemManager.ApplicationContainer,null,null,null,rec)
			bmpcache.unlock(rect)
			mt.tx=-rec.x
			mt.ty=-rec.y
			shape.graphics.beginBitmapFill(bmpcache,mt)
			//shape.graphics.drawRect(0,0,bmpcache.rect.width,bmpcache.rect.height)
			shape.graphics.drawRect(0,0,rec.width,rec.height)
			
			
		}
	}
}