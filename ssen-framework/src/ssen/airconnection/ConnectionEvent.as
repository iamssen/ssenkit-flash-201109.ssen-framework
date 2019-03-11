package ssen.airconnection {
import flash.events.Event;

import ssen.common.infoToString;

public class ConnectionEvent extends Event {
	/** message 를 수신했음 */
	public static const RECEIVE_MESSAGE:String = "receiveMessage";

	private var _command:String;

	private var _parameters:Array;

	private var _from:String;

	public function ConnectionEvent(type:String, from:String, command:String,
									parameters:Array = null) {
		super(type);

		_from = from;
		_command = command;
		_parameters = parameters;
	}

	/** 보낸 곳 */
	public function get from():String {
		return _from;
	}

	/** 파라메터 */
	public function get parameters():Array {
		return _parameters;
	}

	/** 명령 */
	public function get command():String {
		return _command;
	}

	/** @private */
	override public function clone():Event {
		return new ConnectionEvent(type, from, command, parameters);
	}

	/** @private */
	override public function toString():String {
		return infoToString(this,
							{ type: type, from: from, command: command,
							  value: parameters });
	}



}
}