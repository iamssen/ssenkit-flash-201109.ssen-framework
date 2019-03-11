package ssen.loader {

import ssen.common.MathX;
import ssen.common.infoToString;

import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;

[Event(name="bytesChanged", type="ssen.loader.LoadEvent")]
[Event(name="nameChanged", type="ssen.loader.LoadEvent")]
[Event(name="stateChanged", type="ssen.loader.LoadEvent")]
[Event(name="urlChanged", type="ssen.loader.LoadEvent")]
/** 로드 */
public class Load extends EventDispatcher {
	private var _parameters : Dictionary = new Dictionary;
	/** 로드할 총 bytes 수량 */
	private var _bytesTotal : Number = 0;
	/** 로드된 총 bytes 수량 */
	private var _bytesLoaded : Number = 0;
	/** 파일의 이름, 확장자 제외 */
	private var _fileName : String;
	/** 파일의 확장자 */
	private var _extension : String;
	/** 로드의 상태 */
	private var _state : LoadState = LoadState.READY;
	/** Bytes per sec */
	private var _bytesPerSec : int;
	/** Request url */
	private var _url : String;
	/** 로드의 고유값 랜덤 20자리 16진수 */
	public var boundary : String = MathX.randHex(20);
	private var _label : String;

	/** Request parameter */
	public function get parameters() : Dictionary {
		return _parameters;
	}

	/** Request 정보들을 종합해서 가져온다 */
	public function getRequest() : URLRequest {
		var req : URLRequest = new URLRequest(url);
		var vars : URLVariables = new URLVariables;

		var k : String;
		for (k in parameters) {
			vars[k] = parameters[k];
		}

		req.method = URLRequestMethod.POST;
		req.data = vars;

		return req;
	}

	/** 응답으로 돌아온 Data */
	public var resultData : *;

	override public function toString() : String {
		return infoToString(this, {fileName:fileName, extension:extension, bytesLoaded:bytesLoaded, bytesTotal:bytesTotal});
	}

	/* *********************************************************************
	 * variables
	 ********************************************************************* */
	[Bindable(event="bytesChanged")]
	public function get bytesTotal() : Number {
		return _bytesTotal;
	}

	public function set bytesTotal(bytesTotal : Number) : void {
		_bytesTotal = bytesTotal;
		dispatchEvent(new LoadEvent(LoadEvent.BYTES_CHANGED));
	}

	[Bindable(event="bytesChanged")]
	public function get bytesLoaded() : Number {
		return _bytesLoaded;
	}

	public function set bytesLoaded(bytesLoaded : Number) : void {
		_bytesLoaded = bytesLoaded;
		dispatchEvent(new LoadEvent(LoadEvent.BYTES_CHANGED));
	}

	[Bindable(event="bytesChanged")]
	public function get bytesPerSec() : int {
		return _bytesPerSec;
	}

	public function set bytesPerSec(bytesPerSec : int) : void {
		_bytesPerSec = bytesPerSec;
		dispatchEvent(new LoadEvent(LoadEvent.BYTES_CHANGED));
	}

	[Bindable(event="nameChanged")]
	public function get fileName() : String {
		return _fileName;
	}

	public function set fileName(fileName : String) : void {
		_fileName = fileName;
		dispatchEvent(new LoadEvent(LoadEvent.NAME_CHANGED));
	}

	[Bindable(event="nameChanged")]
	public function get extension() : String {
		return _extension;
	}

	public function set extension(extension : String) : void {
		_extension = extension;
		dispatchEvent(new LoadEvent(LoadEvent.NAME_CHANGED));
	}

	[Bindable(event="nameChanged")]
	public function get label() : String {
		return _label;
	}

	public function set label(label : String) : void {
		_label = label;
		var arr : Array = label.split(".");
		_extension = arr.pop();
		_fileName = arr.join(".");
		dispatchEvent(new LoadEvent(LoadEvent.NAME_CHANGED));
	}

	[Bindable(event="stateChanged")]
	public function get state() : LoadState {
		return _state;
	}

	public function set state(state : LoadState) : void {
		_state = state;
		dispatchEvent(new LoadEvent(LoadEvent.STATE_CHANGED));
	}

	[Bindable(event="urlChanged")]
	public function get url() : String {
		return _url;
	}

	public function set url(url : String) : void {
		_url = url;
		dispatchEvent(new LoadEvent(LoadEvent.URL_CHANGED));
	}
}
}