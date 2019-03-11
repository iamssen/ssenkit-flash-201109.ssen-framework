package ssen.loader {

import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLStream;
import flash.utils.ByteArray;

/** 기본 다운로더 */
public class DefaultDownloader extends FileLoader {

	private var _file : File;

	private var _load : Download;

	private var _fs : FileStream;

	private var _us : URLStream;

	/** @inheritDoc */
	override public function deconstruct() : void {
		_load = null;
		_file = null;
		_us = null;
		_fs = null;
		super.deconstruct();
	}

	/** @inheritDoc */
	override public function start() : void {
		if (load is Download) {
			_load = load as Download;
		} else {
			throw new Error("load is not Download!");
		}

		_load.parameters["loader"] = "defaultDownload";

		_file = _load.folder.resolvePath(_load.fileName + "." + _load.extension);

		var count : int = 0;
		while (_file.exists) {
			count++;
			_file = _load.folder.resolvePath(_load.fileName + "_" + count + "." + _load.extension);
		}

		_fs = new FileStream;
		if (!_file.exists || _file.size <= 0) {
			_fs.open(_file, FileMode.WRITE);
			loadStart();
		} else {
			_fs.openAsync(_file, FileMode.UPDATE);
			_fs.addEventListener(ProgressEvent.PROGRESS, openFileStream);
			_fs.position = _load.bytesLoaded;
		}
	}

	private function openFileStream(event : ProgressEvent) : void {
		_fs.position = _load.bytesLoaded;
		_fs.removeEventListener(ProgressEvent.PROGRESS, openFileStream);

		loadStart();
	}

	private function loadStart() : void {
		_us = new URLStream;
		addEvent(_us);
		_load.state = LoadState.LOAD;

		var req : URLRequest = _load.getRequest();
		if (_load.bytesLoaded > 0) {
			req.requestHeaders = [new URLRequestHeader("Range", "bytes=" + _load.bytesLoaded + "-")];
		}
		_us.load(req);
	}

	/** @inheritDoc */
	override public function cancel() : void {
		_us.close();
		_fs.close();
		removeEvent(_us);
		_load.state = LoadState.PAUSED;
		dispatchEvent(new Event(Event.CANCEL));
		// callback(load);
	}

	/* *********************************************************************
	 * event handling
	 ********************************************************************* */
	private function downloadSecurityError(event : SecurityErrorEvent) : void {
		trace(event);
		removeEvent(_us);
		_fs.close();
		_load.state = LoadState.ERROR;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		// callback(load);
	}

	private function downloadIOError(event : IOErrorEvent) : void {
		trace(event);
		removeEvent(_us);
		_fs.close();
		_load.state = LoadState.ERROR;
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		// callback(load);
	}

	private function downloadComplete(event : Event) : void {
		trace(event);
		_load.bytesLoaded = _load.bytesTotal;
		removeEvent(_us);
		_fs.close();
		_load.state = LoadState.COMPLETE;
		dispatchEvent(new Event(Event.COMPLETE));
		// callback(load);
	}

	private function downloadProgress(event : ProgressEvent) : void {
		if (_us.bytesAvailable > 0) {
			_fs.position = _load.bytesLoaded;
			var bytes : ByteArray = new ByteArray;
			_us.readBytes(bytes, 0, _us.bytesAvailable);
			_fs.writeBytes(bytes, 0, bytes.bytesAvailable);
		}

		_load.bytesLoaded = event.bytesLoaded;
		_load.bytesTotal = event.bytesTotal;
		checkSpeed();
	}

	/* *********************************************************************
	 * event on/off
	 ********************************************************************* */
	private function addEvent(us : URLStream) : void {
		us.addEventListener(IOErrorEvent.IO_ERROR, downloadIOError);
		us.addEventListener(SecurityErrorEvent.SECURITY_ERROR, downloadSecurityError);
		us.addEventListener(ProgressEvent.PROGRESS, downloadProgress);
		us.addEventListener(Event.COMPLETE, downloadComplete);
	}

	private function removeEvent(us : URLStream) : void {
		us.addEventListener(Event.COMPLETE, downloadComplete);
		us.removeEventListener(IOErrorEvent.IO_ERROR, downloadIOError);
		us.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, downloadSecurityError);
		us.removeEventListener(ProgressEvent.PROGRESS, downloadProgress);
	}
}
}