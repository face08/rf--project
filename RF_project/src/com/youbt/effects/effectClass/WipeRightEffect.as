package com.youbt.effects.effectClass
{
	import com.youbt.events.EffectEvent;
	import flash.display.Shape;
	public class WipeRightEffect extends MaskEffect
	{
		public function WipeRightEffect(target:Object)
		{
			super(target);
		}
		private var p:Shape;
		override public function initMask():void{
			//target.visible=false
			maskShape=new Shape()
			maskShape.graphics.beginFill(0x000000,1)
			maskShape.graphics.drawRect(0,0,target.width,target.height)
			maskShape.x=-target.width
			target.addChild(maskShape)
			target.mask=maskShape
			//target.visible=true
			 _tweenInstance=new MoveEffect(maskShape)
			_tweenInstance.xFrom=-target.width
			_tweenInstance.xTo=0
			_tweenInstance.play()
			_tweenInstance.addEventListener(EffectEvent.EFFECT_END,endhandler) 
			
		}

	}
}