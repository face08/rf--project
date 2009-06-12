package  com.youbt.effects.effectClass
{
	
	import flash.filters.ColorMatrixFilter;


	public class FadeGrayEffect extends TweenEffectInstance
	{
		public function FadeGrayEffect(target:Object)
		{
			super(target);
			
		}
		public static const IDENTITY_MATRIX : Array = [ 1, 0, 0, 0, 0,
                                                     0, 1, 0, 0, 0,
                                                     0, 0, 1, 0, 0,
                                                     0, 0, 0, 1, 0 ];

		private static const R_LUM : Number = 0.212671;
	    private static const G_LUM : Number = 0.715160;
	    private static const B_LUM : Number = 0.072169;
	    
	    public var originalFilters:Array
	    
		public var saturationFrom:Number;
		public var saturationTo:Number;
		
		override public function play():void
		{
			super.play();
			
			originalFilters = target.filters;      
  		   // var values:PropertyChanges = propertyChanges;
  		   
			if(isNaN(saturationFrom)){
				 if ( saturationTo > 0 )
            		saturationFrom = 0;
    		     else
     		        saturationFrom = 1;
			}
			if(isNaN(saturationTo)){
				  if ( saturationFrom > 0 )
      		   	    saturationTo = 0;
     			  else
		            saturationTo = 1;
			}
			 tween = createTween( this, saturationFrom, saturationTo, duration );
		}
		
		override public function onTweenUpdate(value:Object):void
		{ 
			applyColorMatrixFilter(value as Number);
		}
		
		 private function applyColorMatrixFilter( saturation : Number ):void
	    {
   		/*    var newFilters:Array = new Array();
   		   for(var i:uint=0;i<originalFilters.length;i++){
	         if ( originalFilters[ i ] is ColorMatrixFilter == false )   
    	        newFilters.push( originalFilters[ i ] );
   		   }
	      newFilters.push( buildColorMatrixFilter( saturation ) ); 
		  target.filters = newFilters; */
		  
		  var filters:Array = target.filters;
		  var n:int = filters.length;
		for (var i:int = 0; i < n; i++)
		{
			if (filters[i] is ColorMatrixFilter)
				filters.splice(i, 1);
		}
		
		
			filters.push(buildColorMatrixFilter( saturation ));
		
			target.filters = filters;
		  
		  
		  
		  
		}
  		 private function buildColorMatrixFilter( s : Number ) : ColorMatrixFilter
   		{
    		  var inverseS : Number = 1 - s;
      
	      var irlum:Number = inverseS * R_LUM;
	      var iglum:Number = inverseS * G_LUM;
	      var iblum:Number = inverseS * B_LUM;
      
    	  var mat:Array =  [ irlum + s, iglum    , iblum    , 0, 0,
        	                 irlum    , iglum + s, iblum    , 0, 0,
            	             irlum    , iglum    , iblum + s, 0, 0,
                	         0        , 0        , 0        , 1, 0 ];
     
	      var temp:Array = new Array();
    	  var i:Number = 0;

	      for ( var y : Number = 0; y < 4; y++ )
    	  {
        	 for (var x : Number = 0; x < 5; x++ )
	         {
    	        temp[ i + x ] = mat[ i ]     * IDENTITY_MATRIX[ x ] + 
        	                    mat[ i + 1 ] * IDENTITY_MATRIX[ x +  5 ] + 
            	                mat[ i + 2 ] * IDENTITY_MATRIX[ x + 10 ] + 
                	            mat[ i + 3 ] * IDENTITY_MATRIX[ x + 15 ] +
                    	        ( x == 4 ? mat[ i + 4 ] : 0 );
	         }
	         i+=5;
	      }
	      return new ColorMatrixFilter( temp );
		   }
	}
}