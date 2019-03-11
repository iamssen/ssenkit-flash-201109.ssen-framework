package ssen.logic.events {
import flash.events.Event;

import ssen.common.infoToString;
import ssen.logic.Trigger;

public class StateEvent extends Event {
	
	/** trigger 가 시작되었을 때 */
	public static const TRIGGER_FIRED:String = "triggerFired";
	
	/** state 가 시작될 때 */
	public static const STATE_STARTUP:String = "stateStartup";
	
	/** state 가 종료될 때 */
	public static const STATE_SHUTDOWN:String = "stateShutdown";
	
	private var _currentState:String;
	
	private var _firedTrigger:Trigger;
	
	public function StateEvent(type:String, currentState:String,
							   firedTrigger:Trigger = null) {
		super(type);
		
		_currentState = currentState;
		_firedTrigger = firedTrigger;
	}
	
	/** 실행된 trigger */
	public function get firedTrigger():Trigger {
		return _firedTrigger;
	}
	
	/** 현재 state */
	public function get currentState():String {
		return _currentState;
	}
	
	/** @private */
	override public function clone():Event {
		return new StateEvent(type, currentState, firedTrigger);
	}
	
	/** @private */
	override public function toString():String {
		return infoToString(this,
							{ type: type, currentState: currentState,
							  firedTrigger: firedTrigger });
	}



}
}