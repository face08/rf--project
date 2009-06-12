package  com.youbt.events
{
    import flash.events.Event;
    public class TweenEvent extends Event {


        public static  const TWEEN_END:String="tweenEnd";


        public static  const TWEEN_START:String="tweenStart";


        public static  const TWEEN_UPDATE:String="tweenUpdate";

        public static const TWEEN_STOP:String="tweenStop";


        public function TweenEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,value:Object=null) {
            super(type,bubbles,cancelable);

            this.value=value;
        }
        /**
         */
        public var value:Object;

        override public  function clone():Event {
            return new TweenEvent(type,bubbles,cancelable,value);
        }
    }

}

