package ssen.common {
import flash.utils.getQualifiedClassName;

/** toString 용으로 사용할 수 있다 */
public function infoToString(obj:Object, props:Object = null):String {
	var arr:Vector.<String>;
	if (props != null) {
		arr = new Vector.<String>();
		for (var key:String in props) {
			arr.push(key + "=" + props[key]);
		}
	}
	var str:String = "[" + getQualifiedClassName(obj).split("::")[1];
	str = (arr == null) ? str + "]" : str + " " + arr.join(" ") + "]";
	return str;
}
}