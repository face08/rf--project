package  com.youbt.effects.effectClass
{
	import flash.events.Event;

	public class RotateEffect extends TweenEffectInstance {
		

		public function RotateEffect(target:Object) {
			super(target);
		}

		private var centerX:Number;
		private var centerY:Number;
		private var newX:Number;
		private var newY:Number;
		private var originalOffsetX:Number;
		private var originalOffsetY:Number;

		public var angleFrom:Number = 0;
		
		public var angleTo:Number = 360;
		public var originX:Number;
		public var originY:Number;
		override public  function initEffect(event:Event):void {
			super.initEffect(event);

		}
		override public  function play():void {
			super.play();
			
			var radVal:Number = Math.PI * target.rotation / 180;		
		// Default to the center
			if (isNaN(originX))
				originX = target.width / 2;
			if (isNaN(originY))
				originY = target.height / 2;

			// Find the about point
			centerX = target.x +
					  originX * Math.cos(radVal) -
					  originY * Math.sin(radVal);
			centerY = target.y +
					  originX * Math.sin(radVal) +
					  originY * Math.cos(radVal);
			
			if (isNaN(angleFrom))
				angleFrom = target.rotation;
		
			if (isNaN(angleTo))
			{
				angleTo = (target.rotation == 0) ?
					  ((angleFrom > 180) ? 360 : 0) :
					  target.rotation;
			}
		
			tween = createTween(this, angleFrom, angleTo, duration);

			target.rotation = angleFrom;
		
			radVal = Math.PI * angleFrom/180;

			originalOffsetX = originX * Math.cos(radVal) - originY * Math.sin(radVal);
			originalOffsetY = originX * Math.sin(radVal) + originY * Math.cos(radVal);
		
			newX = Number((centerX - originalOffsetX).toFixed(1)); // use a precision of 1
			newY = Number((centerY - originalOffsetY).toFixed(1)); // use a precision of 1
		
			target.x=newX;
			target.y=newY
			//target.move(newX, newY);
							
	
			
			
		}
		override public  function onTweenUpdate(value:Object):void {
				if (newX != Number(target.x.toFixed(1)))
				{
					centerX = target.x + originalOffsetX;
				}
		
				if (newY != Number(target.y.toFixed(1)))
				{
					centerY = target.y + originalOffsetY;
				}
		
				var rotateValue:Number = Number(value);		
				var radVal:Number = Math.PI * rotateValue / 180;
		
				
				target.rotation = rotateValue;
		
				newX = centerX - originX * Math.cos(radVal) + originY * Math.sin(radVal);
				newY = centerY - originX * Math.sin(radVal) - originY * Math.cos(radVal);
		
				newX = Number(newX.toFixed(1)); // use a precision of 1
				newY = Number(newY.toFixed(1)); // use a precision of 1
				
				target.x=newX
				target.y=newY
				//target.move(newX, newY);  
			
		}
		override public  function onTweenEnd(value:Object):void {
			super.onTweenEnd(value);
		}
	}

}