package ssen.loader {

import ssen.common.UnbindObject;

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.ProgressEvent;

/** 로드가 진행중임 */
[Event(name="progress", type="ssen.loader.FileLoadEvent")]
/** 로드가 완료되었음 */
[Event(name="complete", type="flash.events.Event")]
/** 로드가 취소되었음 */
[Event(name="cancel", type="flash.events.Event")]
/** 로드가 오류로 인해서 취소 되었음 */
[Event(name="error", type="flash.events.ErrorEvent")]
/** SSen Loader */
public class SSenLoader extends UnbindObject {

	/** 로드를 지정해 줘야 합니다 */
	public var load : Load;

	private var _loader : FileLoader;

	final public function start() : void {
		if (load == null) {
			throw new Error("load 가 없습니다!!!");
		}

		if (load.state == LoadState.READY || load.state == LoadState.PAUSED) {
		} else {
			throw new Error("load 가 진행될 수 없는 상태 입니다.");
		}

		_loader = getLoader();
		_loader.load = load;
		// _loader.callback = callback;
		addEvents();
		_loader.start();
	}

	private function addEvents() : void {
		_loader.addEventListener(Event.COMPLETE, completeHandler);
		_loader.addEventListener(ErrorEvent.ERROR, errorHandler);
		_loader.addEventListener(Event.CANCEL, cancelHandler);
		_loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	}

	/** 현재 load 를 처리할 Loader 를 불러옴 */
	protected function getLoader() : FileLoader {
		if (load is Download) {
			return new DefaultDownloader;
		} else if (load.bytesLoaded > 0 || load.bytesTotal > 1024 * 1024 * 1024) {
			return new DivideUploader;
		} else {
			return new DefaultUploader;
		}
		return null;
	}

	/** 로드를 취소함 */
	public function cancel() : void {
		_loader.cancel();
	}

	/** @inheritDoc */
	override public function deconstruct() : void {
		load = null;
		_loader = null;
		super.deconstruct();
	}

	/* *********************************************************************
	 * callback
	 ********************************************************************* */
	/* *********************************************************************
	 * event handlers
	 ********************************************************************* */
	private function cancelHandler(event : Event) : void {
		dispatchEvent(event);
	}

	private function errorHandler(event : ErrorEvent) : void {
		dispatchEvent(event);
	}

	private function completeHandler(event : Event) : void {
		dispatchEvent(event);
	}

	private function progressHandler(event : FileLoadEvent) : void {
		dispatchEvent(event);
	}
	// private function callback(load : Load) : void {
	// _loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
	// _loader = null;
	//
	// switch (load.state) {
	// case LoadState.COMPLETE:
	// dispatchEvent(new Event(Event.COMPLETE));
	// break;
	// case LoadState.ERROR:
	// dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
	// break;
	// case LoadState.PAUSED:
	// dispatchEvent(new Event(Event.CANCEL));
	// break;
	// }
	// }
}
}