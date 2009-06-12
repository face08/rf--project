package {
    import com.youbt.debug.DebugUtils;
    import com.youbt.debug.RFTraceError;
    import com.youbt.debug.RFTraceWarn;
    import com.youbt.events.RFEvent;
    import com.youbt.manager.RFSystemManager;

    import flash.display.Sprite;



    [ExcludeClass]
    [Frame(factoryClass="com.youbt.preloaders.Preloader")]

    public class RF extends Sprite
    {
        public function RF()
        {   
            RFSystemManager.getInstance().addEventListener(RFEvent.INITIALIZE,initHandler);
            RFSystemManager.getInstance().addEventListener(RFEvent.LOADING_COMPLETE,loadingcompleteHandler);
        }
        private function initHandler(e:RFEvent):void{

            DebugUtils.isDebugMode=true;
            DebugUtils.isPanelOutput=true

            RFTraceError("TRACE ERROR")
            RFTraceWarn("TRACE WARNNING")


        }

        private function loadingcompleteHandler(e:RFEvent):void
        { 


        }
    }
}

