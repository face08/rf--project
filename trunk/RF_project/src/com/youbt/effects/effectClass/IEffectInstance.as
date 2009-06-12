package  com.youbt.effects.effectClass
{

import flash.events.Event;

public interface IEffectInstance
{
	function initEffect(event:Event):void;
	function startEffect():void;
	function play():void;
	function pause():void;
	function resume():void;
	function reverse():void;
	function end():void;
	function finishEffect():void;
	function finishRepeat():void;
}

}

