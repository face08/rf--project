package com.youbt.effects.effectClass
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * 
	 * @author Ray
	 * SoundEffect
	 *
	 */	
	public class SoundEffect extends TweenEffectInstance
	{
		public function SoundEffect(target:Object)
		{
			
			super(target);
			
		}


		public var volumeEasingFunction:Function;
		 /**
    	 *  Initial volume of the Sound object.
  		 *  Value can range from 0.0 to 1.0.
  	     *
         *  @default 1   
         */
        public var volumeFrom:Number;
        public var volumeTo:Number;
		

		protected var _sf:SoundTransform=new SoundTransform;
		
		override public  function initEffect(event:Event):void {
			super.initEffect(event);
 
		}
		override public  function play():void {
			super.play();
			_sf.volume=volumeFrom
			tween = createTween(this, [ volumeFrom ], [volumeTo ],duration);
		}
		override public  function onTweenUpdate(value:Object):void {
			_sf.volume=value[0];
			if(target)
				target.soundTransform=_sf;
			
		}
		override public  function onTweenEnd(value:Object):void {
			if(target)
				(target as SoundChannel).stop()
			super.onTweenEnd(value);
		}
	}
}