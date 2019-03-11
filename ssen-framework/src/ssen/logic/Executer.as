package ssen.logic {
import ssen.common.IDeconstructable;

use namespace logic_internal;

/** @private Command 들을 직렬 연결 해서 실행시키는데 사용됨 */
final public class Executer implements IDeconstructable {
	private var step:int = -1;
	
	private var current:Command;
	
	/** @private */
	public var trigger:Trigger;
	
	/** @private */
	public var commands:Array;
	
	/** Command 를 실행시킴 */
	final public function exec():void {
		next();
	}
	
	/** @private 다음 Command 를 실행시킴 */
	final logic_internal function next():void {
		if (++step < commands.length) {
			if (commands[step] is Class) {
				var cls:Class = commands[step];
				current = new cls();
			} else {
				current = commands[step];
			}
			current.setExecuter(this);
			current.setTrigger(trigger);
			
			current.exec();
		} else {
			trigger.callback(trigger);
			deconstruct();
		}
	}
	
	/** @private 예외로 인해서 Command 를 중지 시킴 */
	final logic_internal function stop():void {
		deconstruct();
	}
	
	/** @inheritDoc */
	public function deconstruct():void {
		trigger.deconstruct();
		commands = null;
		current = null;
		trigger = null;
	}
}
}
