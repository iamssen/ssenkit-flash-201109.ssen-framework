package ssen.logic {

use namespace logic_internal;

/**
 * 간단하게 Command 들을 실행시킨다
 * @param commands 실행시킬 Command
 * @param callback Command 들이 모두 종료되었을때 실행시킬 function(trigger:Trigger)
 * @param exception Command 실행 중 예외 처리를 위한 function(exception:Exception)
 * @param parameters Command 들이 사용할 parameters
 */
public function execute(commands:Array, callback:Function, exception:Function,
						parameters:Object = null):void {
	var trigger:Trigger = new Trigger(callback, exception, parameters);
	var executer:Executer = new Executer;
	executer.trigger = trigger;
	executer.commands = commands;
	executer.next();
}
}