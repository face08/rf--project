package com.youbt.effects.effectClass
{

	
	import flash.filters.ColorMatrixFilter;

	public class AdvancedEffect extends TweenEffectInstance
	{

		
		public function AdvancedEffect(target:Object)
		{

			super(target);
		}
		public var alphaFrom:Number;
		
		public var redFrom:Number;
		
		public var greenFrom:Number;
		
		public var blueFrom:Number;
		
		public var alphaTo:Number;
		
		public var redTo:Number;
		
		public var greenTo:Number;
		
		public var blueTo:Number;
		
		public var alphaPercentFrom:Number;
		public var redPercentFrom:Number;
		public var greenPercentFrom:Number;
		public var bluePercentFrom:Number;
		public var alphaPercentTo:Number;
		public var redPercentTo:Number;
		public var greenPercentTo:Number;
		public var bluePercentTo:Number;
		

		override public function play():void
		{
			super.play();
			if(isNaN(alphaFrom))
				{alphaFrom=0;}
			if(isNaN(alphaTo))
				{alphaTo=0;}
			if(isNaN(alphaPercentFrom))
				{alphaPercentFrom=1;}
			if(isNaN(alphaPercentTo))
				{alphaPercentTo=1;}
				
			if(isNaN(redFrom))
				{redFrom=0;}
			if(isNaN(redTo))
				{redTo=0;}
			if(isNaN(redPercentFrom))
				{redPercentFrom=1;}
			if(isNaN(redPercentTo))
				{redPercentTo=1;}

			if(isNaN(greenFrom))
				{greenFrom=0;}
			if(isNaN(greenTo))
				{greenTo=0;}
			if(isNaN(greenPercentFrom))
				{greenPercentFrom=1;}
			if(isNaN(greenPercentTo))
				{greenPercentTo=1;}

			if(isNaN(blueFrom))
				{blueFrom=0;}
			if(isNaN(blueTo))
				{blueTo=0;}
			if(isNaN(bluePercentFrom))
				{bluePercentFrom=1;}
			if(isNaN(bluePercentTo))
				{bluePercentTo=1;}
			
			var pFrom:Object=[alphaFrom,redFrom,greenFrom,blueFrom,alphaPercentFrom,redPercentFrom,greenPercentFrom,bluePercentFrom];
			var pTo:Object=[alphaTo,redTo,greenTo,blueTo,alphaPercentTo,redPercentTo,greenPercentTo,bluePercentTo];
			tween= createTween(this,pFrom,pTo,duration);
		}
		
		override public function onTweenUpdate(value:Object):void
		{
			setAdvancedFilter(value[0],value[1],value[2],value[3],value[4],value[5],value[6],value[7]);
		}
		
		private function setAdvancedFilter(alpha:Number,red:Number,green:Number,blue:Number,alphaPercent:Number=1,redPercent:Number=1,greenPercent:Number=1,bluePercent:Number=1):void
		{
			var filters:Array = target.filters;
			var n:int = filters.length;
			for (var i:int = 0; i < n; i++)
			{
				if (filters[i] is ColorMatrixFilter)
					filters.splice(i, 1);
			}
			
				var matrix:Array = new Array();
            matrix = matrix.concat([redPercent, 0, 0, 0, red]); // red
            matrix = matrix.concat([0, greenPercent, 0, 0, green]); // green
            matrix = matrix.concat([0, 0, bluePercent, 0, blue]); // blue
            matrix = matrix.concat([0, 0, 0, alphaPercent, alpha]); // alpha
            
          
            var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
          
            filters.push(filter);
            target.filters = filters;

		}

	
	}
}