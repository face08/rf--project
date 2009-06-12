package com.youbt.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class BitmapDataUtil
	{
		public function BitmapDataUtil()
		{
		}
			public static function writeObjectToBmd(source:BitmapData,obj:Object,rect:Rectangle=null):BitmapData
			{
				
				if(!rect){
					rect=new Rectangle(source.width,source.height)
				}
				
				var compress:int=0
				
				
				var ba:ByteArray=new ByteArray()
				ba.writeObject(obj)
				if(compress==0){
					ba.compress()	
				}
				var end:int=ba.length%3
				
				if(end!=0){
					for(var i:int=0;i<3-end;i++){
						ba.writeByte(0)
					}
				}
				
				var length:uint=ba.length
				ba.position=0;
				
				if(ba.length>0xffff){
					throw new RangeError("ba out of range");
				}
				
				var direction:int
				var vw:int=0
				var vh:int=0
				
				var max:Number=Math.max(rect.width,rect.height)-1
				if(rect.width>rect.height){
					direction=VERTICAL
					vh=ba.length/3/max+1
				}else{
					direction=HORIZONTAL
					vw=ba.length/3/max+1
				}
				
				
				
				
				
				var pix:int=Math.max(vh,vw)
				
				if(pix>63){
					throw new RangeError("pix out of range");
				}
				var header:int=(compress<<7) | (direction<<6) | pix
				
			
								
				var bmd:BitmapData=new BitmapData(rect.width+vw,rect.height+vh,true,0xffffff)
				bmd.floodFill(0,0,0xff123456)
				bmd.copyPixels(source,rect,new Point(vw,vh))
				
				
				bmd.setPixel(0,0,header<<16 | length)
				
				var total:int=ba.length/3
				var px:int=0
				var py:int=0
				for (var j:int=0;j<total;j++){
					var v0:int=ba.readUnsignedByte()
					var v1:int=ba.readUnsignedByte()
					var v2:int=ba.readUnsignedByte()
					var rs:uint=0x000000 | (v0<<16) | (v1<<8) | v2 
			//		
					
					if(direction==VERTICAL){
						px=(j+1)%rect.width
						py=(j+1)/rect.width
						
					}else{
						px=(j+1)/rect.height
						py=(j+1)%rect.height
						
					}
					bmd.setPixel(px,py,rs)
				//	bmd.setPixel32(px,py,0x11000000 | rs)
					
				//	var rs0:uint=bmd.getPixel32(px,py)&0x00ffffff
					
					//trace(rs0>>16, (rs0 & 0x00ffff)>>8,(rs0 & 0x0000ff),rs0,bmd.getPixel32(px,py))
				}
				return bmd				
			}
			private static const VERTICAL:int=0
			private static const HORIZONTAL:int=1
			
			public static function readObjectFromBmd(bmd:BitmapData):Object
			{
				var obj:Object
				
				var header:int=bmd.getPixel(0,0)>>16
				var direction:int=header>>6 & 0x1
				var pixal:int=header&0x3f
				var compress:int=header>>7
				
				//(direction,pixal,compress)
				
				
				var length:int=bmd.getPixel(0,0) &0x00ffff
				
				
				
				var total:int=int(length/3)+1
				
				trace("array length",length,direction,total)
				
				var ba:ByteArray=new ByteArray()
				var px:int=0
				var py:int=0
				for(var i:int=0;i<total;i++){
					var rs:uint
					if(direction==VERTICAL){
						px=(i+1)%bmd.width
						py=(i+1)/bmd.width
					}else{
						px=(i+1)/bmd.height
						py=(i+1)%bmd.height
						
					}
					rs=bmd.getPixel(px,py)
				
			//		rs=bmd.getPixel32(px,py)&0x00ffffff
					
			//		(rs>>16, (rs & 0x00ffff)>>8,(rs & 0x0000ff))
					ba.writeByte(rs>>16)
					ba.writeByte((rs & 0x00ffff)>>8)
					ba.writeByte((rs & 0x0000ff))
					
				}
				if(compress==0){
					ba.uncompress()
				}
				ba.position=0
				obj=ba.readObject()
				return obj
			}
			
		
		
		
	}
}