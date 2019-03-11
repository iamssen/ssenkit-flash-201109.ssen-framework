package ssen.logic.context {

[DefaultProperty("commands")]

final public class trigger {
	public var type:Class;
	
	public var to:String;
	
	public var commands:Vector.<command>;
}
}