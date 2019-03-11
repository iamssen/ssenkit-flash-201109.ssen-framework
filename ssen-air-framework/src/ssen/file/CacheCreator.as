package ssen.file {

import ssen.common.IDeconstructable;

import flash.events.Event;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

/** 특정 파일의 Bytes 를 잘라서 분할한 Cache 파일을 만들어낸다 */
public class CacheCreator implements IDeconstructable {

	private static var tempDirectories : Vector.<File> = new Vector.<File>();

	private static var _clearTempCallback : Function;

	public static function getNewTempDirectory() : File {
		var dir : File = File.createTempDirectory();
		tempDirectories.push(dir);
		return dir;
	}

	private static var _f : int;

	private static var _temp : File;

	public static function clear(callback : Function) : void {
		_clearTempCallback = callback;
		_f = tempDirectories.length;

		deleteTempDirectory();
	}

	private static function deleteTempDirectory() : void {
		if (--_f >= 0) {
			_temp = tempDirectories[_f];
			_temp.addEventListener(Event.COMPLETE, deleteComplete);
			_temp.deleteDirectoryAsync(true);
		} else {
			tempDirectories.length = 0;
			_clearTempCallback();
			_clearTempCallback = null;
		}
	}

	private static function deleteComplete(event : Event) : void {
		_temp.removeEventListener(Event.COMPLETE, deleteComplete);
		deleteTempDirectory();
	}

	/* *********************************************************************
	 * global info
	 ********************************************************************* */
	private var _file : File;

	private var _gdivide : Number;

	private var _caches : File;

	private var _reader : FileStream;

	/* *********************************************************************
	 * divide info
	 ********************************************************************* */
	private var _bytesStart : Number;

	private var _read : Number;

	private var _writer : FileStream;

	private var _bytesEnd : Number;

	private var _callback : Function;

	/* *********************************************************************
	 * callback
	 ********************************************************************* */
	/** 잘라진 cache 의 원본 byte 시작점 입니다. */
	public var bytesStart : Number = 0;

	/** 잘라진 cache 의 원본 byte 끝점 입니다. */
	public var bytesEnd : Number = 0;

	/** 잘라진 cache 입니다. */
	public var cache : File;

	/**
	 * 새로운 Cache Creator 를 만듭니다.
	 * @param file 원본 파일
	 * @param divide 기본 자를 byte 분량
	 */
	public function CacheCreator(file : File, divide : Number = 0) {
		if (divide == 0) {
			divide = 1024 * 1024 * 50;
		}

		// _caches = File.createTempDirectory();
		_file = file;
		_gdivide = divide;
		_reader = new FileStream;

		bytesStart = 0;
		bytesEnd = 0;
	}

	// private var _orcallback : Function;
	//
	// private var _orbytesStart : Number;
	//
	// private var _ordivide : Number;
	/**
	 * 새로운 cache 를 자르기 시작합니다.
	 * @param callback 자르기가 끝나면 반환해줄 callback function(this) 입니다.
	 * @param bytesStart 자르기 시작할 위치 입니다, 입력하지 않으면 마지막 지점에서 시작합니다.
	 * @param divide 자를 분량 입니다, 입력하지 않으면 기본 입력된 분량으로 자릅니다.
	 */
	public function create(callback : Function, bytesStart : Number = -1, divide : Number = 0) : void {
		_caches = getNewTempDirectory();

		// _orcallback = callback;
		// _orbytesStart = bytesStart;
		// _ordivide = divide;

		// if (cache) {
		// cache.deleteFile();
		// }

		if (bytesStart > -1) {
			_bytesStart = bytesStart;
		} else {
			_bytesStart = this.bytesEnd;
		}

		if (divide > 0) {
			_read = divide;
		} else {
			_read = _gdivide;
		}

		if (_bytesStart + _read > _file.size) {
			_read = _file.size - _bytesStart;
		}

		_callback = callback;
		_bytesEnd = _bytesStart + _read;

		cache = _caches.resolvePath(_file.name + "_" + _bytesStart + "_" + (_bytesStart + _read) + ".dividedfile");
		_writer = new FileStream;
		_writer.open(cache, FileMode.WRITE);

		_reader.addEventListener(ProgressEvent.PROGRESS, open);
		_reader.openAsync(_file, FileMode.READ);
	}

	public function cancel() : void {
		try {
			_reader.removeEventListener(ProgressEvent.PROGRESS, read);
			_reader.close();
			deconstruct();
		} catch (error : Error) {
			trace(error);
		}
	}

	private function open(event : ProgressEvent) : void {
		_reader.removeEventListener(ProgressEvent.PROGRESS, open);

		_reader.position = _bytesStart;

		_reader.addEventListener(ProgressEvent.PROGRESS, read);
	}

	private function read(event : ProgressEvent) : void {
		var length : Number = (_reader.bytesAvailable >= _read) ? _read : _reader.bytesAvailable;
		var bytes : ByteArray = new ByteArray;
		_reader.readBytes(bytes, 0, length);
		_writer.writeBytes(bytes);

		_read -= length;

		if (_read == 0) {
			_reader.removeEventListener(ProgressEvent.PROGRESS, read);
			_reader.close();
			_writer.close();

			// var divided:DividedFileInfo = new DividedFileInfo;
			// divided.original = _original;
			// divided.file = _cache;
			// divided.startByte = _readStartPosition;
			// divided.endByte = _readEndPosition;

			// _caches.addEventListener(Event.COMPLETE, cachesDeleted);
			// _caches.deleteDirectoryAsync(true);

			bytesStart = _bytesStart;
			bytesEnd = _bytesEnd;
			_callback(this);

			_callback = null;
			_writer = null;
		}
	}

	/** @inheritDoc */
	public function deconstruct() : void {
		cache = null;
		_file = null;
		_reader = null;
		// _caches.moveToTrash();
	}
}
}