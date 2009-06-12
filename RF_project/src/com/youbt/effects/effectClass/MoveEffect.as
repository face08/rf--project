package com.youbt.effects.effectClass
{
	import flash.events.Event;

	public class MoveEffect extends TweenEffectInstance {
		

		public function MoveEffect(target:Object) {
			super(target);
		}

		public var xBy:Number;
		public var xFrom:Number=0;
		public var xTo:Number=0;
		public var yBy:Number;
		public var yFrom:Number=0;
		public var yTo:Number=0;

		override public  function initEffect(event:Event):void {
			super.initEffect(event);

		}
		override public  function play():void {
			super.play();
			// todo 
			// implement xby,yby			
			tween = createTween(this, [ xFrom, yFrom ], [ xTo, yTo ],duration);
		}
		override public  function onTweenUpdate(value:Object):void {
			if(target){
				target.x=value[0]
				target.y=value[1]
			}
		}
		override public  function onTweenEnd(value:Object):void {
			super.onTweenEnd(value);
		}
	}

}