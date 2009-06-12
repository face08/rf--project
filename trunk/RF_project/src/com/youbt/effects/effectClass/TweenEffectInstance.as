package  com.youbt.effects.effectClass
{
	
	import com.youbt.effects.Tween;
	import com.youbt.events.TweenEvent;
	
	
	[Event(name="tweenEnd", type="com.youbt.events.TweenEvent")]
	[Event(name="tweenStart", type="com.youbt.events.TweenEvent")]
	[Event(name="tweenUpdate", type="com.youbt.events.TweenEvent")]
	[Event(name="tweenStop", type="com.youbt.events.TweenEvent")]

public class TweenEffectInstance extends EffectInstance
{


	
	public function TweenEffectInstance(target:Object)
	{
		super(target);

	}
	
 	
	private var _seekTime:Number = 0;
	
 
	public var easingFunction:Function;
	
	/* override mx_internal function set playReversed(value:Boolean):void
	{
		super.playReversed = value;
	
		if (tween)
			tween.playReversed = value;			
	} */
	
  
	override public function get playheadTime():Number
	{
		if (tween)
			return tween.playheadTime + super.playheadTime;
		else
			return 0;
	}
	
  	public var tween:Tween;
	
	
	override public function pause():void
	{
		super.pause();
		
		if (tween)
			tween.pause();
	}
	
	/**
	 *  @private
	 */
	override public function resume():void
	{
		super.resume();
	
		if (tween)
			tween.resume();
	}
		

	override public function reverse():void
	{
		super.reverse();
	
		if (tween)
			tween.reverse();
		
		super.playReversed = !playReversed;	
	}
	
	/**
  	 *  Advances the effect to the specified position. 
  	 *
  	 *  @param playheadTime The position, in milliseconds, between 0
	 *  and the value of the <code>duration</code> property.
  	 */
	public function seek(playheadTime:Number):void
	{
		if (tween)
			tween.seek(playheadTime);
		else
			_seekTime = playheadTime;
	} 
	
	override public function end():void
	{

		stopRepeat = true;
		if (delayTimer)
			delayTimer.reset();
		// Jump to the end of the animation.
		if (tween)
		{
			tween.endTween()
		}
		
		dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false,0))
		// Don't call super.endEffect because ending the tween
		// will eventually call finishEffect() for us.	
		//super.end(); 
	}
		
	public function stop():void
	{
		stopRepeat = true;
		if (delayTimer)
			delayTimer.reset();
		
		if(tween){
			
			tween.removeEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_END, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_END, tweenEndHandler);
			tween.stopTween()
			tween = null;
		}
		dispatchEvent(new TweenEvent(TweenEvent.TWEEN_STOP,false,false,0)) 
	}
	
	
	protected function createTween(listener:Object,
						  		     startValue:Object,
								     endValue:Object,
						  		     duration:Number = -1,
								     minFps:Number = -1):Tween
	{
		var newTween:Tween =new Tween(listener, startValue, endValue, duration, minFps);
		newTween.addEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
		newTween.addEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
		newTween.addEventListener(TweenEvent.TWEEN_END, tweenEventHandler);
		newTween.addEventListener(TweenEvent.TWEEN_END, tweenEndHandler,false,1)
		
		// If the caller supplied their own easing equation, override the
		// one that's baked into Tween.
		if (easingFunction != null)
			newTween.easingFunction = easingFunction;
		
		if (_seekTime > 0)
			newTween.seek(_seekTime);

		newTween.playReversed = playReversed;
	
		return newTween;
	}
	
	private function applyTweenStartValues():void
	{
		if (duration > 0)
		{
			onTweenUpdate(tween.getCurrentValue(0));
		}
	}
	
	private function tweenEventHandler(event:TweenEvent):void
	{
		dispatchEvent(event);
	}
	private function tweenEndHandler(event:TweenEvent):void
	{
		dispatchEvent(event);
		if(tween){
			tween.removeEventListener(TweenEvent.TWEEN_END, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_END, tweenEndHandler);
			tween = null;
		}
		finishRepeat();
	}

	public function onTweenUpdate(value:Object):void
	{
		// Subclasses will override this function.
	}

	
	public function onTweenEnd(value:Object):void 
	{
				
		onTweenUpdate(value);
		if(tween){
			tween.removeEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
			tween.removeEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
		}
		
	}
	

}

}
