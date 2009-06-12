package com.youbt.manager
{
	import com.youbt.manager.RFSystemManager;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	public class RFCursorManager
    {
        static private var cursorHolder:DisplayObjectContainer = null;
        static private var currentCursor:DisplayObject = null;
        static private var root:DisplayObjectContainer = null;
        static private var tiggerCursorMap:Dictionary;

        public function RFCursorManager()
        {
            return;
        }

        static public function showCustomCursor(value:DisplayObject, bool:Boolean = true) : void
        {
            if (bool)
            {
                Mouse.hide();
            }
            else
            {
                Mouse.show();
            }
            if (value == currentCursor)
            {
                return;
            }
            var root:DisplayObjectContainer= getCursorContainerRoot();
            if (cursorHolder == null)
            {
                if (root != null)
                {
                    cursorHolder = new Sprite();
                    cursorHolder.mouseEnabled = false;
                    cursorHolder.tabEnabled = false;
                    cursorHolder.mouseChildren = false;
                    root.addChild(cursorHolder);
                }
            }
            if (cursorHolder != null)
            {
                if (currentCursor != value)
                {
                    if (currentCursor != null)
                    {
                        cursorHolder.removeChild(currentCursor);
                    }
                    currentCursor = value;
                    cursorHolder.addChild(currentCursor);
                }
               // DepthManager.bringToTop(cursorHolder);
                root.stage.addEventListener(MouseEvent.MOUSE_MOVE, __mouseMove, false, 0, true);
                __mouseMove(null);
            }
        }

        static public function hideCustomCursor(value:DisplayObject) : void
        {
            if (value != currentCursor)
            {
                return;
            }
            if (cursorHolder != null)
            {
                if (currentCursor != null)
                {
                    cursorHolder.removeChild(currentCursor);
                }
            }
            currentCursor = null;
            Mouse.show();
            var root:DisplayObjectContainer = getCursorContainerRoot();
            if (root != null)
            {
                root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __mouseMove);
            }
        }

        static public function setCursorContainerRoot(value:DisplayObjectContainer) : void
        {
            if (value != root)
            {
                root = value;
                if (cursorHolder != null && cursorHolder.parent != root)
                {
                    root.addChild(cursorHolder);
                }
            }
            return;
        }

        

        static private function getCursorContainerRoot() : DisplayObjectContainer
        {
            if (root == null)
            {
            	RFSystemManager.CursorContainer.mouseEnabled=false;
                return RFSystemManager.CursorContainer;
            }
            return root;
        }

        static public function setCursor(value:InteractiveObject, cursor:DisplayObject) : void
        {
            tiggerCursorMap[value] = cursor;
            value.addEventListener(MouseEvent.ROLL_OVER, __triggerOver, false, 0, true);
            value.addEventListener(MouseEvent.ROLL_OUT, __triggerOut, false, 0, true);
            return;
        }
		
		
		static private function __triggerOver(value:MouseEvent) : void
        {
            var target:DisplayObject = value.currentTarget as DisplayObject;
            var display:DisplayObject = tiggerCursorMap[target] as DisplayObject;
            if (display)
            {
                showCustomCursor(display);
            }
            return;
        }
        static private function __triggerOut(param1:MouseEvent) : void
        {
            var target:DisplayObject = param1.currentTarget as DisplayObject;
            var display:DisplayObject= tiggerCursorMap[target] as DisplayObject;
            if (display)
            {
                hideCustomCursor(display);
            }
            return;
        }
        
        static private function __mouseMove(event:MouseEvent) : void
        {
            cursorHolder.x = cursorHolder.parent.mouseX;
            cursorHolder.y = cursorHolder.parent.mouseY;
            //DepthManager.bringToTop(cursorHolder);
            return;
        }
    }
}