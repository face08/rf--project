package com.youbt.controls
{
	import com.youbt.controls.marqueeUIClasses.MarqueeItem;
	
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import com.youbt.core.UIComponent;
	
	/**
	 * 跑马灯效果; 
	 * @author crl;
	 * @example
	 * 		var marquee:Marquee=new Marquee();
	 *		marquee.setSize(630,28);
	 *		marquee.moveTo(185,15);
	 *		var format:TextFormat=marquee.ItemFormat;
	 *		format.bold=true;
	 *		marquee.ItemFormat=format;
	 *		marquee.Label="MusicXX输出展示测试";
	 *		this.addChild(marquee);
	 * 
	 */	
	public class Marquee extends UIComponent
	{	
		private var timer:Timer;
		
		private var item:MarqueeItem;
		private var maskSprite:Sprite;
		private var speed:int=40;
		
		public function Marquee()
		{
			this.createChildren();
			this.updateTimer();
		}
		
		private function updateTimer():void{
			if(timer)
			{
				timer.delay=1000/speed;
				return;
			}
			timer=new Timer(1000/speed);
			timer.addEventListener(TimerEvent.TIMER,timerHander);
		}
		protected function createChildren():void{
			
			item=new MarqueeItem();
			maskSprite=new Sprite();
			
			var g:Graphics=maskSprite.graphics;
			g.beginFill(0);
			g.drawRect(0,0,50,50);
			
			addChild(item);
			addChild(maskSprite);
			
			this.mask=maskSprite;
		}
		
		
		private function timerHander(event:TimerEvent):void{
			this.scroll();
		}
		
		public function setSize(w:Number,h:Number):void{
			maskSprite.width=w;
			maskSprite.height=h;
		}
		
		/**
		 * 设置项值; 
		 * @param value
		 * 
		 */		
		public function set Label(value:String):void{
			item.Lable=value;
			item.x=maskSprite.width;
			timer.start();
		}
		
		/**
		 * 外部自定义字体样式; 
		 * @param value
		 * 
		 */		
		public function set ItemFormat(value:TextFormat):void{
			this.item.Field.defaultTextFormat=value;
		}
		public function get ItemFormat():TextFormat{
			return this.item.Field.defaultTextFormat;
		}
		
		/**
		 *	调整速度; 
		 * @return 
		 * 
		 */		
		public function get Speed():int{
			return this.speed;
		}
		public function set Speed(value:int):void{
			this.speed=value;
			this.updateTimer();
		}
		
		private function scroll():void{
			item.x-=1;
			if(item.x+item.width<0){
				item.x=maskSprite.width;
			}
		}
	}
}