package com.youbt.manager
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import com.youbt.manager.IResizeable;
	import com.youbt.utils.ArrayUtil;
	
	/**
	 * 场景大小变化管理类;
	 * 
	 * 主要设置了变化的最小范围,让注册的面板在最小范围之外进行位置的调整;
	 * @author crlnet
	 * 
	 */	
	public class RFResizeMananger extends EventDispatcher implements IResizeable
	{
		private static var stage:Stage;
		private var resizeList:Array;
		
		private var initialized:Boolean=false;
		protected var _miniSize:Rectangle;
		protected var _currentSize:Rectangle;
		
		
		private static var  instance:RFResizeMananger;
		public static function getInstance():RFResizeMananger{
			if(instance==null){
				instance=new RFResizeMananger();
			}
			return instance;
		}
		
		public function RFResizeMananger()
		{
			if(instance)throw new Error("");
			resizeList=new Array();
			_currentSize=new Rectangle(800,450);
		}
		
		/**
		 * 绑定要侦听场景的resize事件; 
		 * @param stage 被侦听场景;
		 * 
		 */		
		public function bindStage(stage:Stage):void{
			
			if(stage==null)return;
			if(initialized)return;
			initialized=true;
			RFResizeMananger.stage=stage;
			stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		/**
		 * 更新当前宽度(取大值); 
		 * 
		 */		
		private function updatecurrentSize():void{
			if(stage==null)return;
			var sw:int=stage.stageWidth;
			var sh:int=stage.stageHeight;
			
			if(this.getMiniSize() !=this._currentSize){
				this._currentSize.width=Math.max(this._miniSize.width,sw);
				this._currentSize.height=Math.max(this._miniSize.height,sh);
			}
		}
		
		/**
		 * 设置一个最小区域,比这个区域小的屏幕将不进行动态调整;
		 * @param width
		 * @param height
		 * 
		 */		
		public function setMiniSize(width:int,height:int):void{
			this._miniSize=new Rectangle(0,0,width,height);
		}
		
		/**
		 * 取得最小区域;
		 * @return 
		 * 
		 */		
		public function getMiniSize():Rectangle{
			if(this._miniSize==null){
				this._miniSize=new Rectangle(0,0,800,300);
			}
			return _miniSize;
		}
		
		/**
		 * 场景被调整;
		 * @param event
		 * 
		 */		
		private function resizeHandler(event:Event):void{
			this.updatecurrentSize();
			this.resize(this._currentSize.width,this._currentSize.height);
		}
		
		
		/**
		 * 调整位置,触发调整所有注册项; ; 
		 * @param width
		 * @param height
		 * 
		 */		
		public function resize(width:int,height:int):void{
			for each(var item:IResizeable in resizeList){
				item.resize(width,height);
			}
		}
		
		/**
		 *	添加;
		 * @param item
		 * @return 
		 * 
		 */		
		public function add(item:IResizeable):int{
			
			if(ArrayUtil.has(resizeList,item))return -1;
			
			if(stage){
				item.resize(stage.stageWidth,stage.stageHeight);
			}
			return resizeList.push(item);
		}
		
		/**
		 * 删除
		 * @param item
		 * @return 
		 * 
		 */		
		public function remove(item:IResizeable):uint{
			return ArrayUtil.remove(this.resizeList,item);
		}
		
		
		
		/**
		 * 静态的居中方法;
		 * @param display
		 * 
		 */		
		public static function Center(display:DisplayObject,padX:int=0,padY:int=0):void{
			if(!stage && display.stage){
				stage=display.stage;
			}
			if(stage==null)return;
			
			display.x=int((stage.stageWidth-display.width)/2)+padX;
			display.y=int((stage.stageHeight-display.height)/2)+padY;
		}

	}
}