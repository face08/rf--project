package  com.youbt.manager
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	 
	 
	public class RFDragManager
	{
		private static  var impl:RFDragManagerImpl=new RFDragManagerImpl()
		public static function startDrag(d:Sprite,r:Rectangle=null,t:Boolean=false,listener:Object=null,drop:IDroppable=null):void{
			impl.startDrag(d,r,t,listener,drop)
		}
		
		public static function stopDrag():void{
			impl.stopDrag()
		}
		
		public static function get isDraging():Boolean{
			return impl.isDraging
		}
	
		
	}
}