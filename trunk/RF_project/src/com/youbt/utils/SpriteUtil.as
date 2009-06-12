package com.youbt.utils
{
	import flash.display.*;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author crlnet
	 * 
	 */	
	public class SpriteUtil
	{
		public function SpriteUtil()
		{
		}
		
		/**
		 * 取得一个可视对像,如为影片,先让它停在第一帧; 
		 * @param parent
		 * @param name
		 * @return 
		 * 
		 */		
		static public function getChildByName(parent:DisplayObjectContainer,name:String):DisplayObject{
			var display:DisplayObject=parent.getChildByName(name);
			if(display is MovieClip){
				var mc:MovieClip=display as MovieClip;
				if(mc.totalFrames>1){
					mc.gotoAndStop(1);
				}
			}
			return display;
		}
		
		/**
		 * 清空子级; 
		 * @param container
		 * 
		 */		
		static public function clearChildren(container:DisplayObjectContainer):void{
			while(container.numChildren){
				container.removeChildAt(0);
			}
		}
		
		
		
		static public function transLocalToLocal(display1:DisplayObject, display2:DisplayObject, point:Point) : Point
        {
            var p:Point = transToGlobal(display1, point);
            p = display2.globalToLocal(p);
            return p;
        }
        
        
         static public function transToGlobal(display:DisplayObject, p:Point = null) : Point
        {
            if (p == null)
            {
                p = new Point(0, 0);
            }
            p = display.localToGlobal(p);
            return p;
        }

	}
}