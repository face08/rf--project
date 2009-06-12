package  com.youbt.effects.effectClass
{

import flash.events.Event;
import flash.filters.GlowFilter;

public class GlowEffect extends TweenEffectInstance
{
  
	public function GlowEffect(target:Object)
	{
		super(target);
	}

	public var alphaFrom:Number;
	
	
	public var alphaTo:Number;

	
	public var blurXFrom:Number;
	
	public var blurXTo:Number;

	
	public var blurYFrom:Number;
	

	public var blurYTo:Number;
	

	public var color:uint = 0xFFFFFFFF
	
	
	public var inner:Boolean;
	
	
	public var knockout:Boolean;
	

	public var strength:Number;
	
	
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

		// If nobody assigned a value, give some defaults
		if (isNaN(alphaFrom))
			alphaFrom = 1.0;
		if (isNaN(alphaTo))
			alphaTo = 0;
		if (isNaN(blurXFrom))
			blurXFrom = 5;
		if (isNaN(blurXTo))
			blurXTo = 0;
		if (isNaN(blurYFrom))
			blurYFrom = 5;
		if (isNaN(blurYTo))
			blurYTo = 0;
		
		if (isNaN(strength))
			strength = 2;
			
		tween = createTween(
			this, [ color, alphaFrom, blurXFrom, blurYFrom ],
			[ color, alphaTo, blurXTo, blurYTo ], duration);
		
		// target.filters = ???
	}

	/**
	 *  @private
	 */
	override public function onTweenUpdate(value:Object):void
	{
		setGlowFilter(value[0], value[1], value[2], value[3]);
	}

	/**
	 *  @private
	 */
	override public function onTweenEnd(value:Object):void
	{
		setGlowFilter(value[0], value[1], value[2], value[3]);
			
		super.onTweenEnd(value);	
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function setGlowFilter(color:uint, alpha:Number,
								   blurX:Number, blurY:Number):void
	{
		var filters:Array = target.filters;
		
		// Remove any existing Glow filters
		var n:int = filters.length;
		for (var i:int = 0; i < n; i++)
		{
			if (filters[i] is GlowFilter)
				filters.splice(i, 1);
		}
		
		if (blurX || blurY || alpha)
			filters.push(new GlowFilter(color, alpha, blurX, blurY,
						strength, 1, inner, knockout));
		
		target.filters = filters;
	}
}

}
