package com.youbt.core
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.events.RFEvent;
	import com.youbt.events.UIComponentEvent;
	import com.youbt.manager.RFDragManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	use namespace rf_internal
	
	/**
	 *  RF ui组件类 
	 * 
	 * 
	 */
	public class UIComponent extends RFSprite implements IUIComponent
	{
		
		////////////////////////////////////////////////////////////////////////////////
		/////  屬性
		////////////////////////////////////////////////////////////////////////////////
		rf_internal var _measurewidth:Number=0;
		rf_internal var _measureheight:Number=0;
				
		private var valid:Boolean
		
		
		/**
		 * 构造方法 
		 * 
		 */
		public function UIComponent()
		{
			super();
			focusRect=false
			enabled=true
			_content=this;
//			initialize()
		}
		
		////////////////////////////////////////////////////////////////////////////////
		/////  getter/setter 方法
		////////////////////////////////////////////////////////////////////////////////
		
		
		/**
		 * start() method to addEventlisteners to self component
		 *  
		 * 
		 */
		public function start():void{
			dispatchEvent(new UIComponentEvent(UIComponentEvent.START));
		}
		
		/**
		 * sleep() 
		 *  
		 */
		public function sleep():void{
			dispatchEvent(new UIComponentEvent(UIComponentEvent.SLEEP));
		}
		
		
		/**
		 * enable getter/ setter 
		 */		
		private var _enabled:Boolean
		
		public function get enabled():Boolean{
			return _enabled
		}
		
		public function set enabled(value:Boolean):void{
			_enabled=value
		}
		
		
		/**
		 * isPopUp getter/setter 
		 */
		private var _isPopup:Boolean
		
		public function get isPopUp():Boolean{
			return _isPopup
		}
		
		public function set isPopUp(value:Boolean):void{
			_isPopup=value
		}
		
		
		/**
		 * owner getter/setter 
		 */
		private var _owner:DisplayObjectContainer
		
		public function get owner():DisplayObjectContainer
		{
			return _owner
		}
		
		public function set owner(value:DisplayObjectContainer):void
		{
			//todo need be complete	
		}
		
		/**
		 * initialized getter/setter 
		 */
		private var _initialized:Boolean=false
		
		public function get initialized():Boolean{
			return _initialized
		}
		
		public function set initialized(value:Boolean):void{
			_initialized=value
			
			if(value)
			{
				dispatchEvent(new UIComponentEvent(UIComponentEvent.INITIALIZED));
			}
		}
		
		/**
		 *  DisplayContent getter/setter 
		 */				
		private var _content:DisplayObject
		public function set DisplayContent(value:*):void {
			try{
				_content=value;
				if(_content!=this && !this.contains(_content)){
					this.addChild(_content)
				}
			}catch(e:Error)
			{
				RFTraceError(this.toString(),e)
			}
		}
		public function get DisplayContent():* {
			return _content;
		}
		
		////////////////////////////////////////////////////////////////////////////////
		/////  方法
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 初始化 
		 * 
		 */
		public function initialize():void{
			initialized=true
			
			// TO BE OVERRIDE
		}
		
		
		public function get Children():Array
		{
			var i:int=0;
			var temp:Array=[];
			while(i<numChildren){
				temp.push(getChildAt(i));
				i++;
			}
			return temp;
			
		}
		
		public function get rect():Rectangle{
			var r:Rectangle=new Rectangle(_content.x,_content.y,_content.width,_content.height)
			return r
		}

		public function isVisible():Boolean{
			return _content.visible
		}
		
		public function isOnStage():Boolean{
			return _content.stage!=null
		}
		
		public function isShowing():Boolean{
			if(isVisible() && isOnStage()){
				return true;
			}
			return false
		}
		
		
		
		public function get measureHeight():Number{
			return _measureheight
		}
		public function set measureHeight(value:Number):void{
			_measureheight=value
		}
		
		public function get measureWidth():Number{
			return _measurewidth
		}
		public function set measureWidth(value:Number):void{
			_measurewidth=value
		}
		
		public function measure():void{
			
			_measurewidth=_content.width;
			_measureheight=_content.height;
			
		
		}
		
		public function validate():void{
			if(!valid)
				valid=true
		}
		
		
		
		
		public function invalidate():void{
			valid=false
			
			// to do : implements some layout method
			
			var par : Object = _content.parent
			if(par is UIComponent){
				if(par.isVaild()){
					par.invalidate();
				}
			}
		}
		
		public function isValid():Boolean{
			return valid
		}
		
		
		public function move(x:Number, y:Number):void
    	{
        	var changed:Boolean = false;

        	if (x != super.x)
        	{
            	super.x = x;
            //	dispatchEvent(new Event("xChanged"));
            	changed = true;
        	}

	        if (y != super.y)
    	    {
        	    super.y = y;
            //	dispatchEvent(new Event("yChanged"));
            	changed = true;
        	}

	        //if (changed)
    	      //  dispatchMoveEvent();
    	}
		
	
		public function addDrag(e:InteractiveObject,flag:Boolean=true):void {
			if (flag) {
				e.addEventListener(MouseEvent.MOUSE_DOWN,onDrag);
				e.addEventListener(MouseEvent.MOUSE_UP,onDrag);
			} else {
				e.removeEventListener(MouseEvent.MOUSE_DOWN,onDrag);
				e.removeEventListener(MouseEvent.MOUSE_UP,onDrag);
			}
		}
		public function onDrag(e:MouseEvent):void {
			if (e.type == MouseEvent.MOUSE_DOWN) {
				RFDragManager.startDrag(this as Sprite);
			} else if (e.type == MouseEvent.MOUSE_UP) {
				RFDragManager.stopDrag();
			}
		}
		public function remove():void {
			if(parent)
				parent.removeChild(this)
					
			//RFDragManager.stopDrag();
		}
		
		protected function show():void{
			this._content.visible=true
		}
		protected function hide(e:MouseEvent=null):void{
			this._content.visible=false;
		}
		
		protected function bringtotop():void{
			//TODO
			
		}
		
		public function owns(displayobjcet:DisplayObject):Boolean{
			//TODO
			return true
		}
		
	/* 	override public function get x():Number
    	{
    		if(_content && _content!=this)
    			return _content.x
    	   	return super.x;
    	}

    	override public function set x(value:Number):void
    	{
    		if (super.x == value)
            	return;
            	
    		if(_content && _content!=this){
    			_content.x=value
    			
    		}
    		super.x = value;
        	

			
    	}		
		
		 override public function get y():Number
    	{
        	if(_content && _content!=this)
    			return _content.y
    	   	return super.y;
    	}


    	override public function set y(value:Number):void
    	{
        	if (super.y == value)
            	return;
            	
    		if(_content && _content!=this){
    			_content.y=value
    			
    		}
    		super.y = value;
    	} */
		
		
		
	
		

		
		
	}
}