package ssen.loader {
import flash.filesystem.File;

/** 업로드 */
public class Upload extends Load {
	private var _local : File;

	/** 업로드 할 파일 */
	[Bindable("localFileChanged")]
	public function get local() : File {
		return _local;
	}

	public function set local(file : File) : void {
		_local = file;

		bytesLoaded = 0;
		bytesTotal = _local.size;

		label = file.name;

		dispatchEvent(new LoadEvent(LoadEvent.LOCAL_FILE_CHANGED));
	}
}
}