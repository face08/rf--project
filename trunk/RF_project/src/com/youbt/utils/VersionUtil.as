package com.youbt.utils
{
	import com.youbt.manager.RFSystemManager;
	
	import flash.display.MovieClip;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class VersionUtil
	{
		public static function setRightMenu(version:String):void
		{
			var o :MovieClip = RFSystemManager.getInstance();
			o.contextMenu = o.contextMenu||new ContextMenu();
			o.contextMenu.hideBuiltInItems();
			o.contextMenu.customItems.push(new ContextMenuItem(version,false,false));
		}
	}
}