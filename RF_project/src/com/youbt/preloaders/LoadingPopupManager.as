package com.youbt.preloaders
{
	import com.youbt.debug.RFTraceSummary;
	import com.youbt.manager.IResizeable;
	import com.youbt.manager.RFPopupManager;
	import com.youbt.manager.RFResizeMananger;
	import com.youbt.manager.RFSystemManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * 
	 * @author whh
	 * 
	 */	
	public class LoadingPopupManager extends EventDispatcher implements IPopupModelProgress,IResizeable
	{
		private static var _instance:LoadingPopupManager
		public static function getInstance():LoadingPopupManager
		{
			return _instance ||= new LoadingPopupManager();
		}
		
		private var loading:ILoadingPopupUI;
		public function LoadingPopupManager()
		{
			
		}
		
		//////////////////////////////////////////////////////////////
		//					private									//
		//////////////////////////////////////////////////////////////
		/**
		 * 蒙板 
		 */		
		private var _m:Sprite;
		
		/**
		 * 进度条已经显示？ 
		 */		
		private var isShowing:Boolean
		
		/**
		 * loadList 下载队列储存
		 */		
		private var loadList:Dictionary = new Dictionary();
		
		/**
		 * _currentMsg 当然下载项目显示
		 */		
		private  var _currentMsg:String;
		
		/**
		 * _currentId 当前下载项目ID
		 */		
		private  var _currentId:String;
		public  function set currentId(value:String):void
		{
			if(!value) 
			{
				end();
				return;
			}
			_currentId = value;
			var queueVO:QueueVO = loadList[value]
			_currentMsg = queueVO.msg;
			RFTraceSummary(_currentMsg);
			if(!loading) return;
			
			if(queueVO.mode == 0)
			{
				loading.isAutoModel(true);
				loading.showMessage(_currentMsg);
			}else{
				loading.isAutoModel(false);
				progress(value,queueVO.loadedBytes,queueVO.totleBytes);
			}
			loading.isShowCancel(queueVO.cancelAble);
		}
		
		public  function get currentId():String
		{
			return _currentId;
		}
		
		
		/**
		 * 全部下载完毕 
		 * 
		 */		
		private function end():void
		{
			loadList = new Dictionary();
			_currentMsg = '';
			_currentId = null;
			
			if(!loading) return;
			
			loading.progress(1);
			if(isShowing)
			{
				loading.end();
				RFPopupManager.removePopUp(loading as DisplayObject);
				closeM();
				isShowing = false;
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		/**
		 * 蒙板 
		 */		
		
		public function get mc():Sprite
		{
			if(_m) return _m;
			_m = new Sprite();
			_m.graphics.beginFill(0,0.2);
			_m.graphics.drawRect(0,0,1,1);
			_m.graphics.endFill();
			_m.mouseEnabled = false;
			RFResizeMananger.getInstance().add(this);
			return _m;
		}
		
		public function set mc(value:Sprite):void
		{
			closeM();
			_m = value;
			RFResizeMananger.getInstance().add(this);
		}
		
		public function closeM():void
		{
			if(!_m) _m = mc;
			if(_m.parent)
				_m.parent.removeChild(_m);
		}
		
		
		/**
		 * 获取下一个显示对象
		 * @return 
		 * 
		 */		
		private  function getNextThread():String
		{
			for each(var queueVO:QueueVO in loadList)
			{
				if(!queueVO.isLoaded)
					return queueVO.id;
			}
			return null;
		}
		
		//////////////////////////////////////////////////////////////////
		//						public									//
		//////////////////////////////////////////////////////////////////
		
		/**
		 * 
		 * @param loading
		 * 
		 */		
		public function setLoading(loading:ILoadingPopupUI):void
		{
			if(!loading) return;
			if(this.loading) this.loading.dispather().removeEventListener("cancel",cancelHandler);
			
			this.loading = loading;
			this.loading.dispather().addEventListener("cancel",cancelHandler);
		}
		
		/**
		 *  增加一个进度显示任务
		 * @param msg  显示信息
		 * @param id     标示(与别的 loading 区别)
		 * @param mode 模式 -1,0  , -1为手动模式。0为自动模式(手动为使用者自己抛进度，自动为一直滚动)
		 * @param cancelAble 是否可以取消  
		 * 
		 */
		public function show(msg:String="Please wait...",id:String='1',mode:int=-1,cancelAble:Boolean=false):IEventDispatcher
		{
			var queueVO:QueueVO = new QueueVO();
			queueVO.msg = msg;
			queueVO.id = id;
			queueVO.cancelAble = cancelAble
			queueVO.mode = mode;
			
			loadList[id] = queueVO;
			
			currentId = id;
			
			if(!isShowing && loading)
			{
				RFPopupManager.addPopUp(mc,RFSystemManager.PopupContainer);
				RFPopupManager.addPopUp(loading as DisplayObject,RFSystemManager.PopupContainer);
				RFResizeMananger.Center(loading as DisplayObject);
				isShowing = true;
			}
			return _instance;
		}
		/**
		 * 修改 一个进度
		 * @param id 标示
		 * @param loadedBytes  载入 字节
		 * @param totalBytes     总字节
		 * 
		 */
		public function progress(id:String, loadedBytes:int, totalBytes:int, speed:Number = -1):void
		{
			var queueVO:QueueVO = loadList[id];
			if(!queueVO) return;
			queueVO.loadedBytes = loadedBytes;
			queueVO.totleBytes = totalBytes;
			if(currentId != id) return;
			
			var progress:int = Math.round(loadedBytes/totalBytes*100)
			var outPutStr:String = _currentMsg + " "+progress+"% ("+queueVO.completeThreads+"/"+queueVO.totalThreads+") ";
			
			if(speed != -1) outPutStr += (int(speed*100)/100).toString() + "K/s" 
			
			if(!loading)
			{
				RFTraceSummary(outPutStr)
				return;
			}
			loading.showMessage(outPutStr);
			loading.progress(progress+1);
		}

		/**
		 * 多线下载任务，完成其中的某个下载任务 
		 * 用于显示 (10/20) 
		 * 
		 * @param id  标示 
		 * @param completeThreads  完成的任务数
		 * @param totalThreads   总任务数
		 * 
		 */
		public function threadChange(id:String , completeThreads:int , totalThreads:int):void
		{
			var queueVO:QueueVO = loadList[id];
			if(!queueVO) return;
			queueVO.completeThreads = completeThreads;
			queueVO.totalThreads = totalThreads;
			
			var outPutStr:String = _currentMsg + "   连接中...    ("+queueVO.completeThreads+"/"+queueVO.totalThreads+")"
			
			if(!loading)
			{
				RFTraceSummary(outPutStr);
				return;
			}
			
			loading.showMessage(outPutStr);
			loading.progress(0);
		}
		
		/**
		 * 取消某个 id的显示 
		 * @param id
		 * 
		 */
		public function cancel(id:String = null):void
		{
			if(id)
			{
				loadList[id] = null;
				delete loadList[id];
				currentId = getNextThread();
				dispatchEvent(new ModelProgressCancelEvent(id));
				return;
			}
			
			for each(var queueVO:QueueVO in loadList)
			{
				if(!queueVO.isLoaded)
					dispatchEvent(new ModelProgressCancelEvent(queueVO.id));
			}
			end();
		}
		
		/**
		 * 完成 某个 id
		 * @param id
		 * 
		 */
		public function hide(id:String):void
		{
			var queueVO:QueueVO = loadList[id];
			if(!queueVO) return;
			queueVO.isLoaded = true;
			if(currentId != id) return;
			
			currentId = getNextThread();
		}
		
		
		public function resize(width:int,height:int):void
		{
			_m.width = width;
			_m.height = height;
			RFResizeMananger.Center(loading as DisplayObject);
		}
		
		public function get taskCount():int{
			var i:int
			for each(var o:QueueVO in loadList){
				if(!o.isLoaded) i++
			}
			return i;
		}
		
		//////////////////////////////////////////////////////////
		//				event									//
		//////////////////////////////////////////////////////////
		private function cancelHandler(event:Event):void
		{
			cancel(currentId);
		}
	}
}class QueueVO{
	public var msg:String;
	public var id:String;
	public var loadedBytes:int = 0;
	public var totleBytes:int = 1;
	public var completeThreads:int = 1;
	public var totalThreads:int = 1;
	public var isLoaded:Boolean = false;
	public var cancelAble:Boolean;
	public var mode:int;
}