package ssen.loader {

import flash.events.Event;
import flash.events.ErrorEvent;
import flash.events.DataEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;

import ssen.log.SSenLogger;

/** 기본 업로더 */
public class DefaultUploader extends FileLoader {

	private var _load : Upload;

	private var log : SSenLogger;

	public function DefaultUploader() {
		log = new SSenLogger(this);
	}

	/** @inheritDoc */
	override public function deconstruct() : void {
		_load = null;
		super.deconstruct();
	}

	/** @inheritDoc */
	override public function start() : void {
		if (load is Upload) {
			_load = load as Upload;
		} else {
			throw new Error("load is not Upload!");
		}

		_load.parameters["loader"] = "defaultUpload";

		fileAddEvent(_load.local);
		_load.state = LoadState.LOAD;
		_load.bytesLoaded = 0;
		_load.local.upload(_load.getRequest());

		log.info("??? start", _load.local, _load.getRequest().url);
	}

	/** @inheritDoc */
	override public function cancel() : void {
		_load.local.cancel();
		// _load.bytesLoaded = 0;
		fileRemoveEvent(_load.local);
		_load.state = LoadState.PAUSED;
		dispatchEvent(new Event(Event.CANCEL));
		// callback(load);
	}

	/* *********************************************************************
	 * event handling
	 ********************************************************************* */
	private function uploadSecurityError(event : SecurityErrorEvent) : void {
		log.error(event);
		_load.bytesLoaded = 0;
		fileRemoveEvent(_load.local);
		_load.state = LoadState.ERROR;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		// callback(load);
	}

	private function uploadIOError(event : IOErrorEvent) : void {
		log.error(event);
		_load.bytesLoaded = 0;
		fileRemoveEvent(_load.local);
		_load.state = LoadState.ERROR;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		// callback(load);
	}

	private function uploadComplete(event : DataEvent) : void {
		log.error(event);

		_load.bytesLoaded = _load.bytesTotal;
		_load.resultData = event.data;
		fileRemoveEvent(_load.local);
		_load.state = LoadState.COMPLETE;
		dispatchEvent(new Event(Event.COMPLETE));
		// callback(load);
	}

	private function uploadProgress(event : ProgressEvent) : void {
		log.error(event);
		_load.bytesLoaded = event.bytesLoaded;
		_load.bytesTotal = event.bytesTotal;
		checkSpeed();
	}

	/* *********************************************************************
	 * event on/off
	 ********************************************************************* */
	private function fileAddEvent(file : File) : void {
		file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadComplete);
		file.addEventListener(IOErrorEvent.IO_ERROR, uploadIOError);
		file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityError);
		file.addEventListener(ProgressEvent.PROGRESS, uploadProgress);
	}

	private function fileRemoveEvent(file : File) : void {
		file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadComplete);
		file.removeEventListener(IOErrorEvent.IO_ERROR, uploadIOError);
		file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityError);
		file.removeEventListener(ProgressEvent.PROGRESS, uploadProgress);
	}
}
}