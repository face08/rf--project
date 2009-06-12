package com.youbt.controls.marqueeUIClasses
{	
	import flash.display.*;
	import flash.text.*;
	import com.youbt.core.UIComponent;
	
	/**
	 * 滚动项，主要是个文本项; 
	 * @author crl
	 * 
	 */	
	public class MarqueeItem extends UIComponent{
	
		private var tf:TextField;
		public function MarqueeItem(){
			super();
			this.createChildren();
		}
		
		
		protected function createChildren():void{
			tf=new TextField();
			tf.textColor=0xFFFFFF;
			addChild(tf);
		}
		public function set Lable(value:String):void{
			tf.htmlText=value;
		}
		public function get Field():TextField{
			return this.tf;
		}
	}
}