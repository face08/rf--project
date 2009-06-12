package com.youbt.core
{
	import com.youbt.utils.NameUtil;
	
	import flash.display.Sprite;

	public class RFSprite extends Sprite
	{
		public function RFSprite()
		{
			super();
			
			try
			{
				name = NameUtil.createUniqueName(this);
			}
			catch(e:Error)
			{
			// The name assignment above can cause the RTE
			//   Error #2078: The name property of a Timeline-placed
			//   object cannot be modified.
			// if this class has been associated with an asset
			// that was created in the Flash authoring tool.
			// The only known case where this is a problem is when
			// an asset has another asset PlaceObject'd onto it and
			// both are embedded separately into a Flex application.
			// In this case, we ignore the error and toString() will
			// use the name assigned in the Flash authoring tool.
			}
			
		}
	    override public function toString():String
		{
			return NameUtil.displayObjectToString(this);
		}
	}
}