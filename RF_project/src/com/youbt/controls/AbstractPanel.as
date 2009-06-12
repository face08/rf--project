package com.youbt.controls
{
	import com.youbt.core.RFSprite;
	import com.youbt.effects.effectClass.EffectInstance;
	import com.youbt.effects.effectClass.FadeEffect;
	import com.youbt.events.PanelEvent;
	import com.youbt.events.TweenEvent;
	import com.youbt.manager.IResizeable;
	import com.youbt.manager.RFDragManager;
	import com.youbt.manager.RFFocusManager;
	import com.youbt.manager.RFResizeMananger;
	import com.youbt.manager.RFSystemManager;
	import com.youbt.utils.SpriteUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	[Event (name="panel_show" , type="com.youbt.events.PanelEvent")]
	[Event (name="panel_hide" , type="com.youbt.events.PanelEvent")]
	[Event (name="panel_close" , type="com.youbt.events.PanelEvent")]
	
	/**
	 *  面板抽像基类;
	 *  用于已定位的MC皮肤的类定义;
	 * @author crlnet
	 * 
	 */	
	public class AbstractPanel extends RFSprite implements IResizeable
	{
		private var _dragable:Boolean=true;
		private var _closeable:Boolean=true;
		
		protected var _isShow:Boolean=true;
		protected var isModal:Boolean=false;
		
		protected var _skin:Sprite;
		protected var background:Sprite;
		
		private var _data:Object;
		public function AbstractPanel()
		{
		}
		
		/**
		 *	设置皮肤; 
		 * @param _skin
		 * 
		 */		
		public function set skin(_skin:Sprite):void{
			if(this._skin){
				//是否已存在;
			}
			this._skin=_skin;
			bindComponent();
			buildCanvas();
			
			if(_skin !=null && _skin !=this){
				this.addChild(skin);
			}
		}
		
		/**
		 * 取得皮肤显示对像; 
		 * @return 
		 * 
		 */		
		public function get skin():Sprite{
			return this._skin;
		}
		
		/**
		 * 显示
		 * @param target 父级;
		 * @param isModal 模窗口;
		 * 
		 */			
		public function show(target:DisplayObjectContainer=null,isModal:Boolean=false):void{
			if(target==null){
				target=RFSystemManager.PopupContainer;
			}
			target.addChild(this);
			this.bringTop();
			
			if(this.isShow==false){
				this._isShow=true;
				this.reset();
				this.transitionsMotion(skin,isShow);
			}
			if(this.isModal !=isModal){
				this.showModel(isModal);
			}
			
			this.dispatchEvent(new PanelEvent(PanelEvent.SHOW));
		}
		
		/**
		 * 隐藏; 
		 * @param event
		 * 
		 */		
		public function hide(event:Event=null):void{
			if(!isShow)return;
			this._isShow=false;
			this.transitionsMotion(skin,isShow);
			
			if(this.isModal){
				this.isModal=false;
				this.background.visible=false;
				RFResizeMananger.getInstance().remove(this);
			}
			this.dispatchEvent(new PanelEvent(PanelEvent.HIDE));
			if(event!==null){
				this.dispatchEvent(new PanelEvent(PanelEvent.CLOSE));
			}
		}
		
		
		/**
		 *	模式窗口处理方式; 
		 * @param isModal
		 * 
		 */		
		private function showModel(isModal:Boolean):void{		
			this.isModal=isModal;
			
			this.getBackgorund().visible=isModal;
			if(isModal==true){
				RFResizeMananger.getInstance().add(this);
				if(this.getChildIndex(this.background)!=0){
					this.setChildIndex(this.background,0);
				}
			}
			
		}
		
		/**
		 * 取得背影,(主要用于模式窗口); 
		 * @return 
		 * 
		 */		
		protected function getBackgorund():Sprite{
			if(this.background==null){
				this.background=new Sprite;
				this.addChildAt(this.background,0);
				var g:Graphics=this.background.graphics;
				g.clear();
				g.beginFill(0,.5);
				g.drawRect(0,0,50,50);
				g.endFill();
				
			}
			return this.background;
		}
		
		
		
		/**
		 * 重新设置窗体内容,在窗体调用show时,将调用;
		 * 
		 */		
		public function reset():void{
			
		}
		
		/**
		 *  当前显示隐藏的切换方法;
		 * @param event
		 * 
		 	
		public function toggle(event:Event=null):void{
        	if(this.isShow){
        		this.hide();
        	}else{
        		this.show(this.parent);
        	}
        }
        * */	
        
        /**
         * 取得当前是否在显示状态; 
         * @return 
         * 
         */        
        public function get isShow():Boolean{
        	return this._isShow;
        }
        
        /**
         * 设置当前显示状态; 
         * @param value
         * 
                
        public function set isShow(value:Boolean):void{
        	//todo;
        	this._isShow=value;
        }*/ 
		
		/**
		 *绑定相应该的影片; 
		 * 
		 */		
		protected function bindComponent():void{

		}
		
		/**
		 * 绘制或创建额外的辅助对像; 
		 * 
		 */		
		protected function buildCanvas():void{
			
		}
		
		/**
		 * 绑定按钮事件; 
		 * @param interactiveObject 交互对像;
		 * @param callBack 触发回调的函数;
		 * 
		 */		
		protected function bindButtonEvent(interactiveObject:InteractiveObject,callBack:Function=null):void{
			if(callBack==null){
				callBack=clickHandler;
			}
			interactiveObject.addEventListener(MouseEvent.CLICK,callBack,false,0,true);
		}
		
		/**
		 * 默认bindButtonEvent的按钮回调触发事件, 
		 * @param event
		 * 
		 */		
		protected function clickHandler(event:MouseEvent):void{
			throw new Error("AbstarctPanel 子类未重写 clickHandler 方法");
		}
		
		/**
		 *	 部署; 
		 * 
		 */		
		public function deploy():void{
			this.dispatchEvent(new Event("deloy"));
		}
		
		/**
		 * 销毁对像; 
		 * 
		 */		
		public function destroy():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
			this.dispatchEvent(new Event("destory"));
		}
		
		/**
		 * 清理对像; 
		 * 
		 */		
		public function clean():void{
			
		}
		
		/**
		 * 移动坐标; 
		 * @param x
		 * @param y
		 * @param isSkin
		 * 
		 */			
		public function move(x:Number,y:Number,isSkin:Boolean=false):void{
			var temp:DisplayObject=this;
			if(isSkin){
				temp=this.skin;
			}
			
			if(temp.x!=x){
				temp.x=x;
			}
			if(temp.y!=y){
				temp.y=y;
			}
		}
		
		/**
		 * 取得皮肤下的影片; 
		 * @param name 要取得的名称;
		 * @return 
		 * 
		 */		
		public function getSkinChildByName(name:String):DisplayObject{
			return SpriteUtil.getChildByName(this.skin,name);
		}
		
		/**
		 * 取得默认可拖动影片; 
		 * @return 
		 * 
		 */		
		protected function getDefaultDragArea():InteractiveObject{
			var dragArea:InteractiveObject=getSkinChildByName(getDefaultDragAreaName()) as InteractiveObject;
			if(dragArea==null)return null;
			dragArea.alpha=0;
			return dragArea;
		}
		
		/**
		 * 返回一个可被拖动的子集名称; 
		 * @return 
		 * 
		 */		
		protected function getDefaultDragAreaName():String{
			return "dragArea";
		}
		
		/**
		 * 绑定可拖动对像; 
		 * @param e
		 * @param flag
		 * 
		 */		
		protected function addDrag(e:InteractiveObject,flag:Boolean=true):void {
			if (flag) {
				e.addEventListener(MouseEvent.MOUSE_DOWN,onDrag,false,0,true);
				e.addEventListener(MouseEvent.MOUSE_UP,onDrag,false,0,true);
			} else {
				e.removeEventListener(MouseEvent.MOUSE_DOWN,onDrag);
				e.removeEventListener(MouseEvent.MOUSE_UP,onDrag);
			}
		}
		
		/**
		 * 拖动过程; 
		 * @param e
		 * 
		 */		
		private function onDrag(e:MouseEvent):void {
			if(this.dragable==false)return;
			if (e.type == MouseEvent.MOUSE_DOWN) {
				this.bringTop();
				RFDragManager.startDrag(this.getDraggerTarget(),new Rectangle());
				//_skin.startDrag();
			} else {
				RFDragManager.stopDrag();
				//_skin.stopDrag();
			}
		}
		
		/**
		 * 取得 被拖动 的默认对像; 
		 * @return 
		 * 
		 */		
		protected function getDraggerTarget():Sprite{
			if(this.isModal){
				return this.skin;
			}
			return this;
		}
		
		
		
		public var effect:EffectInstance;
		/**
		 * 过渡效果; 
		 * 
		 */		
		protected function transitionsMotion(skin:Sprite,isShowing:Boolean):void
		{
			var tem:FadeEffect;
			if(effect==null)
			{
				var tweenEndHandler:Function=function():void
				{
					if(isShow)
						return;
					destroy();
					dispatchEvent(new PanelEvent(PanelEvent.MOTION_FINISHED));
				};
				effect=new FadeEffect(skin);
				effect.addEventListener(TweenEvent.TWEEN_END,tweenEndHandler);
				
				effect.duration=200;
			}
			tem=effect as FadeEffect;
			tem.end();
			tem.target=skin;
			
			
			if(isShowing){
				tem.alphaFrom=0;
				tem.alphaTo=1;
			}else{
				tem.alphaFrom=1;
				tem.alphaTo=0;
			}
			
			tem.play();
		}
		
		/**
		 * 
		 *  设置为当前焦点;
		 */		
		protected function setFocus():void{
			if(RFFocusManager.getInstance().getFocus()==this)return;
			RFFocusManager.getInstance().setFocus(this);
		}
		/**
		 * 把当前面板调到顶层; 
		 * 
		 */		
		public function bringTop():void{
			var parent:DisplayObjectContainer=this.parent;
			if(parent==null)return;
			var index:int=parent.numChildren-1;
			parent.setChildIndex(this,index);
		}
		
		
		public function set dragable(bool:Boolean):void{
			this._dragable=bool;
		}
		
		public function get dragable():Boolean{
			return this._dragable;
		}
		
		public function set closeable(bool:Boolean):void{
			this._closeable=bool;
		}
		public function get closeable():Boolean{
			return this._closeable;
		}
		
		/**
		 * 场景大小变化时; 
		 * @param width
		 * @param height
		 * 
		 */		
		public function resize(width:int,height:int):void{
			if(this.isModal){
				this.background.width=width;
				this.background.height=height;
				
				RFResizeMananger.Center(this.skin);
			}
		}
		
		public function set data(value:Object):void{
			this._data=value;
		}
		public function get data():Object{
			return this._data;
		}
	
		
	}
}