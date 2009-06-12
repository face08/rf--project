package com.youbt.effects
{
	import flash.events.EventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import com.youbt.events.TweenEvent;

	public class Tween extends EventDispatcher {

		private static  var activeTweens:Array=[];
		private static  var interval:Number=10;
		private static  var timer:Timer=null;

		private var arrayMode:Boolean;

		private var listener:Object;
		private var startValue:Object;
		private var endValue:Object;
		private var duration:Number;
		private var minFPS:Number;
		private var maxDelay:Number=87.5;
		private var id:int;



		private static  var intervalTime:Number=NaN;

		private var previousUpdateTime:Number;
		private var startTime:Number;


		public function Tween(listener:Object,startValue:Object,endValue:Object,duration:Number=-1,minFps:Number=-1) {
			super();

			if (! listener) {
				return;
			}

			if (startValue is Array) {
				arrayMode=true;
			}

			this.listener=listener;
			this.startValue=startValue;
			this.endValue=endValue;

			if (! isNaN(duration) && duration != -1) {
				this.duration=duration;
			}

			// If user has specified a minimum number of frames per second,
			// remember the maximum allowable milliseconds between frames.
			if (! isNaN(minFps) && minFps != -1) {
				maxDelay=1000 / minFps;
			}

			if (duration == 0) {
				endTween();
			} else {
				Tween.addTween(this);
			}
		}
		private static  function addTween(tween:Tween):void {
			tween.id=activeTweens.length;
			activeTweens.push(tween);

			if (! timer) {
				timer=new Timer(interval);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
			} else {
				timer.start();
			}
			if (isNaN(intervalTime)) {
				intervalTime=getTimer();
			}

			tween.startTime=tween.previousUpdateTime=intervalTime;
		}

		private static  function timerHandler(e:TimerEvent):void {


			var oldTime:Number=intervalTime;
			intervalTime=getTimer();

			var n:int=activeTweens.length;

			for (var i:int=n; i >= 0; i--) {
				var tween:Tween=Tween(activeTweens[i]);
				if (tween) {
					tween.doInterval();
				}
			}
			e.updateAfterEvent();
		}
		private var _isPlaying:Boolean=true;
		private var _doSeek:Boolean=false;
		private var started:Boolean=false;
		public var playheadTime:Number=0;
		private var tweenEnded:Boolean=false;
		private var userEquation:Function=defaultEasingFunction;


		public function doInterval():Boolean {
			previousUpdateTime=intervalTime;

			if (_isPlaying || _doSeek) {

				var currentTime:Number=intervalTime - startTime;
				playheadTime=currentTime;

				var currentValue:Object=getCurrentValue(currentTime);

				if (currentTime >= duration && ! _doSeek) {
					endTween();
					tweenEnded=true;
				} else {
					if (! started) {
						dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
						started=true;
					}
					//dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE,false,false,currentValue));

					//if (updateFunction != null)
					//updateFunction(currentValue);
					//else
					listener.onTweenUpdate(currentValue);
				}
				_doSeek=false;
			}
			return tweenEnded;
		}
		private var _invertValues:Boolean=false;
		public function getCurrentValue(currentTime:Number):Object {
			if (duration == 0) {
				return endValue;
			}
			if (_invertValues) {
				currentTime=duration - currentTime;
			}

			if (arrayMode) {
				var returnArray:Array=[];
				var n:int=startValue.length;
				for (var i:int=0; i < n; i++) {
					returnArray[i]=userEquation(currentTime,startValue[i],endValue[i] - startValue[i],duration);
				}
				return returnArray;
			} else {
				return userEquation(currentTime,startValue,Number(endValue) - Number(startValue),duration);
			}
		}
		private function defaultEasingFunction(t:Number,b:Number,c:Number,d:Number):Number {
		//	return c / 2 * Math.sin(Math.PI * t / d - 0.5) + 1 + b;
			return c * t / d + b;
		}
		public function stopTween():void
		{
			var value:Object=getCurrentValue(duration);
			listener=null
			Tween.removeTweenAt(id);
		}

		public function endTween():void {
		
			var value:Object=getCurrentValue(duration);
			if(listener){
				listener.onTweenEnd(value);
				listener=null
				dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false,value))
		    }
			Tween.removeTweenAt(id);
		}
		private static  function removeTweenAt(index:int):void {
			if (index >= activeTweens.length || index < 0) {
				return;
			}

			activeTweens.splice(index,1);

			var n:int=activeTweens.length;
			for (var i:int=index; i < n; i++) {
				var curTween:Tween=Tween(activeTweens[i]);
				curTween.id--;
			}
			if (n == 0) {
				intervalTime=NaN;
				timer.reset();
			}
		}
		public function pause():void {
			_isPlaying=false;
		}
		/**
		 *  Resumes the effect after it has been paused 
		 *  by a call to the <code>pause()</code> method. 
		 */
		private var _doReverse:Boolean=false;
		public function resume():void {
			_isPlaying=true;

			startTime=intervalTime - playheadTime;
			if (_doReverse) {
				reverse();
				_doReverse=false;
			}
		}
		public function reverse():void {
			if (_isPlaying) {
				_doReverse=false;
				seek(duration - playheadTime);
				_invertValues=! _invertValues;
			} else {
				_doReverse=! _doReverse;
			}
		}
		public function seek(playheadTime:Number):void {
			// Set value between 0 and duration
			//playheadTime = Math.min(Math.max(playheadTime, 0), duration);
			var clockTime:Number=intervalTime;

			// Reset the previous update time
			previousUpdateTime=clockTime;

			// Reset the start time
			startTime=clockTime - playheadTime;

			_doSeek=true;
		}
		public function set easingFunction(value:Function):void
		{	
			userEquation = value;
		}
		public function get playReversed():Boolean
		{
			return _invertValues;
		}
	
		public function set playReversed(value:Boolean):void
		{
			_invertValues = value;
		}
	}
}