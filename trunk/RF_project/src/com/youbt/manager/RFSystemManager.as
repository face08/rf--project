package com.youbt.manager{
	
	import com.youbt.containers.Container;
	import com.youbt.debug.DebugUtils;
	import com.youbt.debug.RFTraceSummary;
	import com.youbt.events.RFEvent;
	import com.youbt.events.RFLoaderEvent;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.Graphics;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.Timer;



	[Event(name="preinitialize", type="com.youbt.events.RFEvent")]
	[Event(name="initialize", type="com.youbt.events.RFEvent")]
	[Event(name="loadingComplete", type="com.youbt.events.RFEvent")]
	
	
	/**
	 * RFSystemManager
	 * 
	 * @example
	 * <listing version="3.0">
	 * 运行在RFSystemManager上的事件,按照顺序排列
	 * RFEvent.INIT_PROGRESS  载入主程序
	 * RFEvent.PREINITIALIZE  载入到PREOLOADER后开始调用
	 * RFEvent.INIT_COMPLETE  载入完成
	 * RFEvent.INITIALIZE     主程序实力创建完毕
	 * RFEvent.LOADING        主程序载入相关资源
	 * RFEvent.LOADING_COMPLETE  应用创建完毕
	 * RFEvent.CREATION_COMPLETE   创建组建
	 * 
	 * RFSystemManager显示结构
	 * 		SystemManager
	 * 			CursorContainer
	 * 			MainContainer
	 * 					PopupContainer
	 *	 				ApplicationContainer
	 * 						SomeContainer
	 * 						Loader
	 * 							Loaded App's SystemManager
	 * 								Application
	 * 									ThisComponent
	 * 			MouseCatacher
	 * </listing>
	 * 			
	 * @see com.youbt.events.RFEvent
	 */	

	public class RFSystemManager extends MovieClip {
		private var timer:Timer;
		//private var conn:LocalConnection;

		private var _topLevel:Boolean;
		private var _isStageRoot:Boolean;
		private var _id:String
		
		public function RFSystemManager() {

			super();
			
			
			RFTraceSummary("RFSystemManage created at",this.currentFrame,this.totalFrames)
			
			if (stage) {
				stage.scaleMode=StageScaleMode.NO_SCALE;
				stage.align=StageAlign.TOP_LEFT;
			}


			if (RFSystemManagerGlobals.topLevelSystemManagers.length > 0 && ! stage) {
				_topLevel=false;
			}else{
				_topLevel=true
				_instance=this;
			}

			if (! stage) {
				_isStageRoot=false;
			}else{
				_isStageRoot=true;
			}
			stop();
			
			_id=RFSystemManagerGlobals.topLevelSystemManagers.length.toString()
			 if (_topLevel && stage)
			{
				if( currentFrame != 1){ 
					//	throw new Error("The SystemManager constructor was called when the currentFrame was at " + currentFrame );
						//TODO: FLEX INTERGRATION
				}
				
				_MainContainer=new Container
				_ApplicationContainer=new Container
				_CursorContainer=new Container
				_PopupContainer=new Container
				_ApplicationContainer.autoLayout=true
				_PopupContainer.autoLayout=true
				mouseCatcher=new Sprite()
				addChild(_MainContainer)
				addChild(_CursorContainer)
				addChildAt(mouseCatcher,0)
				_MainContainer.addChild(_ApplicationContainer)
				_MainContainer.addChild(_PopupContainer)	
				_topLevelSystemManager=this;
				
				if(stage) 
					stage.addEventListener(Event.RESIZE,Stage_resizeHandler)
				
					
			} 
			RFSystemManagerGlobals.topLevelSystemManagers.push(this);
			
			timer=new Timer(80,0);
			timer.addEventListener(TimerEvent.TIMER,progresshandler);
			timer.start();		
			if (root && root.loaderInfo) {
				root.loaderInfo.addEventListener(Event.INIT,initHandler);
			}
			addEventListener("ba",exhandler)
			
			DebugUtils.isDebugMode=true
			DebugUtils.isPanelOutput=true
			
			RFTraceSummary('',this," created at",this.currentFrame,this.totalFrames,RFSystemManagerGlobals.topLevelSystemManagers.length)
			
			prompt=new TextField()
			this.addChild(prompt)
			prompt.text="Pls wait";
			//trace("toplevel:",_topLevel,"isStageRoot:",_isStageRoot,stage,this.loaderInfo.loaderURL)

		}
		private var prompt:TextField;
		
		override public function dispatchEvent(event:Event):Boolean
		{
			if(preventEvent){
				return false
			}
			return super.dispatchEvent(event)
		}
		public function checkEvent(event:Event=null):Boolean
		{
			return !preventEvent;
		}
		
		private function exhandler(e:Event):void
		{
			
			if(stage){
				while(stage.numChildren>0){
					stage.removeChildAt(0)
				}
			}
			preventEvent=true;
			
		}
		private var preventEvent:Boolean=false

	
		private static var _CursorContainer:Container
		public static function get CursorContainer():Container{
			return _CursorContainer
		}
		private static var _PopupContainer:Container
		public static function get PopupContainer():Container{
			return _PopupContainer
		}
		private static var _ApplicationContainer:Container
		public static function get ApplicationContainer():Container{
			return _ApplicationContainer
		}
		private static var _MainContainer:Container;
		public static function get MainContainer():Container{
			return _MainContainer
		}		
		private static  var _instance:RFSystemManager;
		public static  function getInstance():RFSystemManager {
			if(!_instance)
				_instance=new RFSystemManager()
			return _instance; 
		}

		private var mouseCatcher:Sprite;
		
		
		private function resizeMouseCatcher():void {
			if (mouseCatcher) {
				var g:Graphics=mouseCatcher.graphics;
				g.clear();
				g.beginFill(0x0f0000,0);
				g.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				g.endFill();
			}
		}
		private function initHandler(event:Event):void {
			//allSystemManagers[this] = this.loaderInfo.url;
			root.loaderInfo.removeEventListener(Event.INIT,initHandler);

		}

		
//		private function extraFrameHandler(e:Event=null):void{
//			
//		}
		private var proloader:DisplayObject;
		
		private function progresshandler(e:TimerEvent):void {

			if (! root) {
				return;
			}
			
			var bytes:Object=getByteValues();
			var loaded:int=bytes.loaded;
			var total:int=bytes.total;   
			if(framesLoaded>=2 && !proloader){
				if(this.currentFrame!=2){
					gotoAndStop(2)
				}
				var na:String=(currentLabels[1] as FrameLabel).name.split("_").join(".");
				
				if(ApplicationDomain.currentDomain.hasDefinition(na)){
					try{
						var p:Class=Class(ApplicationDomain.currentDomain.getDefinition(na))
						proloader=new p()
						RFSystemManager.ApplicationContainer.addChild(proloader)
					}catch(e:Error){
						
					}
					
					RFSystemManager.getInstance().dispatchEvent(new RFEvent(RFEvent.PREINITIALIZE))
				}
			} 
			RFSystemManager.getInstance().dispatchEvent(new RFLoaderEvent(RFLoaderEvent.PROGRESS,false,false,loaded,total))
			if (loaded >= total && total > 0 || framesLoaded==totalFrames && proloader) {
				if(proloader && proloader.parent){
					proloader.parent.removeChild(proloader)
				}
				this.removeChild(prompt)
				
				RFSystemManager.getInstance().dispatchEvent(new RFLoaderEvent(RFLoaderEvent.COMPLETE,false,false,loaded,total))
				
				timer.stop()
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER,progresshandler);
				
				deferredNextFrame();
			}
			
			
		}
		private var nextFrameTimer:Timer;
		private function deferredNextFrame():void {
			
			if (currentFrame + 1 > totalFrames) {
				return;
			}

			if (currentFrame + 1 <= framesLoaded) {
				nextFrameTimer=new Timer(150);
				nextFrameTimer.addEventListener(TimerEvent.TIMER,nextFrameTimerHandler);
				nextFrameTimer.start();
				nextFrame()
			} else {

			}
		}
		
		override public function nextFrame():void
		{
			try{
					super.nextFrame();
			}catch(e:Error){
					trace(e)
			}
		}
		private function initialize():void {
			var total:int=currentLabels.length;
			gotoAndStop(3)
			
			if(total>2){
				for(var i:int=2;i<total;i++){
					var na:String=(currentLabels[i] as FrameLabel).name;
					try{
						var classname:String=na.split("_").join(".")
						var p:Class=Class(ApplicationDomain.currentDomain.getDefinition(classname))
						RFSystemManager.ApplicationContainer.addChild(new p())
					}catch (err:Error) {
				 		RFTraceSummary('',err,classname,na,ApplicationDomain.currentDomain)
					}
				}
			}	
			RFSystemManager.getInstance().dispatchEvent(new RFEvent(RFEvent.INITIALIZE,!_topLevel))
		}

		private function nextFrameTimerHandler(e:TimerEvent):void {
			if (currentFrame + 1 <= framesLoaded) {
				// if (currentFrame + 1 <= framesLoaded)
				nextFrame();
			}else{
				initialize()
				nextFrameTimer.stop()
				nextFrameTimer.reset()
				nextFrameTimer.removeEventListener(TimerEvent.TIMER,nextFrameTimerHandler)
				
			}
		}

		private function getByteValues():Object {
			var li:LoaderInfo=root.loaderInfo;
			var loaded:int=li.bytesLoaded;
			var total:int=li.bytesTotal;
			return {loaded:loaded,total:total};
		}
		
		
		private var _topLevelSystemManager:*;
		private var _screen:Rectangle;
		private var _height:Number;
		private var _width:Number;

		private function Stage_resizeHandler(event:Event=null):void {
			var w:Number=stage.stageWidth;
			var h:Number=stage.stageHeight;
			var m:Number=loaderInfo.width;
			var n:Number=loaderInfo.height;

			var x:Number=m - w / 2;
			var y:Number=n - h / 2;

			var align:String=stage.align;

			if (align == StageAlign.TOP) {
				y=0;
			} else if (align == StageAlign.BOTTOM) {
				y=n - h;
			} else if (align == StageAlign.LEFT) {
				x=0;
			} else if (align == StageAlign.RIGHT) {
				x=m - w;
			} else if (align == StageAlign.TOP_LEFT || align == "LT") {// player bug 125020
				y=0;
				x=0;
			} else if (align == StageAlign.TOP_RIGHT) {
				y=0;
				x=m - w;
			} else if (align == StageAlign.BOTTOM_LEFT) {
				y=n - h;
				x=0;
			} else if (align == StageAlign.BOTTOM_RIGHT) {
				y=n - h;
				x=m - w;
			}

			if (! _screen) {
				_screen=new Rectangle  ;
			}
			_screen.x=x;
			_screen.y=y;
			_screen.width=w;
			_screen.height=h;

			if (_isStageRoot) {
				_width=stage.stageWidth;
				_height=stage.stageHeight;
			}

			if (event) {
				resizeMouseCatcher();
				RFSystemManager.getInstance().dispatchEvent(event);
			}
		}
		
		public function get screen():Rectangle{
			if(!_screen){
				Stage_resizeHandler()
			}
			return _screen
		}
		
		public function setStage(st:Stage):void
		{
			if(st){
				_stage=st;
			}
		}
		private var _stage:Stage
		
		override public function get loaderInfo():LoaderInfo
		{
			if(super.loaderInfo){
				return super.loaderInfo
			}else if(stage){
				return stage.loaderInfo
			}
			return null
		}
		override public  function get stage():Stage {
			var s:Stage=super.stage;
			if (s) {
				return s;
			}

			if (! _topLevel && _topLevelSystemManager) {
				return _topLevelSystemManager.stage;
			}
			return _stage
		}
		/**
		 * @private 
		 */		
		public function info():Object {
			return {};
		}
		
		override public function toString():String{
			return "RFSystemManager"+_id;
		}
		
	}
}