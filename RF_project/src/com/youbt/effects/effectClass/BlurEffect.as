package  com.youbt.effects.effectClass
{

import flash.events.Event;
import flash.filters.BlurFilter;

public class BlurEffect extends TweenEffectInstance
{
   
	public function BlurEffect(target:Object)
	{
		super(target);
	}

	
	public var blurXFrom:Number;
	public var blurXTo:Number;
	public var blurYFrom:Number;
	public var blurYTo:Number;
	


	override public function initEffect(event:Event):void
	{
		super.initEffect(event);
	}
	
	
	override public function play():void
	{
		super.play();

		if (isNaN(blurXFrom))
			blurXFrom = 4;
		if (isNaN(blurXTo))
			blurXTo = 0;
		if (isNaN(blurYFrom))
			blurYFrom = 4;
		if (isNaN(blurYTo))
			blurYTo = 0;

		tween = createTween(this, [ blurXFrom, blurYFrom ],
								  [ blurXTo, blurYTo ], duration);
		
		// target.filters = ???
	}


	override public function onTweenUpdate(value:Object):void
	{
		setBlurFilter(value[0], value[1]);
	}

	
	override public function onTweenEnd(value:Object):void
	{
		setBlurFilter(value[0], value[1]);
			
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
	private function setBlurFilter(blurX:Number, blurY:Number):void
	{
		var filters:Array = target.filters;
		
		// Remove any existing Blur filters
		var n:int = filters.length;
		for (var i:int = 0; i < n; i++)
		{
			if (filters[i] is BlurFilter)
				filters.splice(i, 1);
		}
		
		if (blurX || blurY)
			filters.push(new BlurFilter(blurX, blurY));
		
		target.filters = filters;
		
		
		
	}
}

}
