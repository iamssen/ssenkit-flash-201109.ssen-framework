package ssen.logic {
import ssen.common.infoToString;

use namespace logic_internal;

public class Exception {
	private var _message:String;
	
	private var _type:int;
	
	private var _resume:Function;
	
	private var _command:Command;
	
	/**
	 * Command 에서 발생되는 예외 상황
	 * @param command 예외가 발생한 Command
	 * @param resume 예외 처리가 가능한 상황에서 복구후에 재개를 요구할때 호출할 function(exception:Exception)
	 * @param message 예외에 대한 안내문
	 * @param type 예외에 대한 코드
	 *
	 */
	public function Exception(command:Command, resume:Function = null,
							  message:String = "", type:int = 0) {
		_command = command;
		_message = message;
		_resume = resume;
		_type = type;
	}
	
	/** 예외가 발생한 Command */
	final public function get command():Command {
		return _command;
	}
	
	/** 예외에 대한 자세한 사항 */
	final public function get message():String {
		return _message;
	}
	
	/** 예외의 타입 */
	final public function get type():int {
		return _type;
	}
	
	/** 진행 중이던 프로세스를 중단 시킨다 */
	final public function stop():void {
		_command.stop();
	}
	
	/** 재개 가능 여부 */
	final public function resumable():Boolean {
		return _resume != null;
	}
	
	/** 예외를 처리하고, 프로세스를 재개한다 */
	final public function resume():void {
		_resume(this);
	}
	
	/** @private */
	public function toString():String {
		return infoToString(this, { type: type, message: message });
	}

}
}