package com.youbt.events
{

	import flash.events.Event;


	public class EffectEvent extends Event {

		public static const EFFECT_END:String = "effectEnd";
		public static const EFFECT_START:String = "effectStart";


		public function EffectEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,value:Object=null) {
			super(type,bubbles,cancelable);

			this.value=value;
		}
		/**
		 *  
		  *  BlurInstance
		  *  DissolveInstance
		  *  FadeInstance
		  *  GlowInstance
		  *  MoveInstance
		  
		 */
		public var value:Object;

		override public  function clone():Event {
			return new EffectEvent(type,bubbles,cancelable,value);
		}
	}

}