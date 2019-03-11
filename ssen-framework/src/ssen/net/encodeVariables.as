package ssen.net {
import flash.utils.ByteArray;

public function encodeVariables(vars:Object, charSet:String):ByteArray {
	var bytes:ByteArray = new ByteArray;
	var and:String = "&";
	
	for (var key:String in vars) {
		bytes.writeMultiByte(key + "=" + vars[key] + and, charSet);
		and = "";
	}
	
	bytes.position = 0;
	var encoded:String = encodeURIComponent(bytes.readMultiByte(bytes.bytesAvailable,
																"utf-8"));
	bytes.clear();
	bytes.writeMultiByte(encoded, "euc-kr");
	
	return bytes;
}
}