package ssen.serialize {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

final public class BytesFileSerializer implements ISerializer {
	/** target file */
	public var file:File;

	/** @inheritDoc */
	public function read(callback:Function):void {
		var stream:FileStream = new FileStream;
		stream.open(file, FileMode.READ);
		callback(stream.readObject());
		stream.close();
	}

	/** @inheritDoc */
	public function write(object:*, callback:Function):void {
		try {
			var stream:FileStream = new FileStream;
			stream.open(file, FileMode.WRITE);
			stream.writeObject(object);
			stream.close();
			callback(true);
		} catch (error:Error) {
			callback(false);
		}
	}

}
}