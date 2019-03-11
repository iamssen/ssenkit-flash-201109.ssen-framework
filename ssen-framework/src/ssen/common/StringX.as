package ssen.common {

/**
 * 문자열 관련 util
 */
public class StringX {
	/** file name 을 제목과 확장자로 분리해준다 */
	public static function parseFileName(fileName:String):Array {
		var arr:Array = fileName.split(".");
		var extension:String = arr.pop();
		return [ arr.join("."), extension ];
	}

	/** 앞뒤 공백을 없애준다 */
	public static function clearBlank(text:String):String {
		return text.replace(/^\s*|\s*$/g, "");
	}
}
}
