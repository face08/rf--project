package com.youbt.effects.effectClass
{
	import flash.events.Event;
	
	/**
	 * 用于玩家被击中的效果，同 MoveEffect 只是在结束的时候坐标会回到 xFrom 和 yFrom
	 * @author zww
	 */
	public class XYTweenEffect extends TweenEffectInstance
	{
		public function XYTweenEffect(target:Object)
		{
			super(target);
		}
		
		public var xStart:Number;
		public var xFrom:Number=0;
		public var xTo:Number=0;
		public var yStart:Number;
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
			target.x=xStart;
			target.y=yStart;
		}
		
	}
}