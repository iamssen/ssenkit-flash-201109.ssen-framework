package ssen.airconnection {

import ssen.common.UnbindObject;
import ssen.log.ConsoleTracer;
import ssen.log.JSConsoleTracer;
import ssen.log.SSenLogger;

import mx.core.IMXMLObject;

import flash.events.AsyncErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.net.LocalConnection;

[DefaultProperty("config")]
/** 초기화 되었을 때 */
[Event(name="init", type="flash.events.Event")]
/** 초기화 중에 에러가 발생됨 */
[Event(name="connectError", type="ssen.airconnection.ConnectionErrorEvent")]
/** 메세지를 수신했음 */
[Event(name="receiveMessage", type="ssen.airconnection.ConnectionEvent")]
public class Connection extends UnbindObject implements IMXMLObject {

	private var _config : IConnectionConfig;

	/** @private */
	protected var log : SSenLogger;

	private var _running : Boolean;

	/* *********************************************************************
	 * setting
	 ********************************************************************* */
	/** config */
	final public function get config() : IConnectionConfig {
		return _config;
	}

	final public function set config(value : IConnectionConfig) : void {
		if (_running) {
			return;
		}
		_config = value;
	}

	/* *********************************************************************
	 * initialize
	 ********************************************************************* */
	public function Connection(config : IConnectionConfig = null) {
		_config = config;

		log = new SSenLogger(this, new ConsoleTracer, new JSConsoleTracer());
	}

	/** @private */
	final public function initialized(document : Object, id : String) : void {
		if (_running) {
			return;
		}
		if (config) {
			start();
		}
	}

	/** 연결을 시작함 */
	final public function start() : void {
		if (_running) {
			return;
		}

		if (!config) {
			throw new ArgumentError("config is null");
		}

		_running = true;

		connect();
	}

	/** 연결을 끊음 */
	final public function stop() : void {
		if (!_running) {
			return;
		}

		disconnect();
	}

	/* *********************************************************************
	 * connection
	 ********************************************************************* */
	/** @private */
	protected function connect() : void {
		throw new Error("not implemented!!!");
	}

	/** @private */
	protected function disconnect() : void {
		throw new Error("not implemented!!!");
	}

	/* *********************************************************************
	 * message
	 ********************************************************************* */
	private function addSendEvent(lc : LocalConnection) : void {
		lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, sendAsyncError);
		lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, sendSecurityError);
		lc.addEventListener(StatusEvent.STATUS, sendStatus);
	}

	private function sendStatus(event : StatusEvent) : void {
		log.info(event);
		removeSendEvent(event.target as LocalConnection);
	}

	private function sendSecurityError(event : SecurityErrorEvent) : void {
		log.info(event);
		removeSendEvent(event.target as LocalConnection);
	}

	private function sendAsyncError(event : AsyncErrorEvent) : void {
		log.info(event);
		removeSendEvent(event.target as LocalConnection);
	}

	private function removeSendEvent(lc : LocalConnection) : void {
		lc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, sendAsyncError);
		lc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, sendSecurityError);
		lc.removeEventListener(StatusEvent.STATUS, sendStatus);
	}

	/** @private */
	protected function get from() : String {
		throw new Error("not implemented!!!");
	}

	/** 메세지를 보냄 */
	final public function send(command : String, ... parameters : Array) : void {
		sendMessage(command, parameters);
	}

	/** @private */
	protected function sendMessage(command : String, parameters : Array) : void {
		throw new Error("not implemented!!!");
	}

	/** @private */
	final protected function localConnectionSend(connName : String, command : String, params : Array) : void {
		var lc : LocalConnection = new LocalConnection;
		addSendEvent(lc);
		var arr : Array = [connName, "recive", from, command];
		arr = arr.concat(params);
		log.info("send ::", arr);
		lc.send.apply(null, arr);
	}

	/** @private */
	final public function recive(from : String, command : String, ... params : Array) : void {
		if (command == "ChannelIsAlive") {
			return;
		}
		dispatchEvent(new ConnectionEvent(ConnectionEvent.RECEIVE_MESSAGE, from, command, params));
	}
}
}