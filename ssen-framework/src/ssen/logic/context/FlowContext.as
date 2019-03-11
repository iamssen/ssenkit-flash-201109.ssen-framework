package ssen.logic.context {
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import ssen.common.getQualifiedClassName2;
import ssen.logic.StateChanger;
import ssen.logic.Trigger;
import ssen.logic.events.StateEvent;
import ssen.logic.logic_internal;

use namespace logic_internal;

[DefaultProperty("stateset")]

public class FlowContext extends EventDispatcher {
	/* *********************************************************************
	*
	********************************************************************* */
	private static var dic:Dictionary;
	
	/** @private instance 를 가져온다 */
	logic_internal static function getInstance(clazz:Class,
											   name:String):FlowContext {
		if (dic == null) {
			dic = new Dictionary;
		}
		
		var id:String = getId(clazz, name);
		
		if (dic[id] == undefined) {
			var flow:FlowContext = new clazz();
			flow.parseStates();
			dic[id] = flow;
		}
		
		return dic[id];
	}
	
	private static function getId(clazz:Class, name:String):String {
		return getQualifiedClassName2(clazz)+"#"+name;
	}
	
	/* *********************************************************************
	* constructor
	********************************************************************* */
	/** (mxml parameter) 상태 흐름 설정 */
	public var stateset:Vector.<state> = new Vector.<state>;
	
	public function FlowContext() {
	}
	
	/* *********************************************************************
	* state parse
	********************************************************************* */
	private var smap:Dictionary;
	
	private var currentState:String;
	
	private function parseStates():void {
		if (stateset.length == 0) {
			return;
		}
		
		smap = new Dictionary;
		
		var f:int = -1;
		var s:int;
		var th:int;
		var fmax:int = stateset.length;
		var smax:int;
		var thmax:int;
		var st:state;
		var tg:trigger;
		var dic:Dictionary;
		var vec:Vector.<Class>;
		
		while (++f < fmax) {
			st = stateset[f];
			
			if (f == 0) {
				currentState = st.name;
			}
			
			smap[st.name] = new Dictionary;
			
			if (st.startup && st.startup.length > 0) {
				smap[st.name]["startup"] = vec = new Vector.<Class>;
				s = -1;
				smax = st.startup.length;
				
				while (++s < smax) {
					vec.push(st.startup[s].type);
				}
			}
			
			if (st.shutdown && st.shutdown.length > 0) {
				smap[st.name]["shutdown"] = vec = new Vector.<Class>;
				s = -1;
				smax = st.shutdown.length;
				
				while (++s < smax) {
					vec.push(st.shutdown[s].type);
				}
			}
			
			smap[st.name]["triggers"] = new Dictionary;
			
			if (st.triggers && st.triggers.length > 0) {
				s = st.triggers.length;
				
				while (--s >= 0) {
					tg = st.triggers[s];
					dic = smap[st.name]["triggers"][getQualifiedClassName2(tg.type)] = new Dictionary;
					dic["type"] = tg.type;
					dic["to"] = tg.to;
					vec = dic["commands"] = new Vector.<Class>;
					
					if (tg.commands) {
						th = -1;
						thmax = tg.commands.length;
						
						while (++th < thmax) {
							vec.push(tg.commands[th].type);
						}
					}
				}
			}
		}
		
		stateset = null;
	}
	
	/** @private 현재 state 에 해당하는 trigger 가 설정되어 있는지 확인한다 */
	final logic_internal function hasTrigger(trigger:Trigger):Boolean {
		return smap[currentState]["triggers"][getQualifiedClassName2(trigger)] != undefined;
	}
	
	/** @private 해당 trigger 에 해당하는 command 들을 가져온다 (from state shutdown commands + trigger commands + state change command + to state startup commands) */
	final logic_internal function getTriggerCommands(trigger:Trigger):Array {
		var tg:Dictionary = smap[currentState]["triggers"][getQualifiedClassName2(trigger)];
		var cmds:Array = new Array;
		var f:int;
		var max:int;
		var commands:Vector.<Class>;
		
		if (tg["to"] != undefined) {
			var to:Dictionary = smap[tg["to"]];
			var from:Dictionary = smap[currentState];
			
			// + shutdown commands
			commands = from["shutdown"];
			
			if (commands && commands.length > 0) {
				f = -1;
				max = commands.length;
				
				while (++f < max) {
					cmds.push(commands[f]);
				}
			}
			
			// + trigger commands, state changer
			f = -1;
			max = tg.commands.length
			
			while (++f < max) {
				cmds.push(tg.commands[f]);
			}
			cmds.push(new StateChanger(this, tg["to"]));
			
			// + startup commands
			commands = to["startup"];
			
			if (commands && commands.length > 0) {
				f = -1;
				max = commands.length;
				
				while (++f < max) {
					cmds.push(commands[f]);
				}
			}
		} else {
			// + trigger commands
			f = -1;
			max = tg.commands.length
			
			while (++f < max) {
				cmds.push(tg.commands[f]);
			}
		}
		
		return cmds;
	
		// trigger command 들을 생성
	
		// from 의 shutdown - trigger commands - StateChanger - to startup 을 잇는다.
		// to 가 없으면 순수한 trigger commands 만 반환
	}
	
	/** @private 현재 state 를 가져온다 */
	final logic_internal function getCurrentState():String {
		return currentState;
	}
	
	/** @private state 를 바꾼다 */
	final logic_internal function setCurrentState(state:String):void {
		dispatchEvent(new StateEvent(StateEvent.STATE_SHUTDOWN, currentState));
		currentState = state;
		
		dispatchEvent(new StateEvent(StateEvent.STATE_STARTUP, currentState));
	}
}
}
