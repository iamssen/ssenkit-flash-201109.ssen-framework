package ssen.airconnection {

import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.net.LocalConnection;
import flash.utils.Timer;

/** Web Side Connection */
final public class WebConnection extends Connection {

	private var _f : int;

	private var _max : int;

	private var _ftimer : Timer;

	private var _channel : int;

	private var _reciver : LocalConnection;

	/** 메세지를 전송할 타겟들 */
	public var sendTo : SendTo = SendTo.AIR_AND_WEB;

	public function WebConnection(config : IConnectionConfig = null) {
		super(config);
	}

	/* *********************************************************************
	 * connection
	 ********************************************************************* */
	/** @private */
	override protected function connect() : void {
		_f = -1;
		_max = config.channels;
		_ftimer = new Timer(3000);
		_ftimer.addEventListener(TimerEvent.TIMER, timebreak);
		find();
	}

	private function find() : void {
		if (++_f < _max) {
			log.info("find", _f, _max);
			var lc : LocalConnection = new LocalConnection;
			addAliveEvent(lc);
			// lc.send(config.connectionName + "_" + _f, "recive", "ChannelIsAlive", "null");
			lc.send(config.connectionName + _f, "recive", "ChannelIsAlive", "null");
			_ftimer.start();
		}
	}

	private function timebreak(event : TimerEvent) : void {
		_ftimer.stop();
		find();
	}

	private function addAliveEvent(lc : LocalConnection) : void {
		lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, aliveAsyncError);
		lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, aliveSecurityError);
		lc.addEventListener(StatusEvent.STATUS, aliveStatus);
	}

	private function removeAliveEvent(lc : LocalConnection) : void {
		lc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, aliveAsyncError);
		lc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, aliveSecurityError);
		lc.removeEventListener(StatusEvent.STATUS, aliveStatus);
	}

	private function aliveStatus(event : StatusEvent) : void {
		log.info(event);
		removeAliveEvent(event.target as LocalConnection);
		_ftimer.reset();
		if (event.level == "status") {
			find();
		} else {
			try {
				_channel = _f;
				_reciver = new LocalConnection;
				// _reciver.allowDomain(config.domain, "app#" + config.appId);
				_reciver.allowDomain("*");
				_reciver.client = this;
				// _reciver.connect(config.connectionName + "_" + _channel);
				_reciver.connect(config.connectionName + _channel);

				// log.info("WebConnection.aliveStatus allowDomain", config.domain, "app#" + config.appId);
				log.info("WebConnection.aliveStatus connectionName", config.connectionName + _channel);
				log.info("WebConnection.aliveStatus from", from);

				_ftimer.stop();
				_ftimer.removeEventListener(TimerEvent.TIMER, timebreak);
				_ftimer = null;

				dispatchEvent(new Event(Event.INIT));
			} catch (error : Error) {
				log.error(error);
				find();
			}
		}
	}

	private function aliveSecurityError(event : SecurityErrorEvent) : void {
		log.info(event);
		_ftimer.reset();
		removeAliveEvent(event.target as LocalConnection);
		dispatchEvent(new ConnectionErrorEvent(ConnectionErrorEvent.CONNECT_ERROR, event.text));
	}

	private function aliveAsyncError(event : AsyncErrorEvent) : void {
		log.info(event);
		_ftimer.reset();
		removeAliveEvent(event.target as LocalConnection);
		dispatchEvent(new ConnectionErrorEvent(ConnectionErrorEvent.CONNECT_ERROR, event.text));
	}

	/* *********************************************************************
	 *
	 ********************************************************************* */
	/** @private */
	override protected function get from() : String {
		// return config.domain + ":" + config.connectionName + "_" + _channel;
		return config.connectionName + _channel;
	}

	/** @private */
	override protected function disconnect() : void {
		try {
			_reciver.close();
		} catch (error : Error) {
			log.error(error);
		}
	}

	/** @private */
	override protected function sendMessage(command : String, parameters : Array) : void {
		if (sendTo != SendTo.WEB_ONLY) {
			// localConnectionSend("app#" + config.appId + ":" + config.connectionName,
			// command, parameters);
			localConnectionSend(config.connectionName, command, parameters);
		}

		if (sendTo != SendTo.AIR_ONLY) {
			var f : int = config.channels;
			while (--f >= 0) {
				if (_channel != f) {
					// localConnectionSend(config.connectionName + "_" + f, command, parameters);
					// log.info("Send To ::", config.connectionName + "_" + f, command, parameters);
					localConnectionSend(config.connectionName + f, command, parameters);
					log.info("Send To ::", config.connectionName + f, command, parameters);
				}
			}
		}
	}
}
}