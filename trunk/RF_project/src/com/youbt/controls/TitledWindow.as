package com.youbt.controls
{
	import com.youbt.core.UIComponent;
	import com.youbt.manager.RFSystemManager;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 	弹出窗口;
	 * @author crl
	 * 
	 */	
	
	public class TitledWindow extends UIComponent
	{
		protected var dragArea:Sprite;
		protected var closeButton:SimpleButton;		
		protected var _skin:Sprite;				
				
		protected var container:Sprite;
		protected var background:Sprite;
		
		public function TitledWindow() {
			this.defaults();
			this.initialize();
		}
		
		/**
		 * 默认创建内容;
		 */
		protected function defaults():void {
			container = new Sprite();
			background = new Sprite();
			addChild(background);
			addChild(container);
		}
		
		public override function initialize():void{
			this.init();
		}
		protected function init():void{
			
		}
		
		public function set skin(_skin:Sprite):void{
			this._skin=_skin;
			this.bindComponent();
			this.bindEvent();
		}
		public function get skin():Sprite{
			return this._skin;
		}
		
		
		protected function bindComponent():void{
			this.container.addChild(skin);	
			try
			{
				this.dragArea=skin[this.getDragAreaName()] as Sprite;
				this.setDrager(true);
				this.closeButton=skin[this.getCloseButtonName()] as SimpleButton;
				this.closeButton.addEventListener(MouseEvent.CLICK,closeHander);
			}
			catch(e:Error)
			{
				throw new Error("资源不存在");
			}
			
			this.DisplayContent=this.container;	
		}
		
		protected function bindEvent():void{
			//了
		}
		
		protected function getDragAreaName():String{
			return "bg";
		}
		protected function getCloseButtonName():String
		{
			return "closeBtn";
		}
		
		protected function closeHander(event:MouseEvent):void{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		
		public function setDrager(bool:Boolean=true):void
		{
			this.addDrag(this.dragArea,bool);
		}
		
		
		public function showmodal():void
		{
				var tempStage:Stage=RFSystemManager.getInstance().stage;
				if(!tempStage){ 
					return;
				}
				var g:Graphics=this.background.graphics;
				g.clear();
				g.beginFill(0,.5);
				g.drawRect(0,0,tempStage.stageWidth,tempStage.stageHeight);
				g.endFill();
				
				/* 
				var bl:BlurEffect=new BlurEffect(RFSystemManager.ApplicationContainer)
				bl.blurXFrom=0
				bl.blurXTo=5
				bl.blurYFrom=0
				bl.blurYTo=5
				bl.duration=1000
				bl.play()  */
				/*var fa:FadeGrayEffect=new FadeGrayEffect(RFSystemManager.ApplicationContainer)
				fa.saturationFrom=1
				fa.saturationTo=0;
				fa.duration=1000
				fa.play() 
				*/
				//RFSystemManager.ApplicationContainer.mouseChildren=false
				//RFSystemManager.ApplicationContainer.mouseEnabled=false
				
		}
		
		public function hidemodal():void
		{
			RFSystemManager.ApplicationContainer.filters=[]
		}	
	
	}
}