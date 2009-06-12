package com.youbt.utils
{
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BitmapFilterQuality;
	
	
	/**
	 * 滤镜辅助类,主要提供项目中的默认 滤镜;
	 * @author crlnet
	 * 
	 */	
	public class FilterUtil
	{
		private static var colorFilter:ColorMatrixFilter;
		public function FilterUtil()
		{
		}
		
		
		/**
		 * 取得效好的发光滤镜; 
		 * @return 
		 * 
		 */		
		public static function getWellGlowFilter(clr:Number=0x0D8361):Array{
			var color:Number =clr ;
            var alpha:Number = 0.8;
            var blurX:Number = 10;
            var blurY:Number = 10;
            var strength:Number = 2;
            var inner:Boolean =true;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return [new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout)]
		}
		
		/**
		 *  取得发光
		 * @return 
		 * 
		 */		
		public static function getGlowFilter(color:Number=0,alpha:Number=1.0,blurX:int=2,blurY:int=2,strength:Number = 5,quality:int = 1):Array{
			return  [new GlowFilter(color, alpha, blurX, blurY, strength, quality)];
		}
		
		/**
		 * 取得灰度滤镜; 
		 * @return 
		 * 
		 */		
		public static function getGrayFilter():Array{
			if(colorFilter==null){
				colorFilter= new ColorMatrixFilter();
				var _nGreen:Number = 0.6094; 
		        var _nRed:Number = 0.3086;
		       	var _nBlue:Number = 0.082;
	            colorFilter.matrix = [_nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, _nRed, _nGreen, _nBlue, 0, 0, 0, 0, 0, 1, 0];
   			}
   			
   			return [colorFilter];
		}
		
		public static function getTextFilter(textField:TextField):Array{
			return getGlowFilter(0,1,2);
		}

	}
}