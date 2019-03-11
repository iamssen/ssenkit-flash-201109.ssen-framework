package ssen.log {
/** 연관배열 형식을 문자열로 변환 */
public function objectParser(objs:Object):String {
	var arr:Array = new Array;
	for (var key:String in objs) {
		arr.push(key + ":" + objs[key]);
	}
	return "{ " + arr.join(",") + " }";
}
}