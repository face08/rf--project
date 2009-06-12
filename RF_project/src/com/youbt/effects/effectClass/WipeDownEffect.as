package  com.youbt.effects.effectClass
{
	import flash.display.Shape;
	import flash.display.DisplayObjectContainer;
	import com.youbt.events.EffectEvent;
	
	public class WipeDownEffect extends MaskEffect
	{
		
		public function WipeDownEffect(target:Object){
			super(target)

		}
		
		override public function initMask():void{
	
			maskShape=new Shape()
			maskShape.graphics.beginFill(0x000000,1)
			maskShape.graphics.drawRect(0,0,target.width,target.height)
			maskShape.y=-target.height;
			target.addChild(maskShape)
			target.mask=maskShape
			_tweenInstance=new MoveEffect(maskShape)
			_tweenInstance.yFrom=-target.height
			_tweenInstance.yTo=0
			_tweenInstance.play()
			_tweenInstance.addEventListener(EffectEvent.EFFECT_END,endhandler)
		}
		
	}
}