package ssen.logic.exceptions {
import ssen.logic.Exception;

public class ConfirmException extends Exception {
	private var _title:String;
	
	private var _confirm:Boolean;
	
	public function ConfirmException(resume:Function, title:String,
									 message:String, type:int = 0) {
		super(null, resume, message, type);
		
		_title = title;
	}
	
	public function get title():String {
		return _title;
	}
	
	public function get confirm():Boolean {
		return _confirm;
	}
	
	public function set confirm(confirm:Boolean):void {
		_confirm = confirm;
	}
}
}