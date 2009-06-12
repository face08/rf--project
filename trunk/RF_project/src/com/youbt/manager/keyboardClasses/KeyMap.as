package com.youbt.manager.keyboardClasses{
	import com.youbt.utils.HashMap;
	public class KeyMap{
		
		private var map:HashMap;
		
		/**
		 * Creates a key map.
		 */
		public function KeyMap(){
			map = new HashMap();
		}
		
		/**
		 * Registers a key definition -> action pair to the map. If same key definition is already 
		 * in the map, it will be replaced with the new one.
		 * @param key the key definition.
		 * @param action the aciton function
		 */
		public function registerKeyAction(key:IKeyType, action:Function):void{
			map.put(getCodec(key), new KeyAction(key, action));
		}
		
		/**
		 * Unregisters a key and its action value.
		 * @param key the key and its value to be unrigesterd.
		 */
		public function unregisterKeyAction(key:IKeyType):void{
			map.remove(getCodec(key));
		}
		
		/**
		 * Returns the action from the key defintion.
		 * @param key the key definition
		 * @return the action.
		 * @see #getCodec()
		 */
		public function getKeyAction(key:IKeyType):Function{
			return getKeyActionWithCodec(getCodec(key));
		}
		
		private function getKeyActionWithCodec(codec:String):Function{
			var ka:KeyAction = map.get(codec);
			if(ka != null){
				return ka.action;
			}
			return null;
		}
		
		/**
		 * Fires a key action with key sequence.
		 * @return whether or not a key action fired with this key sequence.
		 */
		public function fireKeyAction(keySequence:Array):Boolean{
			var codec:String = getCodecWithKeySequence(keySequence);
			
			//trace(codec);
			
			var action:Function = getKeyActionWithCodec(codec);
			if(action != null){
				action();
				return true;
			}
			return false;
		}
		
		/**
		 * Returns whether the key definition is already registered.
		 * @param key the key definition
		 */
		public function containsKey(key:IKeyType):Boolean{
			return map.containsKey(getCodec(key));
		}
		
		/**
		 * Returns the codec of a key definition, same codec means same key definitions.
		 * @param key the key definition
		 * @return the codec of specified key definition
		 */
		public static function getCodec(key:IKeyType):String{
			return getCodecWithKeySequence(key.getCodeSequence());
		}
		
		/**
		 * Returns the codec of a key sequence.
		 * @param keySequence the key sequence
		 * @return the codec of specified key sequence
		 */
		public static function getCodecWithKeySequence(keySequence:Array):String{
			return keySequence.join("|");
		}
	}

}
	import com.youbt.manager.keyboardClasses.IKeyType;
	

class KeyAction{
	internal var key:IKeyType;
	internal var action:Function;
	
	public function KeyAction(key:IKeyType, action:Function){
		this.key = key;
		this.action = action;
	}
}