package ssen.serialize {

public interface ISerializer {
	function read(callback:Function):void;
	function write(object:*, callback:Function):void;
}
}