package ssen.common {
import flash.utils.getQualifiedClassName;

/** :: 대신 \. 을 사용함 */
public function getQualifiedClassName2(value:*):String {
	var str:String = getQualifiedClassName(value);
	return str.replace("::", ".");
}
}