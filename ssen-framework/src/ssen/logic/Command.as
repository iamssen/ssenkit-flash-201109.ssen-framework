package ssen.logic {
use namespace logic_internal;
public class Command extends Actor {

	private var executer : Executer;

	private var trigger : Trigger;

	/* *********************************************************************
	 * parameters
	 ********************************************************************* */
	/** @private */
	final logic_internal function setExecuter(executer : Executer) : void {
		this.executer = executer;
	}

	/** @private */
	final logic_internal function setTrigger(trigger : Trigger) : void {
		this.trigger = trigger;
	}

	/* *********************************************************************
	 * interface
	 ********************************************************************* */
	/** 실행 */
	final public function exec() : void {
		execute();
	}

	/** 예외로 인해 전체 Command 를 중지 시킴 */
	final public function stop() : void {
		executer.stop();
		deconstruct();
	}

	/* *********************************************************************
	 * protected
	 ********************************************************************* */
	/** 다음 Command 를 실행 */
	final protected function next() : void {
		executer.next();
		deconstruct();
	}

	/** 예외를 발생시킴 */
	final protected function exception(exception : Exception) : void {
		trigger.exception(exception);
	}

	/** parameter 를 가져온다 */
	final protected function getParameter(name : String, required : Boolean = true, defaultValue : * = null) : * {
		var value : * = trigger.parameters[name];

		if (value != null && value != undefined) {
			return value;
		} else if (required && value == null) {
			throw new Error("필수적인 파라미터가 입력되지 않았습니다!!! (" + name + ")");
		} else if (!required && defaultValue) {
			return defaultValue;
		}

		return null;
	}

	/** parameter 를 셋팅한다 */
	final protected function setParameter(name : String, value : * = null) : void {
		if (value != null && value != undefined) {
			trigger.parameters[name] = value;
		}
	}

	/** 현재 진행중인 trigger 의 타입을 알아본다 */
	final protected function checkTriggerType(triggerType : Class) : Boolean {
		return trigger is triggerType;
	}

	/* *********************************************************************
	 * abstract
	 ********************************************************************* */
	/** Abstract :: Command 가 처리할 내용들 */
	protected function execute() : void {
		throw new Error("not implemented!!!");
	}

	/** @inheritDoc */
	override public function deconstruct() : void {
		executer = null;
		trigger = null;
		super.deconstruct();
	}
}
}
