package ssen.logic {
import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.core.IMXMLObject;

import ssen.common.EventCache;
import ssen.common.IDeconstructable;
import ssen.logic.context.FlowContext;
import ssen.logic.events.StateEvent;

use namespace logic_internal;

[Event(name="triggerFired", type="ssen.logic.events.StateEvent")]
[Event(name="stateStartup", type="ssen.logic.events.StateEvent")]
[Event(name="stateShutdown", type="ssen.logic.events.StateEvent")]

public class Flow implements IMXMLObject, IDeconstructable, IEventDispatcher {
	/* *********************************************************************
	* properties
	********************************************************************* */
	private var _cache:EventCache;
	
	private var _context:FlowContext;
	
	/* *********************************************************************
	* parameters
	********************************************************************* */
	//public var context:Class;
	
	public function get context():Class {
		return _contextCls;
	}
	
	public function set context(context:Class):void {
		trace(context);
		_contextCls = context;
	}
	
	public var name:String = "default";
	
	/* *********************************************************************
	* construct
	********************************************************************* */
	private var _contextCls:Class;
	
	public function Flow(context:Class = null, name:String = "default") {
		_cache = new EventCache(this);
		
		if (context) {
			setContext(context, name);
		}
	}
	
	private function setContext(context:Class, name:String):void {
		_context = FlowContext.getInstance(context, name);
	}
	
	public function initialized(document:Object, id:String):void {
		
		trace(context);
		
		if (context) {
			setContext(context, name);
		} else {
			throw new Error("context 가 없습니다!!!");
		}
	}
	
	/* *********************************************************************
	* IDeconstructable
	********************************************************************* */
	/** @inheritDoc */
	public function deconstruct():void {
		_context = null;
		_cache.deconstruct();
		_cache = null;
	}
	
	/* *********************************************************************
	* implement IEventDispatcher
	********************************************************************* */
	/** @inheritDoc */
	final public function addEventListener(type:String, listener:Function,
										   useCapture:Boolean = false,
										   priority:int = 0,
										   useWeakReference:Boolean = false):void {
		_cache.add(type, listener, useCapture, priority, useWeakReference);
		
		if (_context != null) {
			_context.addEventListener(type, listener, useCapture, priority,
									  useWeakReference);
		}
	}
	
	/** @inheritDoc */
	final public function dispatchEvent(event:Event):Boolean {
		return _context.dispatchEvent(event);
	}
	
	/** @inheritDoc */
	final public function hasEventListener(type:String):Boolean {
		return _context.hasEventListener(type);
	}
	
	/** @inheritDoc */
	final public function removeEventListener(type:String, listener:Function,
											  useCapture:Boolean = false):void {
		_cache.remove(type, listener, useCapture);
		
		if (_context != null) {
			_context.removeEventListener(type, listener, useCapture);
		}
	}
	
	/** @inheritDoc */
	final public function willTrigger(type:String):Boolean {
		return _context.willTrigger(type);
	}
	
	/* *********************************************************************
	*
	********************************************************************* */
	public function getCurrentState():String {
		return _context.getCurrentState();
	}
	
	public function fire(trigger:Trigger):void {
		if (_context.hasTrigger(trigger)) {
			dispatchEvent(new StateEvent(StateEvent.TRIGGER_FIRED,
										 getCurrentState(), trigger));
			var exec:Executer = new Executer;
			exec.trigger = trigger;
			exec.commands = _context.getTriggerCommands(trigger);
			exec.next();
		}
	}
}
}