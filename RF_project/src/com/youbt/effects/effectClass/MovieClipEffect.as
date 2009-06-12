package com.youbt.effects.effectClass
{
    import com.youbt.events.TweenEvent;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    [Event(name="tweenEnd", type="com.youbt.events.TweenEvent")]
    [Event(name="tweenStart", type="com.youbt.events.TweenEvent")]
    [Event(name="tweenUpdate", type="com.youbt.events.TweenEvent")]
    [Event(name="tweenStop", type="com.youbt.events.TweenEvent")]

    public class MovieClipEffect extends EventDispatcher
    {
        public function MovieClipEffect(target:Object=null)
        {
            super()
            this.target=target	
        }
        public function set target(value:Object):void{
            _mc=value as MovieClip
            if(_mc){
                _mc.stop()
            }

        }

        private var _mc:MovieClip
        public var startFrame:int=1;
        public var startDelay:int=0


        /**
         * 开始效果
         * 如果有延时播放，则需要调用该方法开始
         *
         */		
        public function startEffect():void
        {	

            if (startDelay > 0 )
            {
                delayTimer = new Timer(startDelay, 1);
                delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
                delayTimer.start();
            }
            else
            {
                play();

            }
        }
        private var delayTimer:Timer
        private function delayTimerHandler(event:TimerEvent):void
        {
            delayTimer.reset();
            delayTimer.stop()
            delayTimer.removeEventListener(TimerEvent.TIMER,delayTimerHandler);
            play();
        }
        public var reserve:Boolean=false

        /**
         * 播放
         *
         */		
        public function play():void
        {


            if(reserve){
                reservePlay()
                return
            }

            if(_mc){
                _mc.removeEventListener(Event.ENTER_FRAME,reserveHandler)
                _mc.removeEventListener(Event.ENTER_FRAME,frameHandler)

                _mc.addEventListener(Event.ENTER_FRAME,frameHandler)
                _mc.gotoAndPlay(startFrame)

            }
        }

        /**
         * 倒着播放
         *
         */		
        public function reservePlay():void
        {
            if(_mc){
                if(startFrame!=1){
                    _mc.gotoAndStop(startFrame)
                }else{
                    _mc.gotoAndStop(_mc.totalFrames)
                }
                _mc.addEventListener(Event.ENTER_FRAME,reserveHandler)
            }
        }
        private function reserveHandler(e:Event):void
        {
            if(_mc ){
                if(_mc.currentFrame!=1){
                    _mc.gotoAndStop(_mc.currentFrame-1)
                }else{
                    if(delayTimer){
                        delayTimer.reset();
                        delayTimer.stop()
                    }
                    _mc.removeEventListener(Event.ENTER_FRAME,reserveHandler)
                    this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false))
                }
            }

        }
        private function frameHandler(e:Event):void
        {
            if(_mc ){
                if(_mc.totalFrames==_mc.currentFrame){
                    if(delayTimer){
                        delayTimer.reset();
                        delayTimer.stop()
                    }
                    _mc.gotoAndStop(_mc.totalFrames)
                    _mc.removeEventListener(Event.ENTER_FRAME,frameHandler)
                    this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false))
                }
            }
        }

        public function end():void
        {
            if(_mc){
                _mc.stop()
                _mc.removeEventListener(Event.ENTER_FRAME,frameHandler)
                _mc.removeEventListener(Event.ENTER_FRAME,reserveHandler)
            }
            this.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false))
        }
    }
}

