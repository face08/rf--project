package  com.youbt.effects.effectClass
{
	
	import com.youbt.events.EffectEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;

	public class MaskEffect extends TweenEffectInstance implements IEffectInstance
	{
		public var _tweenInstance:*
		public function MaskEffect(target:Object=null){
			super(target)
		}
		// sub class to override
		
		public var maskShape:Shape;
		public function initMask():void{
			
		}
		internal function endhandler(e:EffectEvent):void{
			_tweenInstance=null
			if(target.contains(maskShape))
			target.removeChild(maskShape)
			target.mask=null
		}
		override public function initEffect(event:Event):void
		{
		}
		
	
		
	}
}