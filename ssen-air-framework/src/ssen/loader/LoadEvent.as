package ssen.loader {
import ssen.common.infoToString;

import flash.events.Event;

/**
 * @author seoyeonlee
 */
public class LoadEvent extends Event {
	public static const BYTES_CHANGED : String = "bytesChanged";
	public static const NAME_CHANGED : String = "nameChanged";
	public static const STATE_CHANGED : String = "stateChanged";
	public static const URL_CHANGED : String = "urlChanged";
	public static const LOCAL_FILE_CHANGED : String = "localFileChanged";

	public function LoadEvent(type : String) {
		super(type);
	}

	override public function clone() : Event {
		return new LoadEvent(type);
	}

	override public function toString() : String {
		return infoToString(this, {type:type});
	}
}
}
