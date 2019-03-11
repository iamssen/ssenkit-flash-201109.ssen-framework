package ssen.common {

/** 상수 목록을 만들때 사용 */
public class Enumeration {
	private var _annotation:String;

	/** 주석 */
	public function get annotation():String {
		return _annotation;
	}

	public function Enumeration(annotation:String = "") {
		_annotation = annotation;
	}

	public function toString():String {
		return infoToString(this, { annotation: annotation });
	}

}
}