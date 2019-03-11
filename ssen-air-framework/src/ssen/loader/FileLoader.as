package ssen.loader {

import ssen.common.UnbindObject;

import flash.events.ProgressEvent;
import flash.utils.getTimer;

/** 에러가 발생했음 */
[Event(name="error", type="flash.events.ErrorEvent")]
/** 로드가 완료 되었음 */
[Event(name="complete", type="flash.events.Event")]
/** 진행 중인 로드의 progress */
[Event(name="progress", type="ssen.loader.FileLoadEvent")]
/** 로드가 취소되었음 */
[Event(name="cancel", type="flash.events.Event")]
/** 추상 로더 */
public class FileLoader extends UnbindObject {

	/** 타겟이 되는 로드 */
	public var load : Load;

	// ** 로드의 결과를 받을 함수, callback(Load) 로 전송됨 */
	// public var callback : Function;
	/** 로드를 시작한다 */
	public function start() : void {
		throw new Error("not implemented");
	}

	/** 로드를 일시 중지 한다 */
	public function cancel() : void {
		throw new Error("not implemented");
	}

	/* *********************************************************************
	 * speed check
	 ********************************************************************* */
	private var _lastBytes : int;

	private var _lastCheckTime : int;

	/** progress 때마다 호출해줘야 함 */
	final protected function checkSpeed() : void {
		if (_lastCheckTime > 0) {
			var current : int = getTimer();
			var time : int = current - _lastCheckTime;

			if (time > 1500) {
				var loaded : int = load.bytesLoaded - _lastBytes;

				load.bytesPerSec = loaded / (time / 1000);

				_lastBytes = load.bytesLoaded;
				_lastCheckTime = current;
			}

			dispatchEvent(new FileLoadEvent(ProgressEvent.PROGRESS, load.bytesLoaded, load.bytesTotal, load.bytesPerSec));
		} else {
			_lastBytes = load.bytesLoaded;
			_lastCheckTime = getTimer();
		}
	}

	/** @inheritDoc */
	override public function deconstruct() : void {
		load.bytesPerSec = 0;
		load = null;
		// callback = null;
		super.deconstruct();
	}
}
}