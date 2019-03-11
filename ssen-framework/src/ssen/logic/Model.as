package ssen.logic {
import flash.events.Event;
import flash.events.IEventDispatcher;

import ssen.common.UnbindObject;

public class Model extends Actor implements IEventDispatcher {
	
	private var _dispatcher:UnbindObject;
	
	public function Model() {
		_dispatcher = new UnbindObject;
	}
	
	/** @inheritDoc */
	override public function deconstruct():void {
		_dispatcher.deconstruct();
		_dispatcher = null;
		super.deconstruct();
	}
	
	/* *********************************************************************
	* implements IEventDispatcher
	********************************************************************* */
	final public function addEventListener(type:String, listener:Function,
										   useCapture:Boolean = false,
										   priority:int = 0,
										   useWeakReference:Boolean = false):void {
		_dispatcher.addEventListener(type, listener, useCapture, priority,
									 useWeakReference);
	}
	
	final public function dispatchEvent(event:Event):Boolean {
		return _dispatcher.dispatchEvent(event);
	}
	
	final public function hasEventListener(type:String):Boolean {
		return _dispatcher.hasEventListener(type);
	}
	
	final public function removeEventListener(type:String, listener:Function,
											  useCapture:Boolean = false):void {
		_dispatcher.removeEventListener(type, listener, useCapture);
	}
	
	final public function willTrigger(type:String):Boolean {
		return _dispatcher.willTrigger(type);
	}
}
}