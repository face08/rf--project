package com.youbt.containers
{
	import com.youbt.core.IUIComponent;
	import com.youbt.core.UIComponent;
	import com.youbt.debug.RFTraceError;
	import com.youbt.events.StateContainerEvent;
	import com.youbt.events.UIComponentEvent;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	
	
	/**
	 * 状态容器
	 * @author eas
	 * 
	 */
	public class StateContainer extends Container
	{
		  
		//--------------------------------------------------------------------------
	    //
	    //  Class properties
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * 设定存贮 State 对象的 Dictionary; 
		 */		
		private var _states:Dictionary = new Dictionary();
		
		/**
		 * 当前state 
		 */		
		private var _currentState:String='';
		
		/**
		 * 设定当前state 
		 * @param value
		 * 
		 */
		private var _targetState:String;	
		
		//--------------------------------------------------------------------------
	    //
	    //  Constractor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Constractor
		 */
		public function StateContainer()
		{
		}
		
		
		//--------------------------------------------------------------------------
	    //
	    //  Methods
	    //
	    //--------------------------------------------------------------------------
		
		override public function sleep():void
		{
			if(_currentState=='')
			{
				super.sleep();
				return;
			}
			
			var currentState:UIComponent = _states[_currentState] as UIComponent;
			currentState.sleep();
			_currentState = '';
			super.sleep();
		}	

		/**
		 * 设定当前state  
		 * @param value
		 * 
		 */
		public function set CurrentState(value:String):void
		{
			if((value == _currentState)||(!(value in _states)))
			{
				return ;
			}
			var state:UIComponent = _states[value];
			if(!state.initialized)
			{
				_targetState =value;
				
				state.addEventListener(UIComponentEvent.INITIALIZED,onSwtichToStateReadyResponse);
				state.initialize()
				return;
			}

    		if(_currentState)
    		{
				var lastState:IUIComponent=super.removeChild(_states[_currentState]) as IUIComponent;
				(lastState as UIComponent).sleep();
    		}
			_currentState  = value;
			
			var currentState:IUIComponent=super.addChild(_states[_currentState])as IUIComponent;
			
			var event:StateContainerEvent = new StateContainerEvent(StateContainerEvent.SWITCHED_TO_STATE,_currentState)
			currentState.dispatchEvent(event);
			(currentState as UIComponent).start();
		}
		
		public function get CurrentState():String
		{
			return _currentState;
		}
		
		/**
		 * 初始化 state containers 
		 * @param args IUIComponent
		 * 
		 */
		public function Initialize(...args):void
		{
			
			if(args is Array)
			{
				for each(var argItem:Object in args)
				{
					if(argItem is IUIComponent)
						RegisteState(argItem as IUIComponent);
				}
			}
		}
		
		/**
		 * 注冊 狀態視圖  
		 * @param state
		 * @return 
		 * 
		 */
		private  function RegisteState(state:IUIComponent):IUIComponent
		{
			var stateName:String=(state as DisplayObject).name 
			if(stateName in _states)
				return null;
			_states[stateName] = state;
			
			state.addEventListener(StateContainerEvent.SWITCH_TO_STATE,onSwitchStateRequest);
			
			if(!_currentState)
			{
				CurrentState=stateName;
			}
			return state;
		}
		
			
		//--------------------------------------------------------------------------
	    //
	    //  Overrided Methods
	    //
	    //--------------------------------------------------------------------------
		
				
		/**
		 * StateContainer 不支持 直接 addChild 
		 * @param child
		 * @return 
		 * 
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			RFTraceError('state container could not addChild()');
			return null;
		}
		
		/**
		 *   StateContainer 不支持 直接 removeChild 
		 * @param child
		 * @return 
		 * 
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			RFTraceError('state container could not removeChild()');
			return null;
		}
		
		/**
		 *  StateContainer 不支持 直接 removeChildAt 
		 * @param index
		 * @return 
		 * 
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			RFTraceError('state container could not removeChildAt()');
			return null
		}
		
		
	
		
		//--------------------------------------
		//  event handlers
		//--------------------------------------
		
		/**
		 * 請求切換到 某個 狀態視圖
		 * 由 state發出  
		 * @param event
		 * 
		 */
		private function onSwitchStateRequest(event:StateContainerEvent):void
		{
			if((event.currentTarget != _states[_currentState])||(!(event.StateName in _states)))
				return;
			CurrentState=event.StateName;
		}
		
		
		/**
		 * 某個狀態視圖 已經準備好被切換到 
		 * 即 該狀態視圖 已經初始化好  
		 * @param event
		 * 
		 */
		private function onSwtichToStateReadyResponse(event:UIComponentEvent):void
		{
			var state:IUIComponent  = event.currentTarget as IUIComponent;
			state.removeEventListener(UIComponentEvent.INITIALIZED,onSwtichToStateReadyResponse);
			
			if(!_targetState)
				return;
			
			if((state as DisplayObject).name ==_targetState)
				CurrentState=(state as DisplayObject).name;
		}
		
	}
}