package ssen.serialize {
import com.googlecode.flexxb.FlexXBEngine;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class XMLFileSerializer implements ISerializer {
	/** target file */
	public var file:File;

	/** @inheritDoc */
	public function read(callback:Function):void {
		var stream:FileStream = new FileStream;
		stream.open(file, FileMode.READ);
		callback(FlexXBEngine.instance.deserialize(new XML(stream.readUTFBytes(stream.bytesAvailable))));
		stream.close();
	}

	/** @inheritDoc */
	public function write(object:*, callback:Function):void {
		try {
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes('<?xml version="1.0" encoding="utf-8"?>\n' + FlexXBEngine.instance.serialize(object).toXMLString());
			stream.close();
			callback(true);
		} catch (error:Error) {
			callback(false);
		}
	}
}
}