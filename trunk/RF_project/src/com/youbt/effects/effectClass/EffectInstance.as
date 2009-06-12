package  com.youbt.effects.effectClass
{

import com.youbt.events.EffectEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;


public class EffectInstance extends EventDispatcher implements IEffectInstance
{
	public function EffectInstance(target:Object)
	{
		super();
		this.target = target;
	}

	
	internal var delayTimer:Timer;
	private var delayStartTime:Number = 0;
	private var delayElapsedTime:Number = 0;
	private var hideOnEffectEnd:Boolean = false;
	private var playCount:int = 0;
	internal var stopRepeat:Boolean = false;
	public var isPlaying:Boolean=false;
	private function get actualDuration():Number 
	{
		var value:Number = NaN;
		if (repeatCount > 0)
		{
			value = duration * repeatCount +
					(repeatDelay * repeatCount - 1) + startDelay;
		}
		return value;
	}
	
	public var duration:Number = 500;



	
	public function get playheadTime():Number 
	{
		return Math.max(playCount - 1, 0) * duration + 
			   Math.max(playCount - 2, 0) * repeatDelay + 
			   (playReversed ? 0 : startDelay);
	}
	
	
	public var playReversed:Boolean;
	public var repeatCount:int=1;
	public var repeatDelay:int = 0;
	public var startDelay:int = 0;
	public var target:Object;
	internal var triggerEvent:Event;
	
	public function initEffect(event:Event):void
	{
		triggerEvent = event;
		
	/* 	switch (event.type)
		{
			case "resizeStart":
			case "resizeEnd":
 			
			case FlexEvent.HIDE:
			{
				target.setVisible(true, true);
				hideOnEffectEnd = true;		
				
				target.addEventListener(FlexEvent.SHOW, eventHandler); 		
				break;
			} 
		} */
	}
	
	/**
	 *  Plays the effect instance on the target after the <code>startDelay</code> period
	 *  has elapsed. Called by the Effect class. Use this function instead of
	 *  the <code>play()</code> method when starting an EffectInstance.
	 */
	public function startEffect():void
	{	
		
		if (startDelay > 0 && !playReversed)
		{
			if(delayTimer){
				delayTimer.reset()
				delayTimer.removeEventListener(TimerEvent.TIMER, delayTimerHandler);
			}
			delayTimer = new Timer(startDelay, 1);
			delayStartTime = getTimer();
			delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
			delayTimer.start();
		}
		else
		{
			play();
		}
	}
			
	
	public function play():void
	{
		playCount++;
		isPlaying=true;
		dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
		
		if (target)	{
			
			if(target is IEventDispatcher){
			 	target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
			}
			if(target is Array){
				arrayTargt=true;
			}
		}
	}
	protected var arrayTargt:Boolean=false;
	
	/**
 	 *  Pauses the effect until you call the <code>resume()</code> method.
  	 */
	public function pause():void
	{	isPlaying=false
		if (delayTimer && delayTimer.running && !isNaN(delayStartTime))
		{
			delayTimer.stop(); // Pause the timer
			delayElapsedTime = getTimer() - delayStartTime;
		}
	}
	
	
	public function resume():void
	{
		isPlaying=true
		if (delayTimer && !delayTimer.running && !isNaN(delayElapsedTime))
		{
			delayTimer.delay = !playReversed ? delayTimer.delay - delayElapsedTime : delayElapsedTime;
			delayTimer.start();
		}
	}
		
	/**
  	 *  Plays the effect in reverse, starting from the current position of the effect.
  	 */
	public function reverse():void
	{	isPlaying=true
		if (repeatCount > 0)
			playCount = repeatCount - playCount + 1;
	}
	
	
	public function end():void
	{	isPlaying=false;
		if (delayTimer)
			delayTimer.reset();
		stopRepeat = true;
		finishEffect();
	}
	
	/**
	 *  Called by the <code>end()</code> method when the effect
	 *  finishes playing.
	 *  This function dispatches an <code>endEffect</code> event
	 *  for the effect target.
	 *
	 *  <p>You do not have to override this method in a subclass.
	 *  You do not need to call this method when using effects,
	 *  but you may need to call it if you create an effect subclass.</p>
	 *
	 *  @see mx.events.EffectEvent
	 */
	public function finishEffect():void
	{
		playCount = 0;
	
		dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END,false, false, this));
		
		if (target)
		{
			if(target is IEventDispatcher)
			target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END, false, false, this));
		}
		target=null
		isPlaying=false
		//EffectManager.effectFinished(this);
	}

	/**
	 *  Called after each iteration of a repeated effect finishes playing.
	 *
	 *  <p>You do not have to override this method in a subclass.
	 *  You do not need to call this method when using effects.</p>
	 */
	public function finishRepeat():void
	{
		if (!stopRepeat && playCount != 0 && (playCount < repeatCount || repeatCount == 0))
		{
			if (repeatDelay > 0)
			{
				delayTimer = new Timer(repeatDelay, 1);
				delayStartTime = getTimer();
				delayTimer.addEventListener(TimerEvent.TIMER,delayTimerHandler);
				delayTimer.start();
			}
			else
			{
				play();
			}
		}
		else
		{
			finishEffect();
		}
	}
	
	
	private function playWithNoDuration():void
	{
		duration = 0;
		repeatCount = 1;
		repeatDelay = 0;
		startDelay = 0;
		startEffect();
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  If someone explicitly sets the visibility of the target object
	 *  to true, clear the flag that is remembering to hide the 
	 *  target when this effect ends.
	 */
	private function eventHandler(event:Event):void
	{
	/* 	if (event.type == FlexEvent.SHOW && hideOnEffectEnd == true)
		{
			hideOnEffectEnd = false;
			event.target.removeEventListener(FlexEvent.SHOW, eventHandler);
		} */
	}
	
	/**
	 *  @private 
	 */
	private function delayTimerHandler(event:TimerEvent):void
	{
		delayTimer.reset();
		delayTimer.removeEventListener(TimerEvent.TIMER,delayTimerHandler);
		delayStartTime = NaN;
		delayElapsedTime = NaN;
		play();
	}
}

}
