package ssen.log {
import flash.events.EventDispatcher;

/** Virtual Console Dispatcher, Singleton */
internal class VirtualConsoleDispatcher extends EventDispatcher {
	/* *********************************************************************
	* singleton
	********************************************************************* */
	private static var _instance:VirtualConsoleDispatcher;

	/** get singleton */
	public static function getInstance():VirtualConsoleDispatcher {
		if (_instance == null) {
			_instance = new VirtualConsoleDispatcher();
		}
		return _instance;
	}
}
}