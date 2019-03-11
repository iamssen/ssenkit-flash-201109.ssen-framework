package ssen.loader {

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.DataEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;

import ssen.file.CacheCreator;

/** 파일을 분할해서 올리는 업로더 */
public class DivideUploader extends FileLoader {

	private var _load : Upload;

	private var _cc : CacheCreator;

	private var _lastBytesLoaded : Number;

	private var _cache : File;

	private var _result : Vector.<String>;

	/** 분할할 용량 */
	public var divideSize : Number = 1024 * 1024 * 100;

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

		_result = new Vector.<String>;

		if (!_cc) {
			_cc = new CacheCreator(_load.local, divideSize);
			_cc.bytesStart = _load.bytesLoaded;
		}

		createCache();
	}

	/** @inheritDoc */
	override public function cancel() : void {
		switch (_load.state) {
			case LoadState.WAIT:
				_cc.cancel();
				break;
			case LoadState.LOAD:
				_cache.cancel();
				_load.bytesLoaded = _lastBytesLoaded;
				fileRemoveEvent(_cache);
				break;
		}

		_cache = null;
		_cc = null;
		_load.state = LoadState.PAUSED;
		dispatchEvent(new Event(Event.CANCEL));
		// callback(load);
	}

	/* *********************************************************************
	 * cache flow
	 ********************************************************************* */
	private function createCache() : void {
		_lastBytesLoaded = _load.bytesLoaded;
		_load.state = LoadState.WAIT;
		_cc.create(createdCache);
	}

	private function createdCache(cc : CacheCreator) : void {
		if (_load.state == LoadState.PAUSED) {
			return;
		}

		_cache = cc.cache;
		fileAddEvent(_cache);

		_load.parameters["loader"] = "divideUpload";

		_load.parameters["originFileName"] = _load.fileName;
		_load.parameters["originExtension"] = _load.extension;
		_load.parameters["originBytesTotal"] = _load.bytesTotal;
		_load.parameters["originBoundary"] = _load.boundary;
		_load.parameters["cacheBytesStart"] = cc.bytesStart;
		_load.parameters["cacheBytesEnd"] = cc.bytesEnd;

		_load.state = LoadState.LOAD;
		_cache.upload(_load.getRequest());
	}

	private function uploadedCache(data : String) : void {
		_result.push(data);
		_load.bytesLoaded = _cc.bytesEnd;
		fileRemoveEvent(_cache);
		_cache = null;

		if (_load.bytesLoaded == _load.bytesTotal) {
			_cc = null;
			_load.state = LoadState.COMPLETE;
			dispatchEvent(new Event(Event.COMPLETE));
			// callback(load);
		} else {
			createCache();
		}
	}

	/* *********************************************************************
	 * event handling
	 ********************************************************************* */
	private function uploadSecurityError(event : SecurityErrorEvent) : void {
		_load.bytesLoaded = _lastBytesLoaded;
		fileRemoveEvent(_cache);
		_cache = null;

		_cc = null;
		_load.state = LoadState.ERROR;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		// callback(load);
	}

	private function uploadIOError(event : IOErrorEvent) : void {
		_load.bytesLoaded = _lastBytesLoaded;
		fileRemoveEvent(_cache);
		_cache = null;

		_cc = null;
		_load.state = LoadState.ERROR;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		// callback(load);
	}

	private function uploadComplete(event : DataEvent) : void {
		uploadedCache(event.data);
	}

	private function uploadProgress(event : ProgressEvent) : void {
		_load.bytesLoaded = _lastBytesLoaded + event.bytesLoaded;
		// _load.bytesTotal = event.bytesTotal;
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