package com.youbt.controls
{
	import com.youbt.debug.RFTraceError;
	import com.youbt.manager.RFSystemManager;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import com.youbt.manager.RFKeyboardManager;
	import flash.events.MouseEvent;
	import com.youbt.manager.RFFocusManager;
	import com.youbt.manager.keyboardClasses.KeyStroke;
	import flash.display.Sprite;
	import com.youbt.manager.keyboardClasses.KeySequence;
	
	public class FormPanel extends AbstractPanel
	{
		private var keyManager:RFKeyboardManager;
		public function FormPanel()
		{
			super();
			
			keyManager = new RFKeyboardManager();
			keyManager.init(this);
			keyManager.registerKeyAction(KeyStroke.VK_ENTER,enterFunction);
			keyManager.registerKeyAction(new KeySequence(KeyStroke.VK_CHN_IME,KeyStroke.VK_ENTER),enterFunction);
		}
		
		protected function enterFunction():void{
			
		}
		
		override public function set skin(_skin:Sprite):void{
			super.skin=_skin;
		}
		
		override public function bringTop():void{
			super.bringTop();
			this.setFocus();
		}

	}
}