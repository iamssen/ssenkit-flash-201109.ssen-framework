package ssen.loader {
import flash.events.Event;
import flash.events.ProgressEvent;

import ssen.common.infoToString;

/** Load 이벤트 */
public class FileLoadEvent extends ProgressEvent {
	/** 진행 중 */
	public static const PROGRESS:String = "progress";

	private var _bytesPerSec:Number;

	public function FileLoadEvent(type:String, bytesLoaded:Number = 0,
								  bytesTotal:Number = 0, bytesPerSec:Number = 0) {
		super(type, false, false, bytesLoaded, bytesTotal);
		_bytesPerSec = bytesPerSec;
	}

	/** 초당 전송 Byte 수량 */
	public function get bytesPerSec():Number {
		return _bytesPerSec;
	}

	/** @private */
	override public function clone():Event {
		return new FileLoadEvent(type, bytesLoaded, bytesTotal, bytesPerSec);
	}

	/** @private */
	override public function toString():String {
		return infoToString(this,
							{ type: type, bytesLoaded: bytesLoaded,
							  bytesTotal: bytesTotal,
							  bytesPerSec: bytesPerSec });
	}
}
}