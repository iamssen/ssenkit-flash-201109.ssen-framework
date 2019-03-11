package ssen.logic {
import ssen.common.IDeconstructable;

public class Trigger implements IDeconstructable {
	
	private var _callback:Function;
	
	private var _parameters:Object;
	
	private var _exception:Function;
	
	/**
	 * @param callback Command 들이 모두 종료되었을때 실행시킬 function(trigger:Trigger = null)
	 * @param exception Command 실행 중 예외 처리를 위한 function(exception:Exception)
	 * @param parameters Command 들이 사용할 parameters
	 */
	public function Trigger(callback:Function, exception:Function,
							parameters:Object = null) {
		_callback = callback;
		_exception = exception;
		_parameters = parameters != null ? parameters : new Object;
	}
	
	/** 현재 Trigger 의 실행이 끝났을때 실행시킬 function */
	final logic_internal function get callback():Function {
		return _callback;
	}
	
	/** 실행에 대한 parameter 들 */
	public function get parameters():Object {
		return _parameters;
	}
	
	/** 현재 Trigger 의 실행중 예외를 처리해주는 function */
	final logic_internal function get exception():Function {
		return _exception;
	}
	
	/** @inheritDoc */
	public function deconstruct():void {
		_callback = null;
		_exception = null;
		_parameters = null;
	}
}
}
