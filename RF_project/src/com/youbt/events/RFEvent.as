package  com.youbt.events
{

import flash.events.Event;

/**
 *  The RFEvent class represents the event object passed to
 *  the event listener for many rfevents.
 */
public class RFEvent extends Event
{


    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *
     *  @eventType add
     */
    public static const ADD:String = "add";

    /**
     *
     *  @eventType applicationComplete
     */
    public static const LOADING_COMPLETE:String = "loadingComplete";


    /**
	 *
     *  @eventType creationComplete
     */
    public static const CREATION_COMPLETE:String = "creationComplete";

    /**
     *
     *  @eventType cursorUpdate
     */
    public static const CURSOR_UPDATE:String = "cursorUpdate";


    /**
     *
     *  @eventType hide
     */
    public static const HIDE:String = "hide";

    /**
     * 
     *  @eventType idle
     */
    public static const IDLE:String = "idle";

    /**
    
     */
    public static const INIT_COMPLETE:String = "initComplete";

    /**
     *
     *  
     *  @eventType initProgress
     */
    public static const INIT_PROGRESS:String = "initProgress";

    /**
     *	@eventType initialize
     *  Application 的真正入口
     *  
     */
    public static const INITIALIZE:String = "initialize";


    /**
     *
     *  @eventType loading
     * 
     */
    public static const LOADING:String = "loading";

    /**
     *
     *  @eventType preinitialize
     */
    public static const PREINITIALIZE:String = "preinitialize";

   
    /**
     *
     *  @eventType remove
     */
    public static const REMOVE:String = "remove";

    /**
     *
     *  @eventType show
     */
    public static const SHOW:String = "show";


    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble up
     *  the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     */
    public function RFEvent(type:String,isPlugin:Boolean=false, bubbles:Boolean = false,
                              cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        this.isPlugin=isPlugin
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var isPlugin:Boolean
    
    override public function clone():Event
    {
        return new RFEvent(type,isPlugin,bubbles, cancelable);
    }
}

}
