package  com.youbt.effects.effectClass
{
	
	import flash.filters.ColorMatrixFilter;


	public class BrightnessEffect extends TweenEffectInstance
	{
		public function BrightnessEffect(target:Object)
		{
			super(target);
			
		}
		public var brightnessFrom:Number;

		public var brightnessTo:Number;
		
			override public function play():void
		{
			super.play();
			if(isNaN(brightnessFrom))
				{brightnessFrom=0;}
			if(isNaN(brightnessTo))
				{brightnessTo=0;}

			
			tween= createTween(this,brightnessFrom,brightnessTo,duration);
		}
		
		override public function onTweenUpdate(value:Object):void
		{
			setBrightFilter(value as Number);
		}
		
		private function setBrightFilter(brightness:Number):void
		{
			var filters:Array = target.filters;
			var n:int = filters.length;
			for (var i:int = 0; i < n; i++)
			{
				if (filters[i] is ColorMatrixFilter)
					filters.splice(i, 1);
			}
			
				var matrix:Array = new Array();
            matrix = matrix.concat([1, 0, 0, 0, 255*brightness]); // red
            matrix = matrix.concat([0, 1, 0, 0, 255*brightness]); // green
            matrix = matrix.concat([0, 0, 1, 0, 255*brightness]); // blue
            matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
            
          
            var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
          
            filters.push(filter);
            target.filters = filters;

		}

		override public function onTweenEnd(value:Object):void
		{
			setBrightFilter(value as Number);
			super.onTweenEnd(value);
		}
	}
}