package ssen.common {

/** IUniqueable 을 지원하는 unique id 관리자 */
public class Unique {
	private static var _count:uint = 0;

	/** 새로운 unique id 를 가져온다 */
	public static function getUniqueNumber():uint {
		return _count++;
	}
}
}