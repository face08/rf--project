package com.youbt.excuter
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public final class DynamicRateExcuter extends EventDispatcher
	{
		
		private static var instances:Array=new Array()
		
		private var timer:Timer;
		
		private var iexec:IDynamicExcuter
		private var st:Stage;
		
		public function DynamicRateExcuter(st:Stage,iexec:IDynamicExcuter,customFactor:Number=1)
		{
			this.iexec=iexec;
			this.st=st;		
			sR=st.frameRate	
			cf=customFactor;
			
			timer=new Timer(1000,0)
			timer.addEventListener(TimerEvent.TIMER,timeHandler)
			
			 
		}
		
		public function setExcuter(iexec:IDynamicExcuter):void
		{
			this.iexec=iexec;
		}
		public function getExcuter():IDynamicExcuter
		{
			return this.iexec
		}
		
		private var cf:Number
		public var isExcuting:Boolean=false;
		
		public function Excute():void
		{
			
			// notice  this implement is adapted for heavy cpu usage excution
			if(st){
				st.addEventListener(Event.ENTER_FRAME,enterFrameHandler)
				timer.start()
				isExcuting=true;
				
				if(instances.indexOf(this)==-1){
					instances.push(this);
				}
				tte=int(1000/sR*factorN*0.9/instances.length*cf)
				
				
			}else{
				throw(new Error("Excutiong Error stage not found"));
			}
		}
		
		public function stop():void
		{
			if(st){
				st.removeEventListener(Event.ENTER_FRAME,enterFrameHandler)
				timer.removeEventListener(TimerEvent.TIMER,timeHandler)
				var idx:int=instances.indexOf(this)
				if(idx>-1){
					instances.splice(idx,1);
				}
				
			}
			isExcuting=false
			this.dispatchEvent(new Event(Event.COMPLETE))
		}
				
		public static var factorN:Number=1;
		
		
		/**
		 * swf's framerate 
		 */		
		private var sR:int
		
		/**
		 * running time framerate 
		 */		
		private var cR:int
		/**
		 * time to excute
		 * dynamic excution time
		 * assume stage framerate is 24 
		 * tte=1000/24 ,interavl to excute code
		 * we can not use all the time to exucte ,levae some cpu to other excution
		 * tte=tte*factorN  
		 * 
		 * all the instances split up the tte
		 * tte=tte/instances.length
		 * if some instance need high priority,with a custom factor  
		 * tte=tte*cf 
		 * 
		 * cR record real frame rate every 1000 ms 
		 * tte=tte*cR/sR
		 * 
		 * initial     :int(1000/sR*0.9*factorN/instances.length*cf)
		 * running time:int(1000/sR*(cR/sR)*factorN/instances.length*cf);
		 * 
		 * tte is advised time to excute
		 * if we need running @ 100% cpu load ,tte=1000
		 * 
		 */		
		private var tte:int;
		private function timeHandler(e:Event):void
		{
			// 动态补偿
			if(instances.length>0){
				tte=int(1000/sR*(cR/sR)*factorN/instances.length*cf);
			}
			cR=0;
		}
		public var sleep:Boolean=false
		private function enterFrameHandler(e:Event):void
		{
			
			if(sleep)
				return;
			
			if(iexec.excute(getTimer(),tte)==0){
				this.stop()
			}
			cR++
			
		}
		
		public static function invaildate(start:int,ttl:int):Boolean
		{
			var its:int=getTimer()-start
			if(its>ttl){
				return true;
			}
			return false;
		}

	}
}