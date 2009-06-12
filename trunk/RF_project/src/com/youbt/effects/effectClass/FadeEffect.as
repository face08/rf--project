package com.youbt.effects.effectClass
{

import flash.events.Event;

public class FadeEffect extends TweenEffectInstance
{
   
	public function FadeEffect(target:Object)
	{
		super(target);
	}


	private var origAlpha:Number = NaN;

	private var restoreAlpha:Boolean;

	
	public var alphaFrom:Number;
	
	
	public var alphaTo:Number;
	
	
	override public function initEffect(event:Event):void
	{
		super.initEffect(event);
	
	}
	
	/**
	 *  @private
	 */
	override public function play():void
	{
		// Dispatch an effectStart event from the target.
		super.play();

		// Try to cache the target as a bitmap.
		//EffectManager.mx_internal::startBitmapEffect(target);

		// Remember the original value of the target object's alpha
	/* 	origAlpha = target.alpha;

		var values:PropertyChanges = propertyChanges;
		
		// If nobody assigned a value, make this a "show" effect.
		if (isNaN(alphaFrom) && isNaN(alphaTo))
		{	
			if (values && values.end["alpha"] !== undefined)
			{
				alphaFrom = origAlpha;
				alphaTo = values.end["alpha"];
			}
			else if (values && values.end["visible"] !== undefined)
			{
				alphaFrom = values.start["visible"] ? origAlpha : 0;
				alphaTo = values.end["visible"] ? origAlpha : 0;
			}
			else
			{
				alphaFrom = 0;
				alphaTo = origAlpha;
			}
		}
		else if (isNaN(alphaFrom))
		{
			alphaFrom = (alphaTo == 0) ? origAlpha : 0;
		}
		else if (isNaN(alphaTo))
		{
			if (values && values.end["alpha"] !== undefined)
			{
				alphaTo = values.end["alpha"];
			}
			else
			{
				alphaTo = (alphaFrom == 0) ? origAlpha : 0;	
			}
		}		 */
		
		tween = createTween(this, alphaFrom, alphaTo, duration);
		if(target is Array){
		
		}else if(target){
			target.alpha = tween.getCurrentValue(0)
		}
	}

	/**
	 *  @private
	 */
	override public function onTweenUpdate(value:Object):void
	{
		if(arrayTargt && target){
			for each(var obj:Object in target){
				if(obj){
					obj.alpha=value;
				}
			}	
			
		}else{
			if(target){
				target.alpha = value;
			}
		}
	}

	/**
	 *  @private
	 */
	override public function onTweenEnd(value:Object):void
	{
		// Call super function first so we don't clobber resetting the alpha.
		super.onTweenEnd(value);	
			
		/* if (mx_internal::hideOnEffectEnd || restoreAlpha)
		{
			target.alpha = origAlpha;
		} */
	}
}

}
