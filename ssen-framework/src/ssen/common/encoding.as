package ssen.common {
import flash.utils.ByteArray;

public function encoding(str:String, charSet:String):String {
	var bytes:ByteArray = new ByteArray;
	bytes.writeMultiByte(str, charSet);
	bytes.position = 0;
	trace(bytes.bytesAvailable);
	var str:String = bytes.readMultiByte(bytes.bytesAvailable, "utf-8");
	trace(str, str.length);
	
	return str;
}
}